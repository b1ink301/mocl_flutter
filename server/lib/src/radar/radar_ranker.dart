import 'dart:math';

import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import 'clusterer.dart';
import 'radar_boards.dart';
import 'radar_store.dart';

/// 쌓인 글로 이슈 목록을 만든다(묶기 → 점수 → 정렬).
///
/// 점수 = Σ 게시판 가중치 × 신선도(반감기 [halfLife]) × (1 + 사이트 안 반응 백분위)
///        × (1 + 0.5 × (걸친 사이트 수 − 1))
/// 반응 수치는 사이트마다 주는 게 달라(댓글 · 조회 · 추천 · 없음) 같은 사이트 안에서의
/// 순위로만 쓴다. 글 시각은 사이트 값 대신 서버가 처음 본 시각을 쓴다.
class const RadarRanker({
  final Clusterer clusterer = const Clusterer(),
  final List<RadarBoard> boards = radarBoards,

  /// 묶을 글의 범위(처음 본 시각 기준).
  final Duration window = const Duration(hours: 24),
  final Duration halfLife = const Duration(hours: 3),
  final Duration trendWindow = const Duration(minutes: 30),
  final int maxIssues = 50,
  final int maxPostsPerIssue = 30,
}) {
  IssueFeed rank(
    List<RadarPost> all,
    int now, {
    Set<String> failing = const {},
  }) {
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
    final Map<String, double> percentile = _percentiles(posts);
    final Map<String, double> weight = {
      for (final b in boards) '${b.site.name}|${b.board}': b.weight,
    };

    final List<Cluster> clusters = clusterer.run([
      for (final p in posts)
        ClusterInput(p.key, p.site, p.title, p.firstSeenAt),
    ]);

    final List<Issue> issues = [];
    for (final Cluster c in clusters) {
      final Set<String> sites = c.sites;
      // 여러 커뮤니티에 걸치거나, 한 곳이라도 글이 여럿 몰린 묶음만 이슈로 본다.
      if (sites.length < 2 && c.members.length < 3) continue;

      double score = 0;
      for (final ClusterInput m in c.members) {
        final RadarPost p = byKey[m.key]!;
        final double age = (now - p.firstSeenAt) / halfLife.inMilliseconds;
        score +=
            (weight['${p.site}|${p.board}'] ?? 0.5) *
            pow(0.5, max(0, age)) *
            (1 + (percentile[p.key] ?? 0.5));
      }
      score *= 1 + 0.5 * (sites.length - 1);

      final List<RadarPost> members = [
        for (final m in c.members) byKey[m.key]!,
      ];
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
      );
    }
    issues.sort((a, b) => b.score.compareTo(a.score));

    return IssueFeed(
      generatedAt: now,
      communities: <SiteType>{
        for (final b in boards)
          if (!failing.contains(b.key)) b.site,
      }.toList(),
      issues: issues.take(maxIssues).toList(),
    );
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

  /// 사이트 안에서 반응 순위(0~1). 댓글 → 추천 → 조회 순으로 있는 값을 쓴다.
  static Map<String, double> _percentiles(List<RadarPost> posts) {
    int metric(RadarPost p) {
      final RadarSample? s = p.latest;
      if (s == null) return -1;
      if (s.reply >= 0) return s.reply;
      if (s.like >= 0) return s.like;
      return s.hit;
    }

    final Map<String, List<RadarPost>> bySite = {};
    for (final p in posts) {
      (bySite[p.site] ??= []).add(p);
    }
    final Map<String, double> result = {};
    for (final List<RadarPost> group in bySite.values) {
      final List<RadarPost> ranked = group.where((p) => metric(p) >= 0).toList()
        ..sort((a, b) => metric(a).compareTo(metric(b)));
      if (ranked.length < 2) continue;
      for (int i = 0; i < ranked.length; i++) {
        result[ranked[i].key] = i / (ranked.length - 1);
      }
    }
    return result;
  }
}
