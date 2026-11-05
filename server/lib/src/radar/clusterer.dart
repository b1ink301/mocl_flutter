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
}

/// 제목이 비슷한 글을 묶는다(증분 · 결정적).
///
/// 글을 처음 본 순서대로 넣으면서 가장 비슷한 묶음에 합류시키고, 맞는 묶음이
/// 없으면 새 묶음을 만든다. 합류 조건(짧은 제목은 코사인만으로는 갈리지 않는다):
/// - 코사인 ≥ [threshold], 또는
/// - 코사인 ≥ [weakThreshold] 이면서 근거가 있을 때 — 이웃 단어 쌍("아이폰 듀오")을
///   함께 갖거나 단어를 2개 이상 함께 가짐. 단어 하나("반도체")만 겹치면 묶지 않는다.
/// 비교는 특징을 하나라도 공유하는 묶음만(역색인) 한다.
class const Clusterer({
  final double threshold = 0.45,
  final double weakThreshold = 0.2,

  /// 이 비율보다 많은 글에 나오는 특징은 후보를 찾는 데 쓰지 않는다(너무 흔함).
  final double maxDfRatio = 0.05,
}) {
  List<Cluster> run(List<ClusterInput> inputs) {
    final List<ClusterInput> ordered = [...inputs]
      ..sort(
        (a, b) => a.at != b.at ? a.at.compareTo(b.at) : a.key.compareTo(b.key),
      );
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
    return clusters;
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
