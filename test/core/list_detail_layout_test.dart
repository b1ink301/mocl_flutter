import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';

/// 목록 하나 · 상세 라우트 하나로 된 최소 앱.
GoRouter _router() => GoRouter(
  initialLocation: '/list',
  routes: [
    GoRoute(
      path: '/list',
      builder: (_, _) => ListDetailLayout<String>(
        list: const _List(),
        detailBuilder: (_, item) => _Detail(item: item, inPane: true),
        pushDetail: (context, item) =>
            context.push<void>('/detail', extra: item),
        keyOf: (item) => item,
        detailRoutePath: '/detail',
      ),
    ),
    GoRoute(
      path: '/detail',
      builder: (_, state) =>
          _Detail(item: state.extra! as String, inPane: false),
      routes: [
        GoRoute(path: 'photo', builder: (_, _) => const Text('photo')),
      ],
    ),
  ],
);

class const _List() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      children: [
        for (final id in ['a', 'b'])
          ListTile(
            title: Text('row $id'),
            selected: ListDetailScope.isSelected(context, id),
            onTap: () {
              if (!ListDetailScope.tryOpen(context, id)) {
                context.push('/detail', extra: id);
              }
            },
          ),
      ],
    ),
  );
}

class const _Detail({required final String item, required final bool inPane})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Text('${inPane ? 'pane' : 'page'} $item'),
  );
}

Future<GoRouter> _pump(WidgetTester tester, double width) async {
  _setWidth(tester, width);
  final router = _router();
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
  return router;
}

void _setWidth(WidgetTester tester, double width) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 800);
  addTearDown(tester.view.reset);
}

void main() {
  test('창 크기 구분 경계값', () {
    expect(WindowSize.fromWidth(599), WindowSize.compact);
    expect(WindowSize.fromWidth(600), WindowSize.medium);
    expect(WindowSize.fromWidth(839), WindowSize.medium);
    expect(WindowSize.fromWidth(840), WindowSize.expanded);
    expect(WindowSize.fromWidth(1200), WindowSize.large);
    expect(WindowSize.medium.isSplit, isFalse);
    expect(WindowSize.expanded.isSplit, isTrue);
  });

  testWidgets('좁은 화면에서는 상세를 화면으로 쌓는다', (tester) async {
    await _pump(tester, 400);
    expect(find.text('글을 선택하세요'), findsNothing);

    await tester.tap(find.text('row a'));
    await tester.pumpAndSettle();
    expect(find.text('page a'), findsOneWidget);
  });

  testWidgets('넓은 화면에서는 목록 옆 칸에 연다', (tester) async {
    await _pump(tester, 1000);
    expect(find.text('글을 선택하세요'), findsOneWidget);

    await tester.tap(find.text('row b'));
    await tester.pumpAndSettle();
    expect(find.text('pane b'), findsOneWidget);
    expect(find.text('row a'), findsOneWidget); // 목록은 그대로
    expect(
      tester.widget<ListTile>(find.widgetWithText(ListTile, 'row b')).selected,
      isTrue,
    );
  });

  testWidgets('펼친 폴드를 접으면 옆 칸의 글을 화면으로 쌓는다', (tester) async {
    await _pump(tester, 1000);
    await tester.tap(find.text('row a'));
    await tester.pumpAndSettle();

    _setWidth(tester, 400);
    await tester.pumpAndSettle();
    expect(find.text('page a'), findsOneWidget);
    expect(find.text('pane a'), findsNothing);
  });

  testWidgets('접은 채 보던 글은 펼치면 옆 칸으로 옮긴다', (tester) async {
    final router = await _pump(tester, 400);
    await tester.tap(find.text('row a'));
    await tester.pumpAndSettle();

    _setWidth(tester, 1000);
    await tester.pumpAndSettle();
    expect(find.text('pane a'), findsOneWidget);
    expect(find.text('page a'), findsNothing);
    expect(router.routerDelegate.currentConfiguration.matches, hasLength(1));
  });

  testWidgets('상세 위에 다른 화면이 있으면 펼쳐도 건드리지 않는다', (tester) async {
    final router = await _pump(tester, 400);
    await tester.tap(find.text('row a'));
    await tester.pumpAndSettle();
    router.push('/detail/photo');
    await tester.pumpAndSettle();

    _setWidth(tester, 1000);
    await tester.pumpAndSettle();
    expect(find.text('photo'), findsOneWidget);
    expect(router.routerDelegate.currentConfiguration.matches, hasLength(3));
  });
}
