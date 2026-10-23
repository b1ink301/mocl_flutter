import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/boot_failure_app.dart';

void main() {
  testWidgets('재시도가 또 실패해 같은 자리에 다시 그려지면 버튼이 돌아온다', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      BootFailureApp(error: StateError('1차'), onRetry: () => retries++),
    );

    await tester.tap(find.text('다시 시도'));
    await tester.pump();
    expect(retries, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('다시 시도'), findsNothing);

    // BootGuard 가 실패 화면을 새로 runApp 한 상황(같은 타입, 같은 위치).
    await tester.pumpWidget(
      BootFailureApp(error: StateError('2차'), onRetry: () => retries++),
    );
    expect(find.text('다시 시도'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('시간 초과 화면에는 재시도 버튼 없이 진행 표시만 있다', (tester) async {
    await tester.pumpWidget(const BootFailureApp());
    expect(find.text('시작이 늦어지고 있어요'), findsOneWidget);
    expect(find.text('다시 시도'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('스모크 테스트가 찾는 semantics id 가 붙어 있다', (tester) async {
    await tester.pumpWidget(
      BootFailureApp(error: StateError('x'), onRetry: () {}),
    );
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Semantics &&
            w.properties.identifier == BootFailureApp.semanticsId,
      ),
      findsOneWidget,
    );
  });
}
