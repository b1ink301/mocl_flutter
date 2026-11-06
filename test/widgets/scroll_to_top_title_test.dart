import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/scroll_to_top_title.dart';

void main() {
  Future<ScrollController> pumpScreen(WidgetTester tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            controller: controller,
            slivers: [
              const SliverAppBar(
                floating: true,
                title: ScrollToTopTitle(child: Text('크럼브')),
              ),
              SliverList.builder(
                itemCount: 500,
                itemBuilder: (_, i) => SizedBox(height: 50, child: Text('$i')),
              ),
            ],
          ),
        ),
      ),
    );
    return controller;
  }

  testWidgets('툴바를 탭하면 맨 위로 올라간다', (tester) async {
    final controller = await pumpScreen(tester);
    // 화면 하나 남짓 아래로 → 점프 없이 애니메이션만.
    controller.jumpTo(800);
    await tester.pump();
    // floating 앱바를 다시 내리려고 살짝 역스크롤.
    await tester.timedDrag(
      find.byType(CustomScrollView),
      const Offset(0, 100),
      const Duration(milliseconds: 500),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ScrollToTopTitle));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });

  testWidgets('멀리 내려가 있어도 맨 위로 돌아온다(점프 후 애니메이션)', (tester) async {
    final controller = await pumpScreen(tester);
    controller.jumpTo(20000);
    await tester.pump();
    await tester.timedDrag(
      find.byType(CustomScrollView),
      const Offset(0, 100),
      const Duration(milliseconds: 500),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ScrollToTopTitle));
    await tester.pump();
    // 첫 프레임에 이미 뷰포트 한 화면 근처까지 와 있다.
    expect(controller.offset, lessThanOrEqualTo(600 + 1));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });

  testWidgets('크럼브가 비어 있어도 툴바 빈 곳을 탭하면 동작한다', (tester) async {
    final controller = await pumpScreen(tester);
    controller.jumpTo(800);
    await tester.pump();
    await tester.timedDrag(
      find.byType(CustomScrollView),
      const Offset(0, 100),
      const Duration(milliseconds: 500),
    );
    await tester.pumpAndSettle();

    // 제목 글자에서 멀리 떨어진 툴바 오른쪽 부분.
    final rect = tester.getRect(find.byType(ScrollToTopTitle));
    await tester.tapAt(Offset(rect.right - 10, rect.center.dy));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });
}
