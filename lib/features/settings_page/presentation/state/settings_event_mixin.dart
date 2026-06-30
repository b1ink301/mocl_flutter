import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/google_drive/application/google_drive_providers.dart';

import '../../application/settings_providers.dart';

mixin class SettingsEvent {
  void handleClearCache(WidgetRef ref) =>
      ref.read(sizeCacheDirProvider.notifier).clear();

  void handleToggleNickImage(WidgetRef ref) =>
      ref.read(showNickImageProvider.notifier).toggle();

  void handleChangeThemeMode(WidgetRef ref, ThemeMode mode) =>
      ref.read(themeModeProvider.notifier).change(mode);

  void handleIncreaseFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).adjustFontSize(1);

  void handleDecreaseFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).adjustFontSize(-1);

  void handleResetFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).resetFontSize();

  void handleBackup(WidgetRef ref) =>
      ref.read(googleDriveSyncProvider.notifier).backup();

  void handleRestore(WidgetRef ref) =>
      ref.read(googleDriveSyncProvider.notifier).restore();

  void listenSyncStatus(WidgetRef ref) {
    ref.listen<SyncStatus>(googleDriveSyncProvider, (previous, next) {});
  }
}
