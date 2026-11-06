/// HTML 엔티티를 글자로 푼다(`&amp;` → `&`, `&#39;` → `'`, `&#x1F600;` → 😀).
///
/// 한 번만 훑으므로 `&amp;lt;` 는 `&lt;` 가 된다(두 번 풀지 않는다). 레딧 JSON 처럼
/// 이스케이프된 HTML 을 원래 HTML 로 되돌릴 때 쓴다. 모르는 이름 엔티티는 그대로 둔다
/// — 풀린 HTML 을 그리는 쪽(HTML 위젯)이 다시 해석한다.
String unescapeHtml(String input) {
  if (!input.contains('&')) return input;
  return input.replaceAllMapped(_entity, (m) {
    final String? name = m[1];
    if (name != null) return _named[name] ?? m[0]!;
    final String? hex = m[2];
    final int? code = hex != null
        ? int.tryParse(hex, radix: 16)
        : int.tryParse(m[3]!);
    if (code == null || code == 0 || code > 0x10FFFF) return m[0]!;
    if (code >= 0xD800 && code <= 0xDFFF) return m[0]!;
    return String.fromCharCode(code);
  });
}

final RegExp _entity = RegExp(
  r'&(?:([a-zA-Z][a-zA-Z0-9]*)|#[xX]([0-9a-fA-F]+)|#([0-9]+));',
);

const Map<String, String> _named = {
  'amp': '&',
  'lt': '<',
  'gt': '>',
  'quot': '"',
  'apos': "'",
  'nbsp': ' ',
};
