abstract class GoogleDriveRepository() {
  Future<void> signIn();
  Future<bool> backupDatabase();

  /// 원격 DB 를 임시 파일로 내려받고 그 경로를 반환한다(실패 시 null).
  Future<String?> downloadDatabaseToTemp();

  /// 내려받은 임시 파일을 실제 DB 파일로 교체한다(호출 전 DB close 필요).
  Future<bool> applyDownloadedDatabase(String tmpPath);
  Future<DateTime?> getRemoteFileModifiedTime();
  Future<DateTime?> getLocalFileModifiedTime();
}
