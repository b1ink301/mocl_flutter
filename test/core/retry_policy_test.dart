import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/main.dart' show retry;

void main() {
  group('provider 재시도 정책', () {
    test('권한/로그인/파싱 실패는 재시도하지 않는다', () {
      expect(retry(0, const PermissionFailure(message: '레벨 부족')), isNull);
      expect(retry(0, const NotLoginFailure(message: '로그인 필요')), isNull);
      expect(retry(0, const GetDetailFailure(message: '파싱 실패')), isNull);
    });

    test('일시적 오류는 지수 백오프로 3번까지 재시도한다', () {
      const error = NetworkFailure(message: '인터넷에 연결할 수 없어요.');
      expect(retry(0, error), const Duration(milliseconds: 300));
      expect(retry(1, error), const Duration(milliseconds: 600));
      expect(retry(2, error), const Duration(milliseconds: 1200));
      expect(retry(3, error), isNull);
      expect(
        retry(0, const ServerFailure(message: '서버 오류 (HTTP 503)')),
        const Duration(milliseconds: 300),
      );
    });
  });
}
