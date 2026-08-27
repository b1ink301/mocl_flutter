import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/google_drive/application/google_drive_providers.dart';

import '../../application/datasource_provider.dart';
import '../../application/settings_providers.dart';

mixin class SettingsState() {
  AsyncValue<String> appVersionState(WidgetRef ref) =>
      ref.read(getAppVersionProvider);

  AsyncValue<String> cacheSizeState(WidgetRef ref) =>
      ref.watch(sizeCacheDirProvider);

  bool showNickImageState(WidgetRef ref) => ref.watch(showNickImageProvider);

  ThemeMode themeModeState(WidgetRef ref) => ref.watch(themeModeProvider);

  double fontSizeDeltaState(WidgetRef ref) => ref.watch(fontSizeDeltaProvider);

  /// 폰트 크기 델타가 반영된 앱 텍스트 스타일. 설정 화면 텍스트도 이 스타일을
  /// 사용해 글자 크기 변경에 함께 반응하도록 한다.
  AppTextStyles appTextStylesState(WidgetRef ref) =>
      ref.watch(appTextStylesFontSizeProvider);

  SyncStatus syncStatusState(WidgetRef ref) =>
      ref.watch(googleDriveSyncProvider);

  bool isSyncingState(WidgetRef ref) =>
      ref.watch(googleDriveSyncProvider.select((s) => s == SyncStatus.syncing));
}
