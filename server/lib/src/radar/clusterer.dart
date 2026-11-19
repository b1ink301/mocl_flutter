import 'dart:math';

import 'title_features.dart';

/// 묶을 글 하나(저장소 형식과 떨어뜨려 테스트하기 쉽게).
class const ClusterInput(
  final String key,
  final String site,
  final String title,
  final int at,
);

/// 묶음 하나. [members] 는 들어온 순서(= firstSeenAt 순).
class Cluster(final int index) {
  final List<ClusterInput> members = [];

  /// [members] 와 같은 순서의 특징 벡터(대표 제목 고를 때 쓴다).
  final List<Map<String, double>> vectors = [];
  final Map<String, double> _sum = {};
  Map<String, double>? _centroid;

  Map<String, double> get centroid => _centroid ??= Idf.normalize(_sum);

  Set<String> get sites => {for (final m in members) m.site};

  /// 중심에 가장 가까운 글(대표).
  ClusterInput get representative {
    int best = 0;
    double bestSim = -1;
    for (int i = 0; i < members.length; i++) {
      final double sim = Idf.cosine(vectors[i], centroid);
      if (sim > bestSim) {
        bestSim = sim;
        best = i;
      }
    }
    return members[best];
  }

  void add(ClusterInput input, Map<String, double> vector) {
    members.add(input);
    vectors.add(vector);
    vector.forEach((k, v) => _sum[k] = (_sum[k] ?? 0) + v);
    _centroid = null;
  }

  /// [other] 의 글을 모두 받아 들인다. 순서는 처음 본 순서로 다시 맞춘다
  /// (첫 글이 이슈 id 가 되므로).
  void absorb(Cluster other) {
    final List<(ClusterInput, Map<String, double>)> all = [
      for (int i = 0; i < members.length; i++) (members[i], vectors[i]),
      for (int i = 0; i < other.members.length; i++)
        (other.members[i], other.vectors[i]),
    ]..sort((a, b) => Clusterer.compareInputs(a.$1, b.$1));
    members
      ..clear()
      ..addAll(all.map((e) => e.$1));
    vectors
      ..clear()
      ..addAll(all.map((e) => e.$2));
    other._sum.forEach((k, v) => _sum[k] = (_sum[k] ?? 0) + v);
    _centroid = null;
  }
}

