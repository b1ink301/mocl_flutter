import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_flutter/features/ads/presentation/widgets/detail_ad_card.dart';
import 'package:mocl_flutter/features/detail_page/presentation/widgets/detail_header_bar.dart';

import '../helpers/screen_harness.dart';

/// 상세 본문 sliver 배치. 본문 · 광고 · 댓글 · 하단 버튼이 한 `SliverMainAxisGroup`
/// 안에 섞여 있어서, 일반 위젯을 sliver 로 감싸지 않으면 렌더 오류가 나고
/// 순서 · 구분선이 바뀌어도 다른 테스트로는 드러나지 않는다.
void main() {
  /// 끝까지 한 번에 만들어지도록 길게 띄운다(화면 밖 sliver 는 만들어지지 않는다).
  const Size tall = Size(400, 4000);

  Finder text(String s) => find.textContaining(s, findRichText: true);

  double top(WidgetTester tester, Finder f) => tester.getTopLeft(f.first).dy;

  /// 작성자 헤더 안의 구분선은 빼고 센다(본문 그룹의 구분선만).
  int bodyDividers(WidgetTester tester) =>
      find.byType(PlainDividerWidget).evaluate().length -
      find
          .descendant(
            of: find.byType(DetailHeaderBar),
            matching: find.byType(PlainDividerWidget),
          )
          .evaluate()
          .length;

  testWidgets('위에서부터 헤더 → 본문 → 광고 → 댓글 머리 → 댓글 → 하단 버튼', (tester) async {
    await pumpDetailScreen(
      tester,
      details: fakeDetails(commentCount: 3),
      surface: tall,
    );
    expect(tester.takeException(), isNull);

    final List<double> ys = [
      top(tester, find.byType(DetailHeaderBar)),
      top(tester, text('본문 문단입니다.')),
      // 광고는 받기 전엔 접혀 offstage 일 수 있다. 자리만 본다.
      top(tester, find.byType(DetailAdCard, skipOffstage: false)),
      top(tester, text('댓글 3')),
      top(tester, text('댓글 0')),
      top(tester, text('댓글 2')),
      top(tester, text('새로고침')),
    ];
    expect(ys, orderedEquals([...ys]..sort()), reason: '배치 순서가 바뀌었다: $ys');
  });

  testWidgets('구분선: 댓글 머리 위 · 아래, 댓글 사이, 하단 버튼 위 · 아래', (tester) async {
    await pumpDetailScreen(
      tester,
      details: fakeDetails(commentCount: 3),
      surface: tall,
    );
    // 머리 위 · 아래 2 + 댓글 사이 2 + 하단 버튼 위 · 아래 2
    expect(bodyDividers(tester), 6);
  });

  testWidgets('댓글이 없으면 댓글 머리 없이 하단 버튼과 구분선 둘만', (tester) async {
    await pumpDetailScreen(
      tester,
      details: fakeDetails(commentCount: 0),
      surface: tall,
    );
    expect(tester.takeException(), isNull);
    expect(text('댓글 0'), findsNothing);
    expect(text('새로고침'), findsOneWidget);
    expect(bodyDividers(tester), 2);
    expect(top(tester, text('본문 문단입니다.')), lessThan(top(tester, text('새로고침'))));
  });

  testWidgets('끝까지 내리면 하단 버튼이 시스템 내비게이션 영역에 가리지 않는다', (tester) async {
    const double inset = 48;
    tester.view.padding = FakeViewPadding(
      bottom: inset * tester.view.devicePixelRatio,
    );
    addTearDown(tester.view.resetPadding);

    await pumpDetailScreen(tester, details: fakeDetails(commentCount: 20));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -20000));
    await tester.pumpAndSettle();

    final double screenBottom = kTestSurface.height;
    final Rect footer = tester.getRect(text('새로고침'));
    expect(
      footer.bottom,
      lessThanOrEqualTo(screenBottom - inset),
      reason: '하단 버튼이 아래 여백(${inset}dp) 안으로 들어갔다',
    );
  });
}
