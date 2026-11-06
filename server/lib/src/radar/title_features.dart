import 'dart:math';

/// 제목을 비교용 특징으로 바꾼다.
///
/// - 단어(공백 기준) + 한글 문자 2-gram. 2-gram 은 조사 · 어미가 달라도 겹친다
///   ("윤석열이" / "윤석열은" → "윤석", "석열" 공유).
/// - 말머리 · 이모지 · 확장자 · ㅋㅋ 같은 군더더기는 뺀다.
/// - 숫자만 있는 단어는 뺀다(가격 · 날짜가 주제와 상관없이 겹친다).
abstract final class TitleFeatures() {
  /// 너무 흔해서 주제를 가르지 못하는 말. 대부분은 IDF 가 알아서 약하게 만들지만,
  /// 짧은 제목에서 이 말들만 겹쳐 엉뚱하게 묶이는 걸 막는다.
  static const Set<String> stopwords = {
    '근황',
    '속보',
    '단독',
    '오늘',
    '어제',
    '진짜',
    '지금',
    '현재',
    '이유',
    '결국',
    '레전드',
    '반응',
    '후기',
    '사진',
    '영상',
    '스압',
    '약스압',
    '약혐',
    '혐',
    '펌',
    '후방',
    '데이터',
    '주의',
    '모음',
    '최근',
    '요즘',
    '그냥',
    '이거',
    '이게',
    '저거',
    '이번',
    '역대',
    '역대급',
    '대박',
    '실화',
    '정말',
    '너무',
    '완전',
    '같은',
    '하는',
    '있는',
    '없는',
    '되는',
    '한다',
    '했다',
    '이다',
    '그리고',
    '근데',
    '하고',
    '보고',
    'jpg',
    'gif',
    'png',
    'mp4',
    'webp',
    'jpeg',
    'youtube',
    'shorts',
  };

  static final RegExp _brackets = RegExp(
    r'\[[^\]]{0,30}\]|【[^】]{0,30}】|<[^>]{0,30}>',
  );
  static final RegExp _url = RegExp(r'https?://\S+');
  static final RegExp _ext = RegExp(
    r'\.(gif|jpe?g|png|mp4|webp)\b',
    caseSensitive: false,
  );
  static final RegExp _jamoRuns = RegExp(r'[ㄱ-ㅎㅏ-ㅣ]+');
  static final RegExp _nonWord = RegExp(r'[^0-9a-zA-Z가-힣]+');
  static final RegExp _hangul = RegExp(r'[가-힣]');
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  /// 정규화한 단어들.
  static List<String> words(String title) {
    final String cleaned = title
        .replaceAll(_url, ' ')
        .replaceAll(_brackets, ' ')
        .replaceAll(_ext, ' ')
        .replaceAll(_jamoRuns, ' ')
        .toLowerCase()
        .replaceAll(_nonWord, ' ');
    return [
      for (final String w in cleaned.split(' '))
        if (w.length >= 2 && !_digitsOnly.hasMatch(w) && !stopwords.contains(w))
          w,
    ];
  }

  /// 특징 → 가중치(TF 는 0/1). 단어 1.0, 이웃한 단어 쌍 1.0, 한글 2-gram 0.6.
  ///
  /// 단어 쌍("아이폰 듀오")은 짧은 제목끼리 같은 고유명사구를 공유할 때 가장 강한
  /// 신호다. 단어 하나("반도체")만 겹치는 무관한 글과 구별해 준다.
  static Map<String, double> raw(String title) {
    final Map<String, double> f = {};
    final List<String> ws = words(title);
    for (int i = 0; i + 1 < ws.length; i++) {
      f['p:${ws[i]} ${ws[i + 1]}'] = 1.0;
    }
    for (final String w in ws) {
      f['w:$w'] = 1.0;
      // 두 글자 단어는 2-gram 이 단어와 같아 두 번 세게 되므로 건너뛴다.
      if (w.length <= 2 || !_hangul.hasMatch(w)) continue;
      for (int i = 0; i + 2 <= w.length; i++) {
        final String bi = w.substring(i, i + 2);
        if (!_hangul.hasMatch(bi[0]) || !_hangul.hasMatch(bi[1])) continue;
        f.putIfAbsent('b:$bi', () => 0.6);
      }
    }
    return f;
  }
}

/// 말뭉치 기준 IDF. 많이 나오는 특징일수록 작다.
class Idf(final Iterable<Map<String, double>> docs) {
  late final int _n = docs.length;
  late final Map<String, int> _df = () {
    final Map<String, int> df = {};
    for (final Map<String, double> d in docs) {
      for (final String k in d.keys) {
        df[k] = (df[k] ?? 0) + 1;
      }
    }
    return df;
  }();

  double of(String feature) => log((_n + 1) / ((_df[feature] ?? 0) + 1)) + 1;

  /// 문서 빈도. 거의 모든 글에 나오는 특징은 색인에서 뺄 때 쓴다.
  int df(String feature) => _df[feature] ?? 0;

  int get size => _n;

  /// TF-IDF 후 L2 정규화한 벡터.
  Map<String, double> vector(Map<String, double> raw) {
    final Map<String, double> v = {
      for (final MapEntry<String, double> e in raw.entries)
        e.key: e.value * of(e.key),
    };
    return normalize(v);
  }

  static Map<String, double> normalize(Map<String, double> v) {
    double sum = 0;
    for (final double x in v.values) {
      sum += x * x;
    }
    if (sum == 0) return v;
    final double n = sqrt(sum);
    return {for (final e in v.entries) e.key: e.value / n};
  }

  static double cosine(Map<String, double> a, Map<String, double> b) {
    final Map<String, double> small = a.length <= b.length ? a : b;
    final Map<String, double> large = identical(small, a) ? b : a;
    double dot = 0;
    for (final MapEntry<String, double> e in small.entries) {
      final double? y = large[e.key];
      if (y != null) dot += e.value * y;
    }
    return dot;
  }
}
