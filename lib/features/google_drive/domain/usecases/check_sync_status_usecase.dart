import 'package:mocl_flutter/features/google_drive/domain/entities/sync_action.dart';
import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class CheckSyncStatusUseCase {
  final GoogleDriveRepository repository;

  CheckSyncStatusUseCase(this.repository);

  Future<SyncAction> call() async {
    await repository.signIn();
    final remoteTime = await repository.getRemoteFileModifiedTime();
    final localTime = await repository.getLocalFileModifiedTime();

    if (remoteTime == null) {
      if (localTime != null) {
        return SyncAction.initialBackup;
      }
      return SyncAction.idle;
    }

    if (localTime == null) {
      // This case is unlikely but possible if DB is created after check starts.
      // We can choose to restore or do nothing. Let's be safe and do nothing.
      return SyncAction.idle;
    }

    // Add a small buffer to avoid sync loops from minor time differences
    final timeDifference = remoteTime.difference(localTime);

    if (timeDifference.inSeconds > 60) {
      // Remote is significantly newer
      return SyncAction.promptRestore;
    } else if (timeDifference.inSeconds < -60) {
      // Local is significantly newer
      return SyncAction.autoBackup;
    }

    return SyncAction.idle;
  }
}
