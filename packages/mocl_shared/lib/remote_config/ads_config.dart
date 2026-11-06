/// 글 상세(본문과 댓글 사이) 광고의 크기. 폰(폭 393dp) 기준 높이.
enum DetailAdSize() {
  /// 목록 행과 같은 모양(제목 한 줄 + 정보 한 줄, 이미지 없음). 약 71dp.
  compact,

  /// 왼쪽 정사각 미디어(120dp) + 오른쪽 제목 · 설명 · 버튼. 약 144dp.
  small,

  /// 카드형, 미디어 높이 폭 × 0.4(120~160dp). 약 250dp.
  medium,

  /// 카드형, 미디어 16:9(120~280dp). 약 310dp.
  large,

  /// 광고를 넣지 않는다.
  off;

  static DetailAdSize? tryParse(String name) {
    for (final DetailAdSize size in values) {
      if (size.name == name) return size;
    }
    return null;
  }
}

/// 원격 설정의 광고 항목(`ads`). 값이 없는 항목은 앱 기본값을 쓴다.
///
/// ```json
/// "ads": {
///   "detail": "small",
///   "list": { "first": 5, "interval": 15 }
/// }
/// ```
class const AdsRemoteConfig({
  /// 상세 광고 크기. `null` 이면 [defaultDetail].
  final DetailAdSize? detail,

  /// 목록에서 첫 광고를 넣을 위치(이 개수의 글 뒤). `null` 이면 [defaultListFirst].
  final int? listFirst,

  /// 목록에서 그다음 광고 사이의 글 수. `null` 이면 [defaultListInterval].
  final int? listInterval,
}) {
  static const DetailAdSize defaultDetail = DetailAdSize.small;
  static const int defaultListFirst = 5;
  static const int defaultListInterval = 15;

  /// 받을 수 있는 [listFirst] 범위.
  static const int minListFirst = 1;
  static const int maxListFirst = 100;

  /// 받을 수 있는 [listInterval] 범위. 너무 촘촘하면 AdMob 정책(콘텐츠보다
  /// 광고가 많음)에 걸리므로 하한을 둔다.
  static const int minListInterval = 5;
  static const int maxListInterval = 100;

  static const AdsRemoteConfig empty = AdsRemoteConfig();

  bool get isEmpty =>
      detail == null && listFirst == null && listInterval == null;

  DetailAdSize get effectiveDetail => detail ?? defaultDetail;
  int get effectiveListFirst => listFirst ?? defaultListFirst;
  int get effectiveListInterval => listInterval ?? defaultListInterval;

  /// [fail] 은 모르거나 잘못된 값을 만났을 때 부른다(엄격 모드면 던진다).
  /// 잘못된 항목만 빠지고 나머지는 그대로 읽는다.
  factory fromJson(Object? json, void Function(String message) fail) {
    if (json == null) return empty;
    if (json is! Map) {
      fail('ads 는 객체여야 한다');
      return empty;
    }

    DetailAdSize? detail;
    final Object? rawDetail = json['detail'];
    if (rawDetail != null) {
      detail = rawDetail is String ? DetailAdSize.tryParse(rawDetail) : null;
      if (detail == null) fail('모르는 ads.detail: $rawDetail');
    }

    int? listFirst;
    int? listInterval;
    final Object? rawList = json['list'];
    if (rawList is Map) {
      int? range(String key, int min, int max) {
        final Object? value = rawList[key];
        if (value == null) return null;
        if (value is int && value >= min && value <= max) return value;
        fail('ads.list.$key 는 $min~$max 정수여야 한다: $value');
        return null;
      }

      listFirst = range('first', minListFirst, maxListFirst);
      listInterval = range('interval', minListInterval, maxListInterval);
    } else if (rawList != null) {
      fail('ads.list 는 객체여야 한다');
    }

    return AdsRemoteConfig(
      detail: detail,
      listFirst: listFirst,
      listInterval: listInterval,
    );
  }

  Map<String, Object?> toJson() => {
    'detail': ?detail?.name,
    if (listFirst != null || listInterval != null)
      'list': {'first': ?listFirst, 'interval': ?listInterval},
  };
}
