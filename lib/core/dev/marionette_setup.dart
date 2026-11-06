import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 앱 binding 을 준비한다. debug 빌드에서만 Marionette binding 을 쓴다.
///
/// Marionette(`marionette_mcp` · `marionette` CLI)는 debug 로 띄운 앱의 VM service 에
/// 붙어 AI 에이전트가 화면을 읽고 누르게 한다. 개발 중 실제 사이트로 고친 동작을
/// 확인하는 용도다. [kDebugMode] 는 컴파일 타임 상수라 release 에는 binding 도
/// 설정도 들어가지 않는다.
///
/// binding 은 앱에 하나만 둘 수 있으므로 `WidgetsFlutterBinding.ensureInitialized`
/// 대신 이 함수를 부른다.
void ensureAppBinding() {
  if (!kDebugMode) {
    WidgetsFlutterBinding.ensureInitialized();
    return;
  }

  // get_logs 가 MoclLogger 로그를 돌려주도록 수집기에도 보낸다(콘솔 출력은 그대로).
  final PrintLogCollector logs = PrintLogCollector();
  MoclLogger.printer =
      (
        String tag,
        int level,
        String message, {
        Object? error,
        StackTrace? stackTrace,
      }) {
        logs.addLog('[$tag] $message${error == null ? '' : ' | $error'}');
        MoclLogger.consolePrinter(
          tag,
          level,
          message,
          error: error,
          stackTrace: stackTrace,
        );
      };

  MarionetteBinding.ensureInitialized(
    MarionetteConfiguration(
      logCollector: logs,
      // 작업마다 .marionette/sessions/ 에 steps.md 를 남긴다(gitignore).
      enableSessionReports: true,
    ),
  );
}
