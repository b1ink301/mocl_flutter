import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class RestoreDatabaseUseCase {
  final GoogleDriveRepository repository;

  RestoreDatabaseUseCase(this.repository);

  Future<bool> call() {
    return repository.restoreDatabase();
  }
}
