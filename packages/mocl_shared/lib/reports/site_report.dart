import '../entities/mocl_site_type.dart';

/// 앱 → 서버(`POST /v1/reports`)로 보내는 사이트 문제 신고.
///
/// - [SiteReportKind.auto]: 앱이 스스로 감지한 파서 고장(사용자 행동 없음, 기기당 하루 한 번)
/// - [SiteReportKind.user]: 사용자가 "문제 알리기" 로 보낸 제보
///
/// 기기를 알아볼 값(설치 id · 토큰 · 쿠키)은 담지 않는다. [url] 은 공개된 글 · 게시판 주소다.
enum SiteReportKind() {
  auto,
  user,
}

/// 신고 이유. 자동 신고와 사용자 제보가 쓰는 값이 나뉜다([kind]).
enum SiteReportReason(final SiteReportKind kind, final String label) {
  /// 목록을 읽지 못함(파서 예외).
  listParse(SiteReportKind.auto, '목록 파싱 실패'),

  /// 상세를 읽지 못함(파서 예외 · 본문 자리 없음).
  detailParse(SiteReportKind.auto, '상세 파싱 실패'),

  /// 첫 쪽 목록을 받았는데 글이 0개.
  emptyList(SiteReportKind.auto, '목록 0개'),

  notOpening(SiteReportKind.user, '글이 안 열려요'),
  content(SiteReportKind.user, '본문 · 이미지가 이상해요'),
  comments(SiteReportKind.user, '댓글이 안 보여요'),
  list(SiteReportKind.user, '목록이 이상해요'),
  other(SiteReportKind.user, '기타 · 의견'),
}

class const SiteReport({
  required final SiteReportKind kind,
  required final SiteReportReason reason,
  required final String appVersion,
  required final String platform,
  final SiteType? site,
  final String? board,
  final String? url,
  final String? message,
}) {
  static const Set<String> platforms = {'android', 'ios', 'macos', 'other'};
  static const int maxBoardLength = 200;
  static const int maxUrlLength = 500;

  /// 서버가 받는 최대 길이. 앱의 메모 입력은 [maxMemoLength] 로 더 짧게 막는다.
  static const int maxMessageLength = 500;
  static const int maxMemoLength = 200;

  /// 자동 신고 메시지를 [maxMessageLength] 안으로 줄인다(스택 · 줄바꿈은 첫 줄만).
  static String? clip(String? text) {
    if (text == null) return null;
    final String first = text.trim().split('\n').first.trim();
    if (first.isEmpty) return null;
    return first.length <= maxMessageLength
        ? first
        : first.substring(0, maxMessageLength);
  }

  Map<String, Object?> toJson() => {
    'kind': kind.name,
    'reason': reason.name,
    'appVersion': appVersion,
    'platform': platform,
    'site': ?site?.name,
    'board': ?board,
    'url': ?url,
    'message': ?message,
  };

  /// 검증하며 읽는다(서버). 잘못되면 [FormatException].
  factory fromJson(Object? json) {
    if (json is! Map) throw const FormatException('신고는 객체여야 한다');
    final SiteReportKind? kind = _byName(SiteReportKind.values, json['kind']);
    if (kind == null) throw FormatException('모르는 kind: ${json['kind']}');
    final SiteReportReason? reason = _byName(
      SiteReportReason.values,
      json['reason'],
    );
    if (reason == null || reason.kind != kind) {
      throw FormatException('잘못된 reason: ${json['reason']}');
    }
    final Object? site = json['site'];
    final SiteType? siteType = site == null
        ? null
        : _byName(SiteType.values, site);
    if (site != null && siteType == null) {
      throw FormatException('모르는 사이트: $site');
    }
    // 자동 신고는 늘 사이트가 있다(사이트별로 묶어 알린다).
    if (kind == SiteReportKind.auto && siteType == null) {
      throw const FormatException('자동 신고에 사이트가 없다');
    }
    final String appVersion = _string(json, 'appVersion', max: 40) ?? '';
    if (appVersion.isEmpty) throw const FormatException('appVersion 이 없다');
    final String? platform = _string(json, 'platform', max: 10);
    if (platform == null || !platforms.contains(platform)) {
      throw FormatException('잘못된 platform: $platform');
    }
    final String? url = _string(json, 'url', max: maxUrlLength);
    if (url != null && !isWebUrl(url)) {
      throw FormatException('잘못된 url: $url');
    }
    return SiteReport(
      kind: kind,
      reason: reason,
      appVersion: appVersion,
      platform: platform,
      site: siteType,
      board: _string(json, 'board', max: maxBoardLength),
      url: url,
      message: _string(json, 'message', max: maxMessageLength),
    );
  }

  /// http(s) 절대 주소인지(관리 화면이 링크로 그리므로 다른 스킴은 받지 않는다).
  static bool isWebUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  static T? _byName<T extends Enum>(List<T> values, Object? name) =>
      values.where((T v) => v.name == name).firstOrNull;

  /// 없거나 빈 문자열이면 null. 문자열이 아니거나 [max] 를 넘으면 [FormatException].
  static String? _string(Map<Object?, Object?> json, String key, {required int max}) {
    final Object? value = json[key];
    if (value == null) return null;
    if (value is! String) throw FormatException('$key 는 문자열');
    final String trimmed = value.trim();
    if (trimmed.length > max) throw FormatException('$key 가 너무 길다');
    return trimmed.isEmpty ? null : trimmed;
  }
}
