import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class BackupDatabaseUseCase {
  final GoogleDriveRepository repository;

  const BackupDatabaseUseCase(this.repository);

  Future<bool> call() => repository.backupDatabase();
}
