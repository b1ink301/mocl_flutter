import 'package:flutter/foundation.dart';

/// [MoclLogger]는 개발 단계에서만 로그를 남기고, 릴리즈 시에는 코드가 완전히 제거됩니다.
/// assert() 문법을 활용하여 릴리즈 빌드 오버헤드를 제로화합니다.
abstract class MoclLogger {
  /// 로그를 출력합니다.
  /// 릴리즈 빌드에서는 assert 구문이 동작하지 않으므로 이 함수는 아무 일도 하지 않으며,
  /// 컴파일 시점에 호출부 자체가 제거됩니다.
  static void log(String message) {
    assert(() {
      debugPrint('[MOCL] $message');
      return true;
    }());
  }

  /// 태그와 함께 로그를 출력합니다.
  static void logWithTag(String tag, String message) {
    assert(() {
      debugPrint('[MOCL][$tag] $message');
      return true;
    }());
  }
}
