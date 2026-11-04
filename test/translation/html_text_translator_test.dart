import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/translation/domain/details_translator.dart';
import 'package:mocl_flutter/features/translation/domain/html_text_translator.dart';
import 'package:mocl_flutter/features/translation/domain/translator.dart';

/// 받은 문장을 `[ko]문장` 으로 돌려주고 몇 번 불렸는지 센다.
class _FakeTranslator() implements Translator {
  final List<List<String>> calls = [];

  @override
  Future<bool> isSupported() async => true;

  @override
  Future<List<String>> translate(
    List<String> texts, {
    String from = 'en',
    String to = 'ko',
  }) async {
    calls.add(texts);
    return [for (final t in texts) '[ko]$t'];
  }
}

Future<List<String>> _fake(List<String> texts) async => [
  for (final t in texts) '[ko]$t',
];

CommentItem _comment(String body) => CommentItem(
  id: body.hashCode,
  bodyHtml: body,
  mediaHtml: '',
  isVideo: false,
  time: '',
  info: '',
  likeCount: '',
  userInfo: const UserInfo(id: '', nickName: 'user', nickImage: ''),
  authorId: '',
  isReply: false,
);

void main() {
  group('HtmlTextTranslator', () {
    test('꾸밈 태그만 든 문단은 통째로 번역한다', () async {
      final out = await HtmlTextTranslator.translateAll([
        '<div class="md"><p>This is <b>very</b> good</p></div>',
      ], _fake);
      expect(out.single, '<div class="md"><p>[ko]This is very good</p></div>');
    });

    test('링크는 살리고 글자 조각만 번역한다', () async {
      final out = await HtmlTextTranslator.translateAll([
        '<p>See <a href="https://x.com">the docs</a> here</p>',
      ], _fake);
      expect(
        out.single,
        '<p>[ko]See <a href="https://x.com">[ko]the docs</a> [ko]here</p>',
      );
    });

    test('코드 · 한국어 · 숫자만 있는 글은 건드리지 않는다', () async {
      const html = '<pre><code>val x = 1</code></pre><p>안녕하세요 ok</p><p>123</p>';
      final out = await HtmlTextTranslator.translateAll([html], _fake);
      expect(out.single, html);
    });

    test('여러 HTML 을 한 번에 번역한다', () async {
      final calls = <List<String>>[];
      final out = await HtmlTextTranslator.translateAll(
        ['<p>first one</p>', '<p>둘째</p>', '<p>third one</p>'],
        (texts) async {
          calls.add(texts);
          return _fake(texts);
        },
      );
      expect(calls, [
        ['first one', 'third one'],
      ]);
      expect(out, [
        '<p>[ko]first one</p>',
        '<p>둘째</p>',
        '<p>[ko]third one</p>',
      ]);
    });
  });

  test('DetailsTranslator 는 본문 다음 댓글을 묶음으로 번역해 내보낸다', () async {
    final translator = _FakeTranslator();
    final original = Details.empty().copyWith(
      title: 'Hello world',
      bodyHtml: '<p>Body text</p>',
      comments: [for (var i = 0; i < 3; i++) _comment('<p>comment $i</p>')],
    );

    final steps = await DetailsTranslator(
      translator,
      commentBatch: 2,
    ).translate(original).toList();

    expect(steps, hasLength(3)); // 본문, 댓글 0~1, 댓글 2
    expect(steps.first.title, '[ko]Hello world');
    expect(steps.first.bodyHtml, '<p>[ko]Body text</p>');
    expect(steps.first.comments.first.bodyHtml, '<p>comment 0</p>');
    expect(steps.last.comments.map((c) => c.bodyHtml), [
      '<p>[ko]comment 0</p>',
      '<p>[ko]comment 1</p>',
      '<p>[ko]comment 2</p>',
    ]);
  });
}
