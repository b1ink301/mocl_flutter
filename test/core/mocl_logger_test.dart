import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

void main() {
  tearDown(() => MoclLogger.onError = null);

  group('redactHeaders', () {
    test('민감한 헤더 값만 마스킹하고 키 이름은 유지한다', () {
      final String result = MoclLogger.redactHeaders({
        'User-Agent': 'mocl/1.0',
        'Cookie': 'SESSION=super-secret',
        'Authorization': 'Bearer abc.def.ghi',
      });

      expect(result, contains('User-Agent: mocl/1.0'));
      expect(result, contains('Cookie: ***'));
      expect(result, contains('Authorization: ***'));
      expect(result, isNot(contains('super-secret')));
      expect(result, isNot(contains('abc.def.ghi')));
    });

    test('헤더 키 비교는 대소문자를 구분하지 않는다', () {
      expect(
        MoclLogger.redactHeaders({'cOoKiE': 'leak'}),
        equals('{cOoKiE: ***}'),
      );
    });

    test('null 과 빈 맵은 빈 중괄호로 표현한다', () {
      expect(MoclLogger.redactHeaders(null), equals('{}'));
      expect(MoclLogger.redactHeaders(const {}), equals('{}'));
    });
  });

  group('onError 싱크', () {
    test('e() 는 error / stackTrace / reason 을 싱크로 넘긴다', () {
      Object? captured;
      StackTrace? capturedStack;
      String? capturedReason;
      MoclLogger.onError =
          (Object error, StackTrace? stackTrace, {String? reason}) {
            captured = error;
            capturedStack = stackTrace;
            capturedReason = reason;
          };

      final Exception failure = Exception('업로드 실패');
      final StackTrace stack = StackTrace.current;
      MoclLogger.e('DB 업로드 실패', error: failure, stackTrace: stack);

      expect(captured, same(failure));
      expect(capturedStack, same(stack));
      expect(capturedReason, equals('DB 업로드 실패'));
    });

    test('error 인자가 없으면 메시지 자체를 에러로 넘긴다', () {
      Object? captured;
      MoclLogger.onError =
          (Object error, StackTrace? stackTrace, {String? reason}) {
            captured = error;
          };

      MoclLogger.e('원인 객체 없는 실패');

      expect(captured, equals('원인 객체 없는 실패'));
    });

    test('d/i/w 는 싱크를 호출하지 않는다', () {
      var calls = 0;
      MoclLogger.onError =
          (Object error, StackTrace? stackTrace, {String? reason}) {
            calls++;
          };

      MoclLogger.d(() => 'debug');
      MoclLogger.i(() => 'info');
      MoclLogger.w(() => 'warn');

      expect(calls, isZero);
    });
  });
}
