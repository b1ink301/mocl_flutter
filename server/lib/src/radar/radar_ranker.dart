import 'dart:math';

import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import 'clusterer.dart';
import 'radar_boards.dart';
import 'radar_store.dart';
import 'title_features.dart';

/// 이슈 하나와 그 점수를 이룬 값(튜닝 · `radar_eval` 용, 앱에는 나가지 않는다).
class const ScoredIssue(
  final Issue issue,

  /// 새로움을 곱하기 전 점수.
  final double base,

  /// 0~1. 이 이야기의 핵심 말이 이슈가 시작되기 전에는 얼마나 드물었나.
  final double novelty,
);

/// 쌓인 글로 이슈 목록을 만든다(묶기 → 점수 → 정렬).
///
/// 점수 = Σ 글 점수 × (1 + 0.5 × (걸친 사이트 수 − 1)) × 새로움 보정
/// - 글 점수 = 게시판 가중치 × 신선도(반감기 [halfLife]) × (1 + 반응)
///   × 같은 사이트 안 순번 감쇠(같은 사이트 i번째 글은 1/(i+1)^[siteDecay]).
///   한 커뮤니티가 같은 이야기를 수십 개 올려도(엠팍 주식 수다) 점수가 그만큼
///   불어나지 않게 한다.
/// - 반응 = 사이트 안 반응 백분위와 반응 속도 백분위의 섞음([velocityWeight]).
///   반응 수치는 사이트마다 주는 게 달라(댓글 · 조회 · 추천 · 없음) 같은 사이트
///   안에서의 순위로만 쓴다. 속도는 최근 [velocityWindow] 동안 늘어난 양이다.
/// - 새로움 보정 = (1 − [noveltyWeight]) + [noveltyWeight] × 새로움.
///   새로움은 묶음의 핵심 말([signatureSize]개)이 이슈 시작 전 쌓인 글에 하루 몇 번
///   나왔는지로 본다. "코스피" · "민주당" 처럼 늘 나오는 말뿐인 묶음은 내려가고,
///   "서킷브레이커" 처럼 갑자기 나온 말이 있는 묶음은 그대로 남는다.
///
/// 글 시각은 사이트 값 대신 서버가 처음 본 시각을 쓴다.
class const RadarRanker({
  final Clusterer clusterer = const Clusterer(),
  final List<RadarBoard> boards = radarBoards,

  /// 묶을 글의 범위(처음 본 시각 기준).
  final Duration window = const Duration(hours: 24),
  final Duration halfLife = const Duration(hours: 3),
  final Duration trendWindow = const Duration(minutes: 30),
  final int maxIssues = 50,
  final int maxPostsPerIssue = 30,

  /// 같은 사이트의 글이 여럿일 때 i번째 글의 감쇠 지수(0 이면 감쇠 없음).
  final double siteDecay = 0.5,

  /// 반응 = (1 − w) × 반응 백분위 + w × 속도 백분위. 0 이면 속도를 보지 않는다.
  final double velocityWeight = 0.5,
  final Duration velocityWindow = const Duration(minutes: 30),

  /// 새로움 보정의 세기(0 이면 보지 않는다).
  final double noveltyWeight = 0.6,

  /// 핵심 말이 이슈 전에 하루 이만큼 나왔으면 새로움 0.5.
  final double noveltyHalfPerDay = 6,
  final int signatureSize = 4,

  /// 이슈 시작 전 쌓인 기록이 이보다 짧으면 새로움을 판단하지 않는다(서버를 막 켰을 때).
  final Duration noveltyMinHistory = const Duration(hours: 6),
}) {
  IssueFeed rank(
    List<RadarPost> all,
    int now, {
    Set<String> failing = const {},
  }) => IssueFeed(
    generatedAt: now,
    communities: <SiteType>{
      for (final b in boards)
        if (!failing.contains(b.key)) b.site,
    }.toList(),
    issues: [for (final s in score(all, now).take(maxIssues)) s.issue],
  );

  /// 점수 순으로 정렬한 이슈 전부.
  List<ScoredIssue> score(List<RadarPost> all, int now) {
    final List<RadarPost> posts = [
      for (final p in all)
        if (now - p.firstSeenAt <= window.inMilliseconds) p,
    ];
    final Map<String, RadarPost> byKey = {for (final p in posts) p.key: p};
    // 비교할 "이전 30분" 이 쌓이기 전(서버를 막 켰을 때)에는 급상승을 판단하지 않는다.
    final bool canTrend =
        all.isNotEmpty &&
        now - all.map((p) => p.firstSeenAt).reduce(min) >=
            2 * trendWindow.inMilliseconds;
    final Map<String, double> reaction = _reactions(posts, now);
    final Map<String, double> weight = {
      for (final b in boards) '${b.site.name}|${b.board}': b.weight,
    };
    final _History history = _History(all);

    final List<Cluster> clusters = clusterer.run([
      for (final p in posts)
        ClusterInput(p.key, p.site, p.title, p.firstSeenAt),
    ]);

    final List<ScoredIssue> issues = [];
    for (final Cluster c in clusters) {
      final Set<String> sites = c.sites;
      // 여러 커뮤니티에 걸치거나, 한 곳이라도 글이 여럿 몰린 묶음만 이슈로 본다.
      if (sites.length < 2 && c.members.length < 3) continue;

      final List<RadarPost> members = [
        for (final m in c.members) byKey[m.key]!,
      ];

      // 사이트별로 글 점수를 높은 순으로 놓고 순번만큼 줄여 더한다.
      final Map<String, List<double>> perSiteScores = {};
      for (final RadarPost p in members) {
        final double age = (now - p.firstSeenAt) / halfLife.inMilliseconds;
        (perSiteScores[p.site] ??= []).add(
          (weight['${p.site}|${p.board}'] ?? 0.5) *
              pow(0.5, max(0, age)) *
              (1 + (reaction[p.key] ?? 0.5)),
        );
      }
      double base = 0;
      for (final List<double> scores in perSiteScores.values) {
        scores.sort((a, b) => b.compareTo(a));
        for (int i = 0; i < scores.length; i++) {
          base += scores[i] / pow(i + 1, siteDecay);
        }
      }
      base *= 1 + 0.5 * (sites.length - 1);

      final double novelty = _novelty(c, members, history);
      final double score =
          base * ((1 - noveltyWeight) + noveltyWeight * novelty);

      final int recentFrom = now - trendWindow.inMilliseconds;
      final int prevFrom = recentFrom - trendWindow.inMilliseconds;
      final int recent = members
          .where((p) => p.firstSeenAt >= recentFrom)
          .length;
      final int previous = members
          .where((p) => p.firstSeenAt >= prevFrom && p.firstSeenAt < recentFrom)
          .length;
      // 최근 30분에 새로 합류한 커뮤니티가 있는지
      final Set<String> sitesBefore = {
        for (final p in members)
          if (p.firstSeenAt < recentFrom) p.site,
      };
      final bool newSite =
          sites.length >= 2 &&
          sitesBefore.length < sites.length &&
          sitesBefore.isNotEmpty;
      final bool trending =
          canTrend && ((recent >= 2 && recent > previous) || newSite);

      // 커뮤니티: 글이 많은 순
      final Map<String, int> perSite = {};
      for (final p in members) {
        perSite[p.site] = (perSite[p.site] ?? 0) + 1;
      }
      final List<String> siteOrder = perSite.keys.toList()
        ..sort((a, b) => perSite[b]!.compareTo(perSite[a]!));

      final List<RadarPost> shown = [...members]
        ..sort((a, b) {
          final int bySite = siteOrder
              .indexOf(a.site)
              .compareTo(siteOrder.indexOf(b.site));
          return bySite != 0 ? bySite : a.firstSeenAt.compareTo(b.firstSeenAt);
        });

      issues.add(
        ScoredIssue(
          Issue(
            id: issueId(c.members.first.key),
            title: c.representative.title,
            sites: [for (final s in siteOrder) ?_site(s)],
            firstSeenAt: members.map((p) => p.firstSeenAt).reduce(min),
            lastSeenAt: members.map((p) => p.firstSeenAt).reduce(max),
            score: score,
            trending: trending,
            posts: [
              for (final p in shown.take(maxPostsPerIssue))
                if (_site(p.site) case final SiteType site)
                  IssuePost(
                    site: site,
                    title: p.title,
                    url: p.url,
                    firstSeenAt: p.firstSeenAt,
                    reply: p.latest?.reply ?? -1,
                  ),
            ],
          ),
          base,
          novelty,
        ),
      );
    }
    issues.sort((a, b) => b.issue.score.compareTo(a.issue.score));
    return issues;
  }

  /// 묶음의 핵심 말이 이슈 시작 전에 얼마나 드물었나(0~1, 1 이 처음 보는 말).
  double _novelty(Cluster c, List<RadarPost> members, _History history) {
    if (noveltyWeight <= 0) return 1;
    final int start = members.map((p) => p.firstSeenAt).reduce(min);
    final double hours = (start - history.oldest) / 3600000;
    if (hours < noveltyMinHistory.inMinutes / 60) return 1;

    // 핵심 말: 중심에서 무게가 큰 단어 · 단어 쌍(2-gram 은 조각이라 뺀다).
    final List<MapEntry<String, double>> signature =
        c.centroid.entries.where((e) => !e.key.startsWith('b:')).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    double sum = 0;
    double weights = 0;
    for (final MapEntry<String, double> e in signature.take(signatureSize)) {
      final double perDay = history.countBefore(e.key, start) / hours * 24;
      sum += e.value / (1 + perDay / noveltyHalfPerDay);
      weights += e.value;
    }
    return weights == 0 ? 1 : sum / weights;
  }

  static SiteType? _site(String name) =>
      SiteType.values.where((s) => s.name == name).firstOrNull;

  /// 묶음의 첫 글 키로 만든 짧은 id(FNV-1a 32bit).
  static String issueId(String firstKey) {
    int h = 0x811c9dc5;
    for (final int c in firstKey.codeUnits) {
      h ^= c;
      h = (h * 0x01000193) & 0xffffffff;
    }
    return 'i_${h.toRadixString(16).padLeft(8, '0')}';
  }

  /// 글마다 반응 점수(0~1). 사이트 안 반응 백분위와 속도 백분위를 섞는다.
  Map<String, double> _reactions(List<RadarPost> posts, int now) {
    final Map<String, double> level = _percentiles(posts, metric);
    if (velocityWeight <= 0) return level;
    final Map<String, double> speed = _percentiles(
      posts,
      (p) => velocity(p, now, velocityWindow),
    );
    return {
      for (final MapEntry<String, double> e in level.entries)
        e.key: switch (speed[e.key]) {
          final double v => (1 - velocityWeight) * e.value + velocityWeight * v,
          null => e.value,
        },
    };
  }

  /// 반응 수치. 댓글 → 추천 → 조회 순으로 사이트가 주는 값을 쓴다. 없으면 -1.
  static int metric(RadarPost p) {
    final RadarSample? s = p.latest;
    if (s == null) return -1;
    if (s.reply >= 0) return s.reply;
    if (s.like >= 0) return s.like;
    return s.hit;
  }

  /// 최근 [window] 동안 반응이 시간당 얼마나 늘었나. 모르면 -1.
  ///
  /// 게시판 1쪽에서 밀려나 더 받지 않는 글은 0(식은 글). 기록 간격이 4분이 안
  /// 되면(막 들어온 글) 모른다.
  static double velocity(RadarPost p, int now, Duration window) {
    final RadarSample? last = p.latest;
    if (last == null) return -1;
    if (now - last.at > 15 * 60 * 1000) return 0;
    final int Function(RadarSample) field = last.reply >= 0
        ? (s) => s.reply
        : last.like >= 0
        ? (s) => s.like
        : (s) => s.hit;
    if (field(last) < 0) return -1;
    final RadarSample first = p.samples.firstWhere(
      (s) => s.at >= last.at - window.inMilliseconds && field(s) >= 0,
      orElse: () => last,
    );
    final int span = last.at - first.at;
    if (span < 4 * 60 * 1000) return -1;
    return max(0, field(last) - field(first)) / (span / 3600000);
  }

  /// 사이트 안 백분위(0~1, 같은 값은 평균 순위). 값이 음수(모름)인 글은 빠진다.
  static Map<String, double> _percentiles(
    List<RadarPost> posts,
    num Function(RadarPost) value,
  ) {
    final Map<String, List<(String, num)>> bySite = {};
    for (final p in posts) {
      final num v = value(p);
      if (v < 0) continue;
      (bySite[p.site] ??= []).add((p.key, v));
    }
    final Map<String, double> result = {};
    for (final List<(String, num)> group in bySite.values) {
      if (group.length < 2) continue;
      group.sort((a, b) => a.$2.compareTo(b.$2));
      int i = 0;
      while (i < group.length) {
        int j = i;
        while (j + 1 < group.length && group[j + 1].$2 == group[i].$2) {
          j++;
        }
        final double pct = (i + j) / 2 / (group.length - 1);
        for (int k = i; k <= j; k++) {
          result[group[k].$1] = pct;
        }
        i = j + 1;
      }
    }
    return result;
  }
}

/// 쌓인 글 전부(48시간)에서 단어 · 단어 쌍이 나온 시각들. 새로움 계산용.
class _History(final List<RadarPost> _all) {
  late final int oldest = _all.isEmpty
      ? 0
      : _all.map((p) => p.firstSeenAt).reduce(min);

  late final Map<String, List<int>> _times = () {
    final Map<String, List<int>> times = {};
    for (final RadarPost p in _all) {
      for (final String f in TitleFeatures.raw(p.title).keys) {
        if (f.startsWith('b:')) continue;
        (times[f] ??= []).add(p.firstSeenAt);
      }
    }
    for (final List<int> t in times.values) {
      t.sort();
    }
    return times;
  }();

  /// [feature] 가 [before] 전에 처음 보인 글 수.
  int countBefore(String feature, int before) {
    final List<int>? t = _times[feature];
    if (t == null) return 0;
    int lo = 0;
    int hi = t.length;
    while (lo < hi) {
      final int mid = (lo + hi) >> 1;
      if (t[mid] < before) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }
}
