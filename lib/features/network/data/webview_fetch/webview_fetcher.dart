/// 웹뷰 안에서 보내는 요청 하나.
class const WebViewRequest({
  required final Uri url,
  final String method = 'GET',
  final Map<String, String> headers = const {},
  final String? body,
  required final String userAgent,
});

/// 웹뷰 `fetch` 의 응답(리다이렉트를 따라간 최종 응답).
class const WebViewResponse({
  required final int status,
  required final Uri url,
  required final String body,
  final String contentType = '',
  final bool challenged = false,
});

/// 웹뷰로도 보안 검사를 통과하지 못했거나 웹뷰를 쓸 수 없을 때.
class const ChallengeException(final String message) implements Exception {
  @override
  String toString() => 'ChallengeException: $message';
}

/// 브라우저(웹뷰) 안에서 요청을 보낸다. Cloudflare 보안 검사를 통과하려고 쓴다.
abstract interface class WebViewFetcher() {
  Future<WebViewResponse> fetch(WebViewRequest request);
}
