import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/failure_view.dart';

void main() {
  Future<void> pump(WidgetTester tester, Object? error) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: FailureView(error: error, onRetry: () {}),
      ),
    ),
  );

  testWidgets('권한 부족은 사유를 보여주고 재시도 버튼을 감춘다', (tester) async {
    await pump(
      tester,
      const PermissionFailure(message: '게시글을 읽기 위한 레벨이 부족합니다.'),
    );

    expect(find.text('읽을 수 있는 권한이 없어요', findRichText: true), findsOneWidget);
    expect(
      find.text('게시글을 읽기 위한 레벨이 부족합니다.', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('다시 시도', findRichText: true), findsNothing);
  });

  testWidgets('dio 원시 메시지는 노출하지 않고 안내 문구로 바꾼다', (tester) async {
    await pump(
      tester,
      const NetworkFailure(
        message:
            'This exception was thrown because the response has a status code '
            'of 500 and RequestOptions.validateStatus was configured to throw',
      ),
    );

    expect(find.text('연결에 실패했어요', findRichText: true), findsOneWidget);
    expect(
      find.text('네트워크 상태를 확인한 뒤 다시 시도해 주세요.', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('다시 시도', findRichText: true), findsOneWidget);
  });

  testWidgets('Failure 가 아닌 예외도 일반 안내로 보여준다', (tester) async {
    await pump(tester, StateError('boom'));

    expect(find.text('문제가 발생했어요', findRichText: true), findsOneWidget);
  });
}
