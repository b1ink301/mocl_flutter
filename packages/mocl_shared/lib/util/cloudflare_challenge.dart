/// Cloudflare 보안 검사(챌린지) 응답 판정.
///
/// 사이트가 Cloudflare "보안 검사" (managed challenge · JS challenge)를 걸면 브라우저가 아닌
/// 요청은 403/503 과 검사 페이지를 받는다. 앱은 이걸 보고 웹뷰로 다시 받고,
/// 서버 카나리는 "IP 차단"과 구분해 보여 준다.
abstract final class CloudflareChallenge() {
  /// 본문에 이 중 하나가 있으면 검사 페이지다.
  static const List<String> bodyMarkers = [
    '/cdn-cgi/challenge-platform/',
    '_cf_chl_opt',
    '<title>Just a moment...</title>',
  ];

  /// [status] · [headers](소문자 이름 → 값) · [body] 가 보안 검사 응답인지.
  ///
  /// `cf-mitigated: challenge` 헤더가 있으면 확실하다. 없으면 403/503 이면서
  /// 본문에 검사 페이지 표시가 있을 때만 그렇다고 본다(본문만 보면 글 내용에
  /// 같은 문자열이 있을 때 오판한다).
  static bool isChallenge({
    required int? status,
    Map<String, List<String>> headers = const {},
    Object? body,
  }) {
    final List<String>? mitigated = headers['cf-mitigated'];
    if (mitigated != null && mitigated.any((v) => v.contains('challenge'))) {
      return true;
    }
    if (status != 403 && status != 503) return false;
    return body is String && isChallengeBody(body);
  }

  /// 렌더된 페이지(웹뷰)가 아직 검사 중인지.
  static bool isChallengeBody(String body) => bodyMarkers.any(body.contains);
}
