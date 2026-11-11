import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_shared/entities/mocl_comment_item.dart';
import 'package:mocl_shared/entities/mocl_details.dart';

import '../helpers/screen_harness.dart';

/// 상세 본문 · 댓글을 가볍게 그리는 경로가 실제 화면에서 쓰이는지 본다.
void main() {
  Details detailsWith({required String body, List<CommentItem>? comments}) {
    final base = fakeDetails();
    return Details(
      title: base.title,
      time: base.time,
      viewCount: base.viewCount,
      likeCount: base.likeCount,
      bodyHtml: body,
      info: base.info,
      userInfo: base.userInfo,
      comments: comments ?? base.comments,
    );
  }

  int countOf(WidgetTester tester, String typeName) => tester.allWidgets
      .where((w) => w.runtimeType.toString() == typeName)
      .length;

  testWidgets('줄마다 칸이 하나뿐인 표(자리 잡기용)는 표 위젯으로 그리지 않는다', (tester) async {
    await pumpDetailScreen(
      tester,
      details: detailsWith(
        body:
            '<table><tbody>'
            '<tr><td><p>첫 문단</p><table><tr><td>안쪽 표</td></tr></table></td></tr>'
            '<tr><td><p>둘째 문단</p></td></tr>'
            '</tbody></table>',
      ),
    );

    expect(tester.takeException(), isNull);
    expect(countOf(tester, 'HtmlTable'), 0);
    expect(find.textContaining('첫 문단', findRichText: true), findsOneWidget);
    expect(find.textContaining('안쪽 표', findRichText: true), findsOneWidget);
    expect(find.textContaining('둘째 문단', findRichText: true), findsOneWidget);
  });

  testWidgets('칸이 여럿이거나 테두리를 준 표는 표로 그린다', (tester) async {
    await pumpDetailScreen(
      tester,
      details: detailsWith(
        body:
            '<table><tr><td>가</td><td>나</td></tr></table>'
            '<table border="1"><tr><td>테두리 상자</td></tr></table>',
      ),
    );

    expect(tester.takeException(), isNull);
    expect(countOf(tester, 'HtmlTable'), 2);
  });

  testWidgets('글자뿐인 댓글은 HTML 위젯 없이 그리고, 링크가 있으면 HTML 위젯으로 그린다', (tester) async {
    final CommentItem sample = fakeDetails().comments.first;
    await pumpDetailScreen(
      tester,
      details: detailsWith(
        body: '본문',
        comments: [
          sample.copyWith(bodyHtml: '글자뿐인 댓글<br>둘째 줄'),
          sample.copyWith(bodyHtml: '<a href="https://example.com">링크 댓글</a>'),
        ],
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('글자뿐인 댓글\n둘째 줄'), findsOneWidget);
    expect(find.textContaining('링크 댓글', findRichText: true), findsOneWidget);
    // 본문 하나 + 링크 댓글 하나.
    expect(countOf(tester, 'HtmlWidget'), 2);
  });
}
