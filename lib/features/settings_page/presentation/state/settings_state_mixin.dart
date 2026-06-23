import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/google_drive/application/google_drive_providers.dart';

import '../../application/datasource_provider.dart';
import '../../application/settings_providers.dart';

mixin class SettingsState {
  AsyncValue<String> appVersionState(WidgetRef ref) =>
      ref.read(getAppVersionProvider);

  AsyncValue<String> cacheSizeState(WidgetRef ref) =>
      ref.watch(sizeCacheDirProvider);

  bool showNickImageState(WidgetRef ref) => ref.watch(showNickImageProvider);

  SyncStatus syncStatusState(WidgetRef ref) =>
      ref.watch(googleDriveSyncProvider);

  bool isSyncingState(WidgetRef ref) =>
      ref.watch(googleDriveSyncProvider.select((s) => s == SyncStatus.syncing));
}
