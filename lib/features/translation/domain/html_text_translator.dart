import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

/// 문장 목록을 같은 순서로 번역해 돌려주는 함수.
typedef TranslateTexts = Future<List<String>> Function(List<String> texts);

/// HTML 의 글자만 번역하고 태그 · 링크 · 이미지 · 코드는 그대로 둔다.
///
/// 문장이 `<b>` 같은 꾸밈 태그로 잘려 있으면 조각마다 번역해 어색해지므로, 꾸밈
/// 태그만 든 문단(`<p>` 등)은 문단 통째로 번역한다(꾸밈은 사라진다). 링크 · 줄바꿈
/// 이 든 문단은 링크를 살리려고 글자 조각마다 번역한다.
abstract final class HtmlTextTranslator() {
  static const Set<String> _skipTags = {'pre', 'code', 'script', 'style'};
  static const Set<String> _blockTags = {
    'p', 'li', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', //
    'td', 'th', 'blockquote', 'div', 'dd', 'dt', 'figcaption',
  };
  static const Set<String> _plainInlineTags = {
    'b', 'strong', 'i', 'em', 'span', 'del', 's', 'sup', 'sub', 'u', //
  };

  static final RegExp _latin = RegExp('[A-Za-z]');
  static final RegExp _hangul = RegExp('[가-힣]');

  /// 번역할 만한 글인지. 영문자가 두 글자 이상이고 이미 한국어 위주가 아니어야 한다.
  static bool needsTranslation(String text) {
    final int latin = _latin.allMatches(text).length;
    if (latin < 2) return false;
    return _hangul.allMatches(text).length < latin;
  }

  /// [htmls] 를 한 번의 [translate] 호출로 번역해 같은 순서로 돌려준다.
  static Future<List<String>> translateAll(
    List<String> htmls,
    TranslateTexts translate,
  ) async {
    final List<DocumentFragment> fragments = [
      for (final String html in htmls) html_parser.parseFragment(html),
    ];
    final List<_Segment> segments = [];
    for (final DocumentFragment fragment in fragments) {
      _collect(fragment, segments);
    }
    if (segments.isEmpty) return htmls;

    final List<String> translated = await translate([
      for (final _Segment segment in segments) segment.text,
    ]);
    for (var i = 0; i < segments.length && i < translated.length; i++) {
      segments[i].apply(translated[i]);
    }
    return [
      for (var i = 0; i < htmls.length; i++)
        _hasSegment(segments, fragments[i]) ? fragments[i].outerHtml : htmls[i],
    ];
  }

  static bool _hasSegment(List<_Segment> segments, DocumentFragment fragment) =>
      segments.any((segment) => segment.root == fragment);

  static void _collect(DocumentFragment root, List<_Segment> out) {
    void walk(Node node) {
      for (final Node child in node.nodes.toList()) {
        if (child is Text) {
          final String text = child.text;
          if (!needsTranslation(text)) continue;
          // 앞뒤 공백은 옆 태그와의 띄어쓰기라 살린다.
          final String lead = text.substring(
            0,
            text.length - text.trimLeft().length,
          );
          final String trail = text.substring(text.trimRight().length);
          out.add(
            _Segment(root, text.trim(), (t) => child.text = '$lead$t$trail'),
          );
          continue;
        }
        if (child is! Element) continue;
        final String tag = child.localName ?? '';
        if (_skipTags.contains(tag)) continue;
        if (_blockTags.contains(tag) && _isPlainBlock(child)) {
          final String text = child.text.trim();
          if (!needsTranslation(text)) continue;
          out.add(
            _Segment(root, text, (t) {
              child.nodes
                ..clear()
                ..add(Text(t));
            }),
          );
          continue;
        }
        walk(child);
      }
    }

    walk(root);
  }

  /// 꾸밈 태그만 든 문단인지(링크 · 줄바꿈 · 이미지 · 하위 문단이 없음).
  static bool _isPlainBlock(Element element) => element
      .querySelectorAll('*')
      .every((e) => _plainInlineTags.contains(e.localName));
}

class const _Segment(
  final DocumentFragment root,
  final String text,
  final void Function(String translated) apply,
);
