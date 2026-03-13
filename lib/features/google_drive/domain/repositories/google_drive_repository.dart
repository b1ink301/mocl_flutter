abstract class GoogleDriveRepository {
  Future<void> signIn();
  Future<bool> backupDatabase();
  Future<bool> restoreDatabase();
  Future<DateTime?> getRemoteFileModifiedTime();
  Future<DateTime?> getLocalFileModifiedTime();
}