/// 제목이 비슷한 글을 묶는다(증분 · 결정적).
///
/// 글을 처음 본 순서대로 넣으면서 가장 비슷한 묶음에 합류시키고, 맞는 묶음이
/// 없으면 새 묶음을 만든다. 합류 조건(짧은 제목은 코사인만으로는 갈리지 않는다):
/// - 묶음 중심과 코사인 ≥ [threshold], 또는
/// - 중심과 코사인 ≥ [weakThreshold] 이면서 묶음 안의 **어떤 글 하나와** 근거가 있을 때
///   — 이웃 단어 쌍("아이폰 듀오")을 함께 갖거나 단어를 2개 이상 함께 가짐.
///   단어 하나("반도체")만 겹치면 묶지 않는다. 서술어 · 어미가 낀 말("뭔가요")은
///   근거로 세지 않는다([contentEvidence]).
/// 후보가 여럿이면 중심 코사인이 높은 묶음부터 본다. 묶음의 마지막 글에서
/// [maxGap] 넘게 지난 글은 합류하지 않는다(매일 나오는 주제가 한 이슈가 되지 않게).
///
/// 근거를 중심(모든 글의 특징을 더한 것)과 따지면, A 글과 단어 하나 · B 글과 단어
/// 하나만 겹쳐도 "단어 2개 공유" 가 되어 묶음이 클수록 엉뚱한 글이 이어 붙는다
/// ([memberLink]). 코사인은 중심과 본다 — 글 하나와 보면 흔한 쌍("리트 만점자")을
/// 공유하는 긴 제목이 0.2 에 못 미쳐 같은 사건에서 떨어져 나가고, 한 단어 제목
/// ("[여농] 사쿠라")은 글 하나와 쉽게 0.45 를 넘어 엉뚱한 글과 붙었다(실데이터 확인).
/// 비교는 특징을 하나라도 공유하는 묶음만(역색인) 한다.
///
/// 증분 방식이라 들어온 순서에 따라 같은 이야기가 두 묶음으로 갈릴 수 있다
/// ("코스피 5천 붕괴" 묶음이 커진 뒤에야 "5천피 붕괴" 묶음과 닮아진다). 그래서 다 넣은
/// 뒤 묶음 중심끼리 다시 비교해 합친다([merge]): 중심 코사인 ≥ [threshold] 이거나,
/// ≥ [mergeWeakThreshold] 이면서 두 묶음에서 한 글씩 뽑은 쌍에 근거가 있을 때.
/// 두 묶음의 시간대 사이가 [maxGap] 을 넘으면 합치지 않는다.
class const Clusterer({
  final double threshold = 0.45,
  final double weakThreshold = 0.2,

  /// 이 비율보다 많은 글에 나오는 특징은 후보를 찾는 데 쓰지 않는다(너무 흔함).
  final double maxDfRatio = 0.05,

  /// 다 묶은 뒤 비슷한 묶음끼리 합칠지.
  final bool merge = true,

  /// 합칠 후보로 볼 중심 코사인 하한. 중심은 글보다 단어가 많아 우연히 겹치기 쉬우므로
  /// 합류 후보([weakThreshold])보다 엄하게 본다.
  final double mergeWeakThreshold = 0.3,

  /// 합류 · 합치기 근거를 묶음 안의 글 하나와 따질지. false 면 옛 방식(근거도 중심과
  /// 따짐) — 비교 도구(`radar_eval --diff`) · 테스트용.
  final bool memberLink = true,

  /// 묶음의 마지막 글에서 이 시간 안에 처음 본 글만 합류한다(합치기는 두 묶음의
  /// 시간대가 이만큼 가까울 때만). null 이면 시간을 보지 않는다(옛 방식).
  ///
  /// 시간을 보지 않으면 매일 나오는 주제("엔비디아 실발", "코스피 마감")나 흔한 말투
  /// ("~ 이유가 뭔가요")가 하루 내내 한 묶음으로 이어졌다. 실데이터(24시간 6,580글)에서
  /// 8시간이면 이슈 묶음 88개, 12시간이면 53개가 갈라졌는데 8~10시간은 띄엄띄엄 이어지는
  /// 같은 사건(후원 릴레이 · 재게시)까지 갈랐다. 12시간에서 갈라지는 옛 쪽은 반감기
  /// (3시간)로 이미 점수가 거의 없어 순위 손실이 작다.
  final Duration? maxGap = const Duration(hours: 12),

  /// 서술어 · 어미([TitleFeatures.isPredicate])가 낀 단어 · 쌍은 근거로 세지 않는다.
  /// "이유가 뭔가요" · "없지 않나요" 같은 말투 하나로 서로 다른 질문글이 묶였다.
  /// IDF 로는 못 거른다 — 이런 쌍은 드물어(실데이터 df 2~4) IDF 가 높고, 오히려 진짜
  /// 이슈의 쌍("리트 만점자" 79 · "한한령 해제" 17)이 흔하다. 코사인 계산에는 그대로 쓴다.
  final bool contentEvidence = true,
}) {
  static int compareInputs(ClusterInput a, ClusterInput b) =>
      a.at != b.at ? a.at.compareTo(b.at) : a.key.compareTo(b.key);

  List<Cluster> run(List<ClusterInput> inputs) {
    final List<ClusterInput> ordered = [...inputs]..sort(compareInputs);
    final List<Map<String, double>> raws = [
      for (final i in ordered) TitleFeatures.raw(i.title),
    ];
    final Idf idf = Idf(raws);
    final int maxDf = (idf.size * maxDfRatio).ceil().clamp(3, 1 << 30);

    final List<Cluster> clusters = [];
    final Map<String, Set<int>> index = {};

    for (int i = 0; i < ordered.length; i++) {
      final Map<String, double> v = idf.vector(raws[i]);
      if (v.isEmpty) continue;

      final Set<int> candidates = {};
      for (final String f in v.keys) {
        if (idf.df(f) > maxDf) continue;
        candidates.addAll(index[f] ?? const {});
      }
      final int at = ordered[i].at;
      if (maxGap case final Duration gap) {
        candidates.removeWhere(
          (c) => at - clusters[c].members.last.at > gap.inMilliseconds,
        );
      }
      final Cluster? best = memberLink
          ? _bestByMember(v, candidates, clusters)
          : _bestByCentroid(v, candidates, clusters);
      final Cluster target;
      if (best != null) {
        target = best;
      } else {
        target = Cluster(clusters.length);
        clusters.add(target);
      }
      target.add(ordered[i], v);
      for (final String f in v.keys) {
        (index[f] ??= {}).add(target.index);
      }
    }
    return merge ? _merge(clusters, idf, maxDf) : clusters;
  }

  /// 옛 방식: 중심과 근거를 따진다.
  Cluster? _bestByCentroid(
    Map<String, double> v,
    Set<int> candidates,
    List<Cluster> clusters,
  ) {
    Cluster? best;
    double bestSim = 0;
    for (final int c in candidates) {
      final Map<String, double> centroid = clusters[c].centroid;
      final double sim = Idf.cosine(v, centroid);
      if (sim <= bestSim || sim < weakThreshold) continue;
      if (sim < threshold && !_hasEvidence(v, centroid)) continue;
      bestSim = sim;
      best = clusters[c];
    }
    return best;
  }

  /// 중심 코사인이 높은 묶음부터 보며, 중심 코사인이 [threshold] 이상이거나 그 안의
  /// 글 하나와 근거가 있는 첫 묶음. 글과 비교하는 건 중심 기준을 넘은 몇 개 묶음뿐이고
  /// 근거 검사는 코사인보다 싸서 계산량은 거의 그대로다.
  Cluster? _bestByMember(
    Map<String, double> v,
    Set<int> candidates,
    List<Cluster> clusters,
  ) {
    final List<(int, double)> ranked =
        [
          for (final int c in candidates)
            if (Idf.cosine(v, clusters[c].centroid) case final double sim
                when sim >= weakThreshold)
              (c, sim),
        ]..sort(
          (a, b) => a.$2 != b.$2 ? b.$2.compareTo(a.$2) : a.$1.compareTo(b.$1),
        );
    for (final (int c, double sim) in ranked) {
      final Cluster cluster = clusters[c];
      if (sim >= threshold || cluster.vectors.any((m) => _hasEvidence(v, m))) {
        return cluster;
      }
    }
    return null;
  }

  /// 두 묶음의 시간대(첫 글 ~ 마지막 글) 사이가 [maxGap] 안인가. 겹치면 0.
  bool _closeInTime(Cluster a, Cluster b) {
    final Duration? gap = maxGap;
    if (gap == null) return true;
    final int between = max(
      b.members.first.at - a.members.last.at,
      a.members.first.at - b.members.last.at,
    );
    return between <= gap.inMilliseconds;
  }

  bool _clustersLinked(Cluster a, Cluster b) {
    for (final Map<String, double> x in a.vectors) {
      for (final Map<String, double> y in b.vectors) {
        if (_hasEvidence(x, y)) return true;
      }
    }
    return false;
  }

  /// 중심이 닮은 묶음을 합친다. 앞(먼저 생긴) 묶음이 뒤 묶음을 받아 들이므로
  /// 첫 글 · 이슈 id 는 그대로다. 합친 뒤 중심이 바뀌므로 바뀌지 않을 때까지 몇 번 돈다.
  List<Cluster> _merge(List<Cluster> clusters, Idf idf, int maxDf) {
    List<Cluster> current = clusters;
    for (int pass = 0; pass < 3; pass++) {
      bool changed = false;
      final List<Cluster> alive = [];
      final Map<String, Set<int>> index = {};
      for (final Cluster c in current) {
        final Map<String, double> centroid = c.centroid;
        final Set<int> candidates = {};
        for (final String f in centroid.keys) {
          if (idf.df(f) > maxDf) continue;
          candidates.addAll(index[f] ?? const {});
        }
        final List<(int, double)> ranked =
            [
              for (final int i in candidates)
                if (_closeInTime(alive[i], c))
                  if (Idf.cosine(centroid, alive[i].centroid)
                      case final double sim when sim >= mergeWeakThreshold)
                    (i, sim),
            ]..sort(
              (a, b) =>
                  a.$2 != b.$2 ? b.$2.compareTo(a.$2) : a.$1.compareTo(b.$1),
            );
        int best = -1;
        for (final (int i, double sim) in ranked) {
          final bool ok =
              sim >= threshold ||
              (memberLink
                  ? _clustersLinked(alive[i], c)
                  : _hasEvidence(centroid, alive[i].centroid));
          if (ok) {
            best = i;
            break;
          }
        }
        final int at;
        if (best >= 0) {
          alive[best].absorb(c);
          changed = true;
          at = best;
        } else {
          alive.add(c);
          at = alive.length - 1;
        }
        for (final String f in centroid.keys) {
          (index[f] ??= {}).add(at);
        }
      }
      current = alive;
      if (!changed) break;
    }
    return current;
  }

  bool _hasEvidence(Map<String, double> a, Map<String, double> b) {
    int words = 0;
    for (final String k in a.keys) {
      if (!b.containsKey(k)) continue;
      if (k.startsWith('p:')) {
        if (!contentEvidence) return true;
        final int space = k.indexOf(' ');
        if (!TitleFeatures.isPredicate(k.substring(2, space)) &&
            !TitleFeatures.isPredicate(k.substring(space + 1))) {
          return true;
        }
      } else if (k.startsWith('w:')) {
        if (contentEvidence && TitleFeatures.isPredicate(k.substring(2))) {
          continue;
        }
        if (++words >= 2) return true;
      }
    }
    return false;
  }
}
