import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/core/util/simple_html_text.dart';

/// 글자뿐인 댓글을 `Text` 로 그리는 빠른 경로가 HTML 위젯과 같은 모양인지 본다.
void main() {
  group('plainTextOfSimpleHtml', () {
    test('글자 · 줄바꿈 · 엔티티를 글자로 바꾼다', () {
      expect(plainTextOfSimpleHtml('안녕하세요'), '안녕하세요');
      expect(plainTextOfSimpleHtml('가<br>나<br/>다<br />라'), '가\n나\n다\n라');
      expect(
        plainTextOfSimpleHtml('a &amp; b &lt;c&gt; &#39;d&#x27;'),
        "a & b <c> 'd'",
      );
      expect(plainTextOfSimpleHtml('가&nbsp;&nbsp;나'), '가\u00A0\u00A0나');
      expect(plainTextOfSimpleHtml('  가\n  나   다  '), '가 나 다');
      expect(plainTextOfSimpleHtml('<p>가<br>나</p>'), '가\n나');
      expect(plainTextOfSimpleHtml('<div class="c">가</div>'), '가');
      expect(plainTextOfSimpleHtml('<span class="x">가</span>나'), '가나');
    });

    test('모양이 달라질 수 있는 것은 넘긴다(null)', () {
      for (final String html in [
        '<a href="https://example.com">링크</a>',
        '가<img src="https://example.com/a.png">',
        '<b>굵게</b>',
        '<span style="color:red">빨강</span>',
        '<p>가</p><p>나</p>',
        '<p style="text-align:center">가</p>',
        '<div>가</div><div>나</div>',
        '가 &hellip; 나',
        '가 <!-- 주석 --> 나',
        '1 < 2',
        '<br clear="all">가',
      ]) {
        expect(plainTextOfSimpleHtml(html), isNull, reason: html);
      }
    });
  });

  group('HTML 위젯과 같은 모양', () {
    const TextStyle style = TextStyle(fontSize: 16);

    Future<(String, Size)> pump(WidgetTester tester, Widget child) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 300,
                child: KeyedSubtree(key: const ValueKey('box'), child: child),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final String text = tester
          .widgetList<RichText>(
            find.descendant(
              of: find.byKey(const ValueKey('box')),
              matching: find.byType(RichText),
            ),
          )
          .map((RichText w) => w.text.toPlainText())
          .join('\n');
      return (text, tester.getSize(find.byKey(const ValueKey('box'))));
    }

    for (final String html in [
      '안녕하세요',
      '가<br>나<br/>다',
      '가<br><br>나',
      '<br>가<br>',
      '가<br><br><br>',
      '  가  <br>  나  ',
      '가\n나\n\n다',
      '가 &amp; 나 &lt;다&gt;',
      '가&nbsp;&nbsp;나',
      '&nbsp;가&nbsp;',
      '<p>가<br>나</p>',
      '<p>\n  가\n</p>',
      '<p>가<br></p>',
      '<p><br>가</p>',
      '가 <br>',
      '가<br> <br>나',
      '<br><br>가',
      '<div>가<br>나</div>',
      '<span class="x">가</span> 나',
      '가<span> </span>나',
      '긴 글 ' * 40,
      '첫 줄<br>${'둘째 줄이 길어서 줄이 바뀐다 ' * 6}<br>셋째 줄',
    ]) {
      testWidgets(
        '같다: ${html.length > 30 ? '${html.substring(0, 30)}…' : html}',
        (tester) async {
          final String? plain = plainTextOfSimpleHtml(html);
          expect(plain, isNotNull);

          final (String htmlText, Size htmlSize) = await pump(
            tester,
            HtmlWidget(html, textStyle: style),
          );
          final (String plainText, Size plainSize) = await pump(
            tester,
            Text(plain!, style: style),
          );

          expect(plainText, htmlText);
          expect(plainSize, htmlSize);
        },
      );
    }
  });
}
