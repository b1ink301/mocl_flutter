import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

/// 부팅이 [timeout] 안에 끝나지 않았을 때 [BootGuard] 가 리포트하는 예외.
class const BootTimeoutException(final Duration timeout) implements Exception {
  @override
  String toString() =>
      'BootTimeoutException: ${timeout.inSeconds}s 안에 부팅이 끝나지 않음';
}

/// 부팅 실패 화면을 그리는 함수.
///
/// [error] 가 null 이면 시간 초과(아직 진행 중)이고, 그때 [onRetry] 는 null 이다.
/// 진행 중인 부팅과 겹치지 않도록, 재시도는 앞선 시도가 끝난 뒤에만 준다.
typedef BootFailureBuilder = Widget Function({
  Object? error,
  VoidCallback? onRetry,
});

/// 앱 부팅을 감싸 **어떤 경우에도 첫 프레임이 그려지게** 한다.
///
/// `runApp` 전에 던지거나 끝나지 않는 `await` 가 있으면 안드로이드는 런치
/// 테마(스플래시)를 계속 띄운다. 사용자는 이유도 모른 채 갇히고 리포트도
/// 남지 않는다. 그래서
/// - [prepare] 가 던지면 → 실패 화면 + 재시도
/// - [timeout] 안에 끝나지 않으면 → 지연 화면. 나중에 끝나면 그 결과로 교체
/// 한다.
class BootGuard({
  /// 앱 위젯을 만들 때까지의 모든 초기화. 재시도 때 다시 불린다.
  required final Future<Widget> Function() prepare,
  required final BootFailureBuilder failureBuilder,
  final Duration timeout = const Duration(seconds: 10),

  /// 테스트에서 실제 `runApp` 대신 넣는다.
  final void Function(Widget app) _runApp = _defaultRunApp,
}) {
  static void _defaultRunApp(Widget app) => runApp(app);

  bool _running = false;

  /// 부팅을 시작한다. 이미 진행 중이면(재시도 연타 등) 무시한다.
  Future<void> start() async {
    if (_running) return;
    _running = true;
    try {
      await _attempt();
    } finally {
      _running = false;
    }
  }

  Future<void> _attempt() async {
    final Timer watchdog = Timer(timeout, () {
      MoclLogger.e('부팅 시간 초과', error: BootTimeoutException(timeout));
      _runApp(failureBuilder());
    });

    final Widget app;
    try {
      app = await prepare();
    } catch (e, st) {
      watchdog.cancel();
      MoclLogger.e('부팅 실패', error: e, stackTrace: st);
      _runApp(failureBuilder(error: e, onRetry: () => unawaited(start())));
      return;
    }
    watchdog.cancel();
    _runApp(app);
  }
}
