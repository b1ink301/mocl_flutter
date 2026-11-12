/// 다른 앱에서 공유받은 글자에서 주소를 꺼낸다.
///
/// 브라우저는 주소만, 커뮤니티 앱 · 메신저는 "제목\n주소" 처럼 앞뒤에 글을 붙여
/// 보내므로 처음 나오는 http(s) 주소를 쓴다. 문장부호로 끝나는 주소
/// ("…/123)." 등)는 끝의 부호를 떼어 낸다.
abstract final class SharedText() {
  static final RegExp _url = RegExp(r'''https?://[^\s<>"'`]+''');

  /// 주소 끝에 붙어 오는 문장부호. 괄호는 짝이 맞지 않을 때만 뗀다.
  static const String _trailing = '.,;:!?…。、';

  static String? firstUrl(String text) {
    final String? match = _url.firstMatch(text)?.group(0);
    if (match == null) return null;
    String url = match;
    while (url.isNotEmpty) {
      final String last = url[url.length - 1];
      if (_trailing.contains(last) ||
          (last == ')' && !_balanced(url, '(', ')')) ||
          (last == ']' && !_balanced(url, '[', ']'))) {
        url = url.substring(0, url.length - 1);
      } else {
        break;
      }
    }
    return Uri.tryParse(url)?.host.isNotEmpty == true ? url : null;
  }

  static bool _balanced(String s, String open, String close) =>
      open.allMatches(s).length >= close.allMatches(s).length;
}
