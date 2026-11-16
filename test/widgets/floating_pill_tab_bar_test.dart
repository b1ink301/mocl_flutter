import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/floating_pill_tab_bar.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_page.dart';

/// 홈 탭바가 좁은 폰 · 큰 시스템 글자에서도 넘치지 않고 화면 안으로 줄어드는지.
/// (바깥 Row 가 폭을 묶지 않으면 FittedBox 가 줄이지 못하고 넘친다.)
void main() {
  Future<void> pump(WidgetTester tester, double width, double scale) async {
    tester.view.physicalSize = Size(width * 2, 800 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: Scaffold(
          bottomNavigationBar: FloatingPillTabBar(
            items: [for (final MainTab tab in MainTab.values) tab.item],
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      ),
    );
  }

  for (final (double width, double scale) in [
    (320.0, 1.0),
    (360.0, 1.0),
    (360.0, 1.5),
    (393.0, 2.0),
  ]) {
    testWidgets('폭 $width · 글자 $scale배에서 넘치지 않는다', (tester) async {
      await pump(tester, width, scale);
      expect(tester.takeException(), isNull);
      final Rect bar = tester.getRect(find.byType(FittedBox));
      expect(bar.left, greaterThanOrEqualTo(0));
      expect(bar.right, lessThanOrEqualTo(width));
    });
  }

  testWidgets('넉넉한 화면에서는 줄이지 않는다', (tester) async {
    await pump(tester, 412, 1.0);
    final Size fitted = tester.getSize(find.byType(FittedBox));
    // FittedBox 바로 아래 탭 줄(선택 표시를 그리는 줄)의 크기.
    final Size row = tester.getSize(
      find
          .descendant(
            of: find.byType(FittedBox),
            matching: find.byWidgetPredicate(
              (w) => w.runtimeType.toString() == '_PillTabRow',
            ),
          )
          .first,
    );
    expect(fitted.width, closeTo(row.width, 0.5));
  });

  testWidgets('탭을 바꾸면 선택 표시가 옮겨 가고, 움직이는 중에 또 바꿔도 제자리에 멈춘다', (tester) async {
    int selected = 0;
    late StateSetter setState;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, set) {
            setState = set;
            return Scaffold(
              bottomNavigationBar: FloatingPillTabBar(
                items: [for (final MainTab tab in MainTab.values) tab.item],
                selectedIndex: selected,
                onSelected: (i) => set(() => selected = i),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text(MainTab.values[1].item.label));
    await tester.pump();
    expect(selected, 1);
    await tester.pump(const Duration(milliseconds: 100));
    // 움직이는 중에 다른 탭으로 방향을 튼다.
    setState(() => selected = 3);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
