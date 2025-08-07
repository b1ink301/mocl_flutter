import 'package:mocl_flutter/features/google_drive/domain/entities/sync_action.dart';
import 'package:mocl_flutter/features/google_drive/presentation/providers/google_drive_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_sync_provider.g.dart';

@riverpod
class AutoSyncNotifier extends _$AutoSyncNotifier {
  @override
  SyncAction build() => SyncAction.idle;

  Future<void> checkSyncStatus() async {
    final checkSyncStatusUseCase = ref.read(checkSyncStatusUseCaseProvider);
    final action = await checkSyncStatusUseCase();

    switch (action) {
      case SyncAction.initialBackup:
      case SyncAction.autoBackup:
        await ref
            .read(googleDriveSyncNotifierProvider.notifier)
            .backup(showToast: false);
        break;
      case SyncAction.promptRestore:
        state = SyncAction.promptRestore;
        break;
      case SyncAction.idle:
        break;
    }
  }

  void resetState() {
    state = SyncAction.idle;
  }
}
