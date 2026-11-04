import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cupertino_ui/cupertino_ui.dart' show CupertinoPageTransition;
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/swipe_back_page.dart';

void main() {
  Future<void> pumpDetail(
    WidgetTester tester, {
    bool canSwipe = true,
    Widget detail = const Scaffold(body: Center(child: Text('상세'))),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  SwipeBackPageRoute<void>(
                    canSwipe: canSwipe,
                    builder: (_) => detail,
                  ),
                ),
                child: const Text('목록'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('목록'));
    await tester.pumpAndSettle();
    expect(find.text('상세'), findsOneWidget);
  }

  Future<void> sendBackGesture(
    WidgetTester tester,
    String method, [
    Map<String, Object?>? arguments,
  ]) => tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/backgesture',
    const StandardMethodCodec().encodeMethodCall(MethodCall(method, arguments)),
    (_) {},
  );

  Map<String, Object?> backEvent(double progress, {int swipeEdge = 0}) =>
      <String, Object?>{
        'touchOffset': <double>[5, 300],
        'progress': progress,
        'swipeEdge': swipeEdge,
      };

  double detailLeft(WidgetTester tester) =>
      tester.getTopLeft(find.text('상세')).dx;

  group('본문 드래그', () {
    testWidgets('화면 가운데서 오른쪽으로 절반 넘게 끌면 닫힌다', (tester) async {
      await pumpDetail(tester);
      final double width = tester.getSize(find.byType(MaterialApp)).width;

      final TestGesture gesture = await tester.startGesture(
        Offset(width / 2 - 100, 300),
      );
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      final double before = detailLeft(tester);
      await gesture.moveBy(Offset(width * 0.6, 0));
      await tester.pump();
      // 손가락을 따라 화면이 밀린다.
      expect(detailLeft(tester), greaterThan(before + width * 0.5));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
      expect(find.text('목록'), findsOneWidget);
    });

    testWidgets('조금만 끌다 놓으면 제자리로 돌아온다', (tester) async {
      await pumpDetail(tester);
      final double start = detailLeft(tester);

      final TestGesture gesture = await tester.startGesture(
        const Offset(200, 300),
      );
      // 천천히 끌어 플링으로 보지 않게 한다.
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(6, 0));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pump(const Duration(milliseconds: 200));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('상세'), findsOneWidget);
      expect(detailLeft(tester), start);
    });

    testWidgets('왼쪽으로 끌면 받지 않는다', (tester) async {
      await pumpDetail(tester);
      final double start = detailLeft(tester);

      final TestGesture gesture = await tester.startGesture(
        const Offset(300, 300),
      );
      await gesture.moveBy(const Offset(-200, 0));
      await tester.pump();
      expect(detailLeft(tester), start);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsOneWidget);
    });

    testWidgets('본문 안에 가로 드래그 · 텍스트 선택이 있어도 뒤로가기가 먼저 받는다', (tester) async {
      var innerDrags = 0;
      await pumpDetail(
        tester,
        detail: Scaffold(
          body: SelectionArea(
            child: GestureDetector(
              onHorizontalDragUpdate: (_) => innerDrags++,
              child: const SizedBox.expand(child: Center(child: Text('상세'))),
            ),
          ),
        ),
      );

      await tester.flingFrom(
        const Offset(200, 300),
        const Offset(400, 0),
        2000,
      );
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
      expect(innerDrags, 0);
    });

    testWidgets('드래그 도중 라우트가 사라져도 제스처 상태가 남지 않는다', (tester) async {
      await pumpDetail(tester);
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      final Route<dynamic> detail = ModalRoute.of(
        tester.element(find.text('상세')),
      )!;

      final TestGesture gesture = await tester.startGesture(
        const Offset(100, 300),
      );
      await gesture.moveBy(const Offset(80, 0));
      await tester.pump();
      expect(navigator.userGestureInProgress, isTrue);

      // 딥링크 등으로 스택이 바뀐 상황.
      navigator.removeRoute(detail);
      await tester.pumpAndSettle();
      await gesture.up();
      await tester.pumpAndSettle();
      expect(navigator.userGestureInProgress, isFalse);
    });

    testWidgets('canSwipe 가 false 면 끌어도 닫히지 않는다', (tester) async {
      await pumpDetail(tester, canSwipe: false);
      await tester.flingFrom(
        const Offset(100, 300),
        const Offset(400, 0),
        2000,
      );
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsOneWidget);
    });
  });

  group('뒤 화면 막(dim)', () {
    Future<void> pumpStack(WidgetTester tester, {ThemeData? theme}) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Navigator(
            onGenerateRoute: (_) => SwipeBackPageRoute<void>(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                      SwipeBackPageRoute<void>(
                        builder: (_) =>
                            const Scaffold(body: Center(child: Text('상세'))),
                      ),
                    ),
                    child: const Text('목록'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('목록'));
      await tester.pumpAndSettle();
    }

    /// 목록(뒤 화면)을 덮는 막의 불투명도.
    double listScrim(WidgetTester tester) => tester
        .widget<FadeTransition>(
          find.descendant(
            // 상세가 다 덮고 있으면 목록은 화면 밖(offstage)으로 빠져 있다.
            of: find.ancestor(
              of: find.text('목록', skipOffstage: false),
              matching: find.byType(
                CupertinoPageTransition,
                skipOffstage: false,
              ),
            ),
            matching: find.byKey(
              SwipeBackPageRoute.scrimKey,
              skipOffstage: false,
            ),
          ),
        )
        .opacity
        .value;

    testWidgets('상세가 덮고 있으면 진하고, 끄는 만큼 옅어지고, 닫히면 사라진다', (tester) async {
      await pumpStack(tester);
      expect(listScrim(tester), closeTo(0.2, 0.001));

      final TestGesture gesture = await tester.startGesture(
        const Offset(100, 300),
      );
      await gesture.moveBy(const Offset(40, 0));
      await gesture.moveBy(const Offset(360, 0));
      await tester.pump();
      final double dragging = listScrim(tester);
      expect(dragging, greaterThan(0));
      expect(dragging, lessThan(0.2));

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
      expect(listScrim(tester), 0);
    });

    testWidgets('어두운 테마는 더 진하게 덮는다', (tester) async {
      await pumpStack(tester, theme: ThemeData(brightness: Brightness.dark));
      expect(listScrim(tester), closeTo(0.45, 0.001));
    });

    testWidgets('막은 터치를 막지 않는다', (tester) async {
      await pumpStack(tester);
      // 맨 위 화면(상세)에도 막이 있지만 투명하고, 터치는 그대로 지나간다.
      final NavigatorState navigator = tester.state(
        find.byType(Navigator).last,
      );
      navigator.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('목록'));
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsOneWidget);
    });
  });

  group('시스템 뒤로가기 제스처', () {
    testWidgets('진행률만큼 화면이 밀리고, 커밋하면 닫힌다', (tester) async {
      await pumpDetail(tester);
      final double start = detailLeft(tester);

      await sendBackGesture(tester, 'startBackGesture', backEvent(0));
      await tester.pump();
      await sendBackGesture(
        tester,
        'updateBackGestureProgress',
        backEvent(0.4),
      );
      await tester.pump();
      // 손을 놓기 전에 이미 이전 화면이 드러난다.
      expect(detailLeft(tester), greaterThan(start));
      expect(find.text('목록'), findsOneWidget);

      await sendBackGesture(tester, 'commitBackGesture');
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('오른쪽 가장자리에서 시작해도 같은 애니메이션으로 움직인다', (tester) async {
      await pumpDetail(tester);
      final double start = detailLeft(tester);

      await sendBackGesture(
        tester,
        'startBackGesture',
        backEvent(0, swipeEdge: 1),
      );
      await sendBackGesture(
        tester,
        'updateBackGestureProgress',
        backEvent(0.3, swipeEdge: 1),
      );
      await tester.pump();
      expect(detailLeft(tester), greaterThan(start));
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('취소하면 제자리로 돌아온다', (tester) async {
      await pumpDetail(tester);
      final double start = detailLeft(tester);

      await sendBackGesture(tester, 'startBackGesture', backEvent(0));
      await sendBackGesture(
        tester,
        'updateBackGestureProgress',
        backEvent(0.3),
      );
      await tester.pump();
      await sendBackGesture(tester, 'cancelBackGesture');
      await tester.pumpAndSettle();

      expect(find.text('상세'), findsOneWidget);
      expect(detailLeft(tester), start);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('가장자리(시스템 제스처 영역)에서 시작한 터치는 본문 드래그로 받지 않는다', (tester) async {
      // 제스처 내비게이션: 양쪽 20dp 는 OS 가 뒤로가기로 가져간다.
      tester.view.systemGestureInsets = FakeViewPadding(
        left: 20 * tester.view.devicePixelRatio,
        right: 20 * tester.view.devicePixelRatio,
      );
      addTearDown(tester.view.resetSystemGestureInsets);
      await pumpDetail(tester);
      final double start = detailLeft(tester);

      final TestGesture gesture = await tester.startGesture(
        const Offset(5, 300),
      );
      await gesture.moveBy(const Offset(150, 0));
      await tester.pump();
      expect(detailLeft(tester), start);

      // OS 가 시스템 제스처로 판정하면 그쪽이 같은 애니메이션을 움직인다.
      await sendBackGesture(tester, 'startBackGesture', backEvent(0));
      await sendBackGesture(
        tester,
        'updateBackGestureProgress',
        backEvent(0.4),
      );
      await tester.pump();
      expect(detailLeft(tester), greaterThan(start));
      await gesture.cancel();
      await sendBackGesture(tester, 'commitBackGesture');
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('본문 드래그 중에 시스템 제스처가 오면 넘겨받는다', (tester) async {
      await pumpDetail(tester);
      final NavigatorState navigator = tester.state(find.byType(Navigator));

      final TestGesture gesture = await tester.startGesture(
        const Offset(100, 300),
      );
      await gesture.moveBy(const Offset(60, 0));
      await tester.pump();
      expect(navigator.userGestureInProgress, isTrue);

      await sendBackGesture(tester, 'startBackGesture', backEvent(0.2));
      await sendBackGesture(
        tester,
        'updateBackGestureProgress',
        backEvent(0.5),
      );
      await tester.pump();
      // OS 가 시스템 제스처로 판정하면 앱 쪽 포인터는 취소된다.
      await gesture.cancel();
      await tester.pump();
      expect(find.text('상세'), findsOneWidget);

      await sendBackGesture(tester, 'commitBackGesture');
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsNothing);
      expect(navigator.userGestureInProgress, isFalse);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));

    testWidgets('PopScope 로 막힌 화면은 애니메이션 없이 평소처럼 처리한다', (tester) async {
      var popAttempts = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                SwipeBackPageRoute<void>(
                  builder: (_) => PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (_, _) => popAttempts++,
                    child: const Scaffold(body: Center(child: Text('상세'))),
                  ),
                ),
              ),
              child: const Text('목록'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('목록'));
      await tester.pumpAndSettle();
      final double start = detailLeft(tester);

      await sendBackGesture(tester, 'startBackGesture', backEvent(0));
      await sendBackGesture(
        tester,
        'updateBackGestureProgress',
        backEvent(0.5),
      );
      await tester.pump();
      expect(detailLeft(tester), start);

      await sendBackGesture(tester, 'commitBackGesture');
      await tester.pumpAndSettle();
      expect(find.text('상세'), findsOneWidget);
      expect(popAttempts, 1);
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });
}
