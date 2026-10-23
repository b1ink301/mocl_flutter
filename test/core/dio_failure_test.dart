import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

DioException _dio(DioExceptionType type, {int? status}) {
  final RequestOptions options = RequestOptions(path: '/');
  return DioException(
    requestOptions: options,
    type: type,
    response: status == null
        ? null
        : Response<void>(requestOptions: options, statusCode: status),
  );
}

void main() {
  group('failureFromDio', () {
    test('429 는 RateLimitFailure, 다른 오류 응답은 ServerFailure', () {
      expect(
        failureFromDio(_dio(DioExceptionType.badResponse, status: 429)),
        isA<RateLimitFailure>(),
      );
      expect(
        failureFromDio(_dio(DioExceptionType.badResponse, status: 503)),
        const ServerFailure(message: '서버 오류 (HTTP 503)'),
      );
    });

    test('연결 문제는 NetworkFailure', () {
      expect(
        failureFromDio(_dio(DioExceptionType.connectionError)),
        isA<NetworkFailure>(),
      );
      expect(
        failureFromDio(_dio(DioExceptionType.receiveTimeout)),
        isA<NetworkFailure>(),
      );
    });
  });

  group('isExpectedDioFailure — Crashlytics 로 올리지 않을 실패', () {
    test('연결 끊김 · 타임아웃 · 취소 · 429 는 예상된 실패', () {
      expect(
        isExpectedDioFailure(_dio(DioExceptionType.connectionError)),
        isTrue,
      );
      expect(
        isExpectedDioFailure(_dio(DioExceptionType.connectionTimeout)),
        isTrue,
      );
      expect(isExpectedDioFailure(_dio(DioExceptionType.cancel)), isTrue);
      expect(
        isExpectedDioFailure(_dio(DioExceptionType.badResponse, status: 429)),
        isTrue,
      );
    });

    test('5xx · 4xx · 인증서 · 알 수 없는 오류는 리포트한다', () {
      expect(
        isExpectedDioFailure(_dio(DioExceptionType.badResponse, status: 500)),
        isFalse,
      );
      expect(
        isExpectedDioFailure(_dio(DioExceptionType.badResponse, status: 403)),
        isFalse,
      );
      expect(
        isExpectedDioFailure(_dio(DioExceptionType.badCertificate)),
        isFalse,
      );
      expect(isExpectedDioFailure(_dio(DioExceptionType.unknown)), isFalse);
    });
  });
}
