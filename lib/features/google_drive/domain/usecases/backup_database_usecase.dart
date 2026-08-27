import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class const BackupDatabaseUseCase(final GoogleDriveRepository repository) {
  Future<bool> call() => repository.backupDatabase();
}
