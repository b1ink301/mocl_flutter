import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class RestoreDatabaseUseCase {
  final GoogleDriveRepository repository;

  RestoreDatabaseUseCase(this.repository);

  /// 원격 DB 를 임시 파일로 내려받고 그 경로를 반환한다(실패 시 null).
  /// 실제 파일 교체와 DB 재오픈은 호출부(GoogleDriveSyncNotifier)에서 수행한다.
  Future<String?> call() {
    return repository.downloadDatabaseToTemp();
  }
}
