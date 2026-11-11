/// 글자와 줄바꿈뿐인 HTML 을 일반 글자로 바꾼다. 그 밖의 것이 하나라도 있으면 null.
///
/// 댓글은 대부분 `안녕하세요<br>반갑습니다` 같은 글자뿐인데, HTML 위젯은 그런 것도
/// 화면에 들어올 때마다 UI 스레드에서 파싱하고 위젯 트리를 만든다(화면 밖으로 나가면
/// 버리고, 돌아오면 다시). 여기서 글자로 바꿀 수 있으면 `Text` 하나로 그린다.
///
/// 받아들이는 것(HTML 위젯이 그린 모양과 같아야 하므로 좁게 잡는다):
/// - 글자, `<br>`, 엔티티(`&amp;` `&lt;` `&gt;` `&quot;` `&apos;` `&nbsp;` · 숫자 엔티티)
/// - 꾸밈 없는 `<span>`(앱에는 사이트 CSS 가 없어 class 는 모양을 바꾸지 않는다)
/// - 전체를 한 번 감싼 `<p>` · `<div>`(맨 위 · 맨 아래 여백은 HTML 위젯도 잘라낸다)
///
/// 링크 · 이미지 · 굵은 글씨 · 인라인 스타일 · 모르는 엔티티는 null(HTML 위젯으로 그린다).
String? plainTextOfSimpleHtml(String html) {
  // 태그도 엔티티도 없으면 공백만 정리한다(가장 흔한 경우).
  if (!html.contains('<') && !html.contains('&')) {
    return _collapse(html.replaceAll(_sourceBreak, ' '));
  }

  String source = html.replaceAll(_edgeSpaces, '');

  // 전체를 감싼 <p> · <div> 하나는 벗긴다. 안에 또 있으면 문단 여백이 생기므로 포기한다.
  final RegExpMatch? wrapper = _wrapper.firstMatch(source);
  if (wrapper != null) {
    final String tag = wrapper[1]!.toLowerCase();
    final String closing = '</$tag>';
    if (!_isPlainAttributes(wrapper[2]!) ||
        source.length < wrapper.end + closing.length ||
        source.substring(source.length - closing.length).toLowerCase() !=
            closing) {
      return null;
    }
    source = source.substring(wrapper.end, source.length - closing.length);
  }

  final StringBuffer out = StringBuffer();
  int cursor = 0;
  for (final RegExpMatch tag in _tag.allMatches(source)) {
    if (!_appendText(out, source.substring(cursor, tag.start))) return null;
    cursor = tag.end;

    final String name = tag[2]!.toLowerCase();
    final String attributes = tag[3]!;
    switch (name) {
      case 'br':
        if (!_isPlainAttributes(attributes)) return null;
        out.write('\n');
      case 'span':
        if (!_isPlainAttributes(attributes)) return null;
      default:
        return null;
    }
  }
  if (!_appendText(out, source.substring(cursor))) return null;

  return _collapse(out.toString());
}

/// 태그 사이 글자를 엔티티를 풀어 붙인다. 태그로 못 읽은 `<` 나 모르는 엔티티가 있으면 false.
bool _appendText(StringBuffer out, String text) {
  if (text.isEmpty) return true;
  if (text.contains('<')) return false;
  if (!text.contains('&')) {
    // 원문의 줄바꿈은 HTML 에서 공백이다. <br> 로 넣은 '\n' 과 섞이지 않게 여기서 바꾼다.
    out.write(text.replaceAll(_sourceBreak, ' '));
    return true;
  }

  bool known = true;
  final String decoded = text.replaceAllMapped(_entity, (m) {
    final String? name = m[1];
    if (name != null) {
      final String? char = _named[name];
      if (char == null) known = false;
      return char ?? '';
    }
    final String? hex = m[2];
    final int? code = hex != null
        ? int.tryParse(hex, radix: 16)
        : int.tryParse(m[3]!);
    if (code == null ||
        code < 0x20 ||
        code > 0x10FFFF ||
        (code >= 0xD800 && code <= 0xDFFF)) {
      known = false;
      return '';
    }
    return String.fromCharCode(code);
  });
  if (!known) return false;
  out.write(decoded.replaceAll(_sourceBreak, ' '));
  return true;
}

/// HTML 위젯(fwfh)이 그리는 글자와 같게 공백을 정리한다(테스트가 두 결과를 비교한다):
/// 이어진 공백은 하나로, 줄 앞 공백은 없애고, 맨 끝은 `<br>` 하나 또는 공백을 버린다.
/// 줄 끝 공백 · 맨 앞 빈 줄 · 끝에 겹친 빈 줄은 그대로 둔다.
/// `&nbsp;`(U+00A0)는 공백으로 치지 않는다.
String _collapse(String text) {
  String result = text
      .split('\n')
      .map(
        (String line) =>
            line.replaceAll(_spaces, ' ').replaceAll(_leadingSpace, ''),
      )
      .join('\n');
  return result.endsWith('\n')
      ? result.substring(0, result.length - 1)
      : result.replaceAll(_trailingSpaces, '');
}

/// class · id · data-* 만 있으면 모양에 영향이 없다(style · align 등은 있다).
bool _isPlainAttributes(String attributes) =>
    attributes.isEmpty || _plainAttributes.hasMatch(attributes);

final RegExp _wrapper = RegExp(r'^<(p|div)\b([^>]*)>', caseSensitive: false);

final RegExp _tag = RegExp(r'<(/?)([a-zA-Z][a-zA-Z0-9]*)\b([^>]*?)/?>');

final RegExp _plainAttributes = RegExp(
  r'''^(?:\s+(?:class|id|data-[\w-]+)(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s"'=<>`]+))?)*\s*$''',
  caseSensitive: false,
);

final RegExp _entity = RegExp(
  r'&(?:([a-zA-Z][a-zA-Z0-9]*)|#[xX]([0-9a-fA-F]+)|#([0-9]+));',
);

/// ASCII 공백만 다룬다(`String.trim` 은 U+00A0 도 지워서 쓰지 않는다).
final RegExp _spaces = RegExp(r'[ \t\r\f]+');

final RegExp _leadingSpace = RegExp(r'^ ');

final RegExp _trailingSpaces = RegExp(r' +$');

final RegExp _edgeSpaces = RegExp(r'^[ \t\r\n\f]+|[ \t\r\n\f]+$');

final RegExp _sourceBreak = RegExp(r'[\r\n]+');

const Map<String, String> _named = {
  'amp': '&',
  'lt': '<',
  'gt': '>',
  'quot': '"',
  'apos': "'",
  'nbsp': '\u00A0',
};
