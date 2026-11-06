import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../domain/app_update_status.dart';
import '../state/app_update_event_mixin.dart';
import '../state/app_update_state_mixin.dart';

/// 앱을 켤 때 스토어 버전을 확인하고 업데이트를 안내한다.
///
/// `MaterialApp.router` 의 builder 에서 감싼다. 라우터 위라서 다이얼로그는
/// [navigatorKey] 의 context 로 띄운다.
/// - Android: Play 인앱 업데이트(유연). 다 받으면 재시작 스낵바를 띄운다.
/// - iOS: 새 버전이면 App Store 로 안내하는 다이얼로그를 띄운다.
class const AppUpdateGate({
  super.key,
  required final GlobalKey<NavigatorState> navigatorKey,
  required final Widget child,
}) extends HookConsumerWidget with AppUpdateState, AppUpdateEvent {
  /// 첫 화면이 뜨고 광고 동의 · 글꼴 워밍업 같은 시작 작업이 지나간 뒤 확인한다.
  static const Duration _launchDelay = Duration(seconds: 3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Timer? timer;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        timer = Timer(_launchDelay, () async {
          final bool prompt = await handleCheckUpdateOnLaunch(ref);
          if (prompt) _showUpdateDialog(ref);
        });
      });
      return () => timer?.cancel();
    }, const []);

    listenAppUpdatePhase(ref, (previous, next) {
      if (next == AppUpdatePhase.downloaded &&
          previous != AppUpdatePhase.downloaded) {
        _showRestartSnackBar(context, ref);
      }
    });

    return child;
  }

  void _showRestartSnackBar(BuildContext context, WidgetRef ref) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('업데이트를 받았습니다. 다시 시작하면 적용됩니다.'),
          behavior: SnackBarBehavior.floating,
          // 하단 탭바에 가리지 않도록 살짝 띄운다.
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          duration: const Duration(seconds: 30),
          action: SnackBarAction(
            label: '다시 시작',
            onPressed: () => handleInstallUpdate(ref),
          ),
        ),
      );
  }

  void _showUpdateDialog(WidgetRef ref) {
    final BuildContext? context = navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    final String? version = appUpdateStateOf(ref).storeVersion;

    unawaited(
      showAdaptiveDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog.adaptive(
          title: const Text('업데이트 안내'),
          content: Text(
            version == null
                ? '새 버전이 나왔습니다. 지금 업데이트할까요?'
                : '새 버전($version)이 나왔습니다. 지금 업데이트할까요?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('나중에'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                handleInstallUpdate(ref);
              },
              child: const Text('업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}
