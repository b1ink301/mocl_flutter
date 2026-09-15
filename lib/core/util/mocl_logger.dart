import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// 릴리즈 빌드에서도 살아남는 에러 싱크.
///
/// Crashlytics / Sentry 등 크래시 리포터를 붙이는 지점이다.
/// (예: `MoclLogger.onError = FirebaseCrashlytics.instance.recordError;`)
typedef LogErrorSink = void Function(
  Object error,
  StackTrace? stackTrace, {
  String? reason,
});

/// 앱 전역 로거.
///
/// ## 릴리즈 빌드 동작
/// `debug` / `info` / `warn` 는 [kDebugMode] 가 컴파일 타임 상수 `false` 이므로
/// AOT 컴파일 시 본문이 통째로 제거되고, 인자로 넘긴 클로저도 인라이닝 과정에서
/// 함께 사라진다. 따라서 **문자열 보간 비용조차 발생하지 않는다.**
/// 이것이 메시지를 `String` 이 아니라 `String Function()` 으로 받는 이유다.
///
/// `error` 만 릴리즈에서도 [onError] 싱크로 전달된다. 콘솔(logcat) 출력은
/// 디버그 빌드에서만 이뤄지므로 사용자 단말에 로그가 남지 않는다.
///
/// ## 사용
/// ```dart
/// MoclLogger.d(() => '[getList] $url response = ${response.statusCode}');
/// MoclLogger.e('DB 업로드 실패', error: e, stackTrace: st);
/// ```
///
/// ## 주의
/// 민감 정보(쿠키, 토큰, Authorization 헤더)를 그대로 보간하지 말 것.
/// 헤더는 반드시 [redactHeaders] 로 마스킹해서 남긴다.
abstract class MoclLogger() {
  static const String _defaultTag = 'MOCL';

  /// 릴리즈에서도 호출되는 에러 싱크. 기본값은 `null`(아무 것도 하지 않음).
  static LogErrorSink? onError;

  /// 상세 디버그 로그. 릴리즈에서 완전히 제거된다.
  static void d(String Function() message, {String tag = _defaultTag}) =>
      _emit(message, tag, 500);

  /// 일반 정보 로그. 릴리즈에서 완전히 제거된다.
  static void i(String Function() message, {String tag = _defaultTag}) =>
      _emit(message, tag, 800);

  /// 경고 로그. 릴리즈에서 완전히 제거된다.
  static void w(String Function() message, {String tag = _defaultTag}) =>
      _emit(message, tag, 900);

  /// 에러 로그.
  ///
  /// 디버그에서는 콘솔에 출력하고, 빌드 모드와 무관하게 [onError] 싱크로 전달한다.
  /// 메시지를 지연 평가하지 않는 이유는 에러 경로가 드물게 실행되고,
  /// 릴리즈에서도 리포터에 실제 문자열을 넘겨야 하기 때문이다.
  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = _defaultTag,
  }) {
    onError?.call(error ?? message, stackTrace, reason: message);
    if (!kDebugMode) return;
    developer.log(
      message,
      name: tag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _emit(String Function() message, String tag, int level) {
    if (!kDebugMode) return;
    developer.log(message(), name: tag, level: level);
  }

  /// 로그에 남기면 안 되는 헤더 키(소문자 비교).
  static const Set<String> _sensitiveHeaderKeys = {
    'cookie',
    'set-cookie',
    'authorization',
    'proxy-authorization',
    'x-api-key',
    'api-key',
    'x-auth-token',
    'x-csrf-token',
    'x-naver-client-secret',
    'access_token',
    'refresh_token',
  };

  /// 헤더 맵을 로그용 문자열로 바꾸되 민감한 값은 `***` 로 마스킹한다.
  ///
  /// 키 이름은 디버깅에 필요하므로 유지하고 값만 가린다.
  /// 디버그 빌드에서만 호출되도록 [d] 등의 클로저 안에서 사용할 것.
  static String redactHeaders(Map<String, Object?>? headers) {
    if (headers == null || headers.isEmpty) return '{}';
    final StringBuffer buffer = StringBuffer('{');
    bool first = true;
    for (final MapEntry<String, Object?> entry in headers.entries) {
      if (!first) buffer.write(', ');
      first = false;
      buffer.write(entry.key);
      buffer.write(': ');
      buffer.write(
        _sensitiveHeaderKeys.contains(entry.key.toLowerCase())
            ? '***'
            : entry.value,
      );
    }
    buffer.write('}');
    return buffer.toString();
  }
}
