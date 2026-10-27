import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_update_providers.dart';
import '../../domain/app_update_status.dart';

mixin class AppUpdateEvent() {
  /// 앱을 켤 때의 확인. iOS 에서 안내 다이얼로그를 띄워야 하면 true.
  Future<bool> handleCheckUpdateOnLaunch(WidgetRef ref) =>
      ref.read(appUpdateProvider.notifier).checkOnLaunch();

  /// 설정에서 직접 확인. 확인이 끝난 뒤의 단계를 돌려준다.
  Future<AppUpdatePhase> handleCheckUpdate(WidgetRef ref) =>
      ref.read(appUpdateProvider.notifier).checkManually();

  /// Android 는 받은 업데이트를 설치(재시작)하고, iOS 는 App Store 로 보낸다.
  Future<void> handleInstallUpdate(WidgetRef ref) =>
      ref.read(appUpdateProvider.notifier).install();
}
