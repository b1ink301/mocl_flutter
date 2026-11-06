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
/// - 코사인 ≥ [threshold], 또는
/// - 코사인 ≥ [weakThreshold] 이면서 근거가 있을 때 — 이웃 단어 쌍("아이폰 듀오")을
///   함께 갖거나 단어를 2개 이상 함께 가짐. 단어 하나("반도체")만 겹치면 묶지 않는다.
/// 비교는 특징을 하나라도 공유하는 묶음만(역색인) 한다.
///
/// 증분 방식이라 들어온 순서에 따라 같은 이야기가 두 묶음으로 갈릴 수 있다
/// ("코스피 5천 붕괴" 묶음이 커진 뒤에야 "5천피 붕괴" 묶음과 닮아진다). 그래서 다 넣은
/// 뒤 묶음 중심끼리 다시 비교해 합친다([merge]). 중심은 글보다 단어가 많아 우연히
/// 겹치기 쉬우므로 약한 기준은 [mergeWeakThreshold] 로 더 엄하게 본다.
class const Clusterer({
  final double threshold = 0.45,
  final double weakThreshold = 0.2,

  /// 이 비율보다 많은 글에 나오는 특징은 후보를 찾는 데 쓰지 않는다(너무 흔함).
  final double maxDfRatio = 0.05,

  /// 다 묶은 뒤 비슷한 묶음끼리 합칠지.
  final bool merge = true,
  final double mergeWeakThreshold = 0.3,
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
        int best = -1;
        double bestSim = 0;
        for (final int i in candidates) {
          final Map<String, double> other = alive[i].centroid;
          final double sim = Idf.cosine(centroid, other);
          if (sim <= bestSim || sim < mergeWeakThreshold) continue;
          if (sim < threshold && !_hasEvidence(centroid, other)) continue;
          bestSim = sim;
          best = i;
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

  static bool _hasEvidence(Map<String, double> a, Map<String, double> b) {
    int words = 0;
    for (final String k in a.keys) {
      if (!b.containsKey(k)) continue;
      if (k.startsWith('p:')) return true;
      if (k.startsWith('w:') && ++words >= 2) return true;
    }
    return false;
  }
}
