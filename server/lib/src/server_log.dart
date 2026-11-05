import 'dart:io';

import 'package:mocl_shared/util/mocl_logger.dart';

/// 서버 로그. 컨테이너 로그(`docker compose logs`)로 보이게 stdout/stderr 에 쓴다.
///
/// `MoclLogger` 의 d/i/w 는 AOT(릴리즈) 실행에서 사라지므로, 운영 중에도 남겨야
/// 하는 로그(접속 · 설정 변경 · 오류)는 이 함수로 쓴다.
void serverLog(String message, {bool error = false}) {
  final String line = '${DateTime.now().toUtc().toIso8601String()} $message';
  (error ? stderr : stdout).writeln(line);
}

/// 공유 패키지(파서 등)가 남기는 로그를 서버 출력으로 돌린다.
void installServerLogging() {
  // d/i/w 는 `dart run`(JIT) 개발 실행에서만 나온다.
  MoclLogger.printer =
      (
        String tag,
        int level,
        String message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
        serverLog(
          '[$tag] $message${error != null ? ' $error' : ''}',
          error: level >= 1000,
        );
        if (stackTrace != null) stderr.writeln(stackTrace);
      };
  // e 는 빌드 모드와 상관없이 여기로 온다.
  MoclLogger.onError =
      (Object error, StackTrace? stackTrace, {String? reason}) {
        serverLog('[error] ${reason ?? ''} $error', error: true);
        if (stackTrace != null) stderr.writeln(stackTrace);
      };
}
