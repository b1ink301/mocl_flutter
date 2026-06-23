import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/google_drive/application/google_drive_providers.dart';

import '../../application/settings_providers.dart';

mixin class SettingsEvent {
  void handleClearCache(WidgetRef ref) =>
      ref.read(sizeCacheDirProvider.notifier).clear();

  void handleToggleNickImage(WidgetRef ref) =>
      ref.read(showNickImageProvider.notifier).toggle();

  void handleBackup(WidgetRef ref) =>
      ref.read(googleDriveSyncProvider.notifier).backup();

  void handleRestore(WidgetRef ref) =>
      ref.read(googleDriveSyncProvider.notifier).restore();

  void listenSyncStatus(WidgetRef ref) {
    ref.listen<SyncStatus>(googleDriveSyncProvider, (previous, next) {});
  }
}
