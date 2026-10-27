import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/util/boot_guard.dart';

/// 실패 화면 대신 들어가는 표식. 어떤 인자로 불렸는지 남긴다.
class const _Failure({final Object? error, final VoidCallback? onRetry})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  const Duration timeout = Duration(milliseconds: 50);
  const Widget app = Text('app', textDirection: TextDirection.ltr);

  late List<Widget> shown;
  late int prepareCalls;

  setUp(() {
    shown = [];
    prepareCalls = 0;
  });

  BootGuard guard(Future<Widget> Function() prepare) => BootGuard(
    prepare: () {
      prepareCalls++;
      return prepare();
    },
    failureBuilder: ({Object? error, VoidCallback? onRetry}) =>
        _Failure(error: error, onRetry: onRetry),
    timeout: timeout,
    runApp: shown.add,
  );

  Future<void> pastTimeout() => Future<void>.delayed(timeout * 2);

  test('정상 부팅이면 앱만 띄우고, 시간이 지나도 실패 화면이 끼어들지 않는다', () async {
    await guard(() async => app).start();
    await pastTimeout();

    expect(shown, [app]);
  });

  test('준비 중 던지면 오류와 재시도를 담은 실패 화면을 띄운다', () async {
    var fail = true;
    await guard(() async {
      if (fail) throw StateError('prefs 실패');
      return app;
    }).start();

    final _Failure failure = shown.single as _Failure;
    expect(failure.error, isA<StateError>());
    expect(failure.onRetry, isNotNull);

    fail = false;
    failure.onRetry!();
    await pumpEventQueue();

    expect(shown.last, app);
    expect(prepareCalls, 2);
  });

  test('끝나지 않으면 지연 화면을 띄우고, 늦게라도 끝나면 앱으로 바꾼다', () async {
    final Completer<Widget> pending = Completer<Widget>();
    unawaited(guard(() => pending.future).start());
    await pastTimeout();

    final _Failure waiting = shown.single as _Failure;
    expect(waiting.error, isNull, reason: '시간 초과는 오류가 아니다');
    expect(waiting.onRetry, isNull, reason: '진행 중인 부팅과 겹치면 안 된다');

    pending.complete(app);
    await pumpEventQueue();
    expect(shown.last, app);
  });

  test('시간 초과 뒤에 실패하면 그때 재시도를 준다', () async {
    final Completer<Widget> pending = Completer<Widget>();
    unawaited(guard(() => pending.future).start());
    await pastTimeout();

    pending.completeError(StateError('늦은 실패'));
    await pumpEventQueue();

    final _Failure failure = shown.last as _Failure;
    expect(failure.error, isA<StateError>());
    expect(failure.onRetry, isNotNull);
  });

  test('진행 중에 다시 시작해도(재시도 연타) 준비는 한 번만 돈다', () async {
    final Completer<Widget> pending = Completer<Widget>();
    final BootGuard bootGuard = guard(() => pending.future);

    unawaited(bootGuard.start());
    unawaited(bootGuard.start());
    pending.complete(app);
    await pumpEventQueue();

    expect(prepareCalls, 1);
    expect(shown, [app]);
  });
}
