import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_update_providers.dart';
import '../../domain/app_update_status.dart';

mixin class AppUpdateState() {
  AppUpdateStatus appUpdateState(WidgetRef ref) => ref.watch(appUpdateProvider);

  /// 콜백 안에서 지금 값만 볼 때. (build 밖이라 watch 를 쓸 수 없다)
  AppUpdateStatus appUpdateStateOf(WidgetRef ref) =>
      ref.read(appUpdateProvider);

  /// 업데이트 단계가 바뀔 때 알림을 받는다(다운로드 완료 스낵바 등).
  void listenAppUpdatePhase(
    WidgetRef ref,
    void Function(AppUpdatePhase? previous, AppUpdatePhase next) listener,
  ) => ref.listen<AppUpdatePhase>(
    appUpdateProvider.select((s) => s.phase),
    listener,
  );
}
