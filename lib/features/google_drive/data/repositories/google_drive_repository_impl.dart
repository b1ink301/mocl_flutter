import 'package:mocl_flutter/features/google_drive/data/datasources/google_drive_remote_data_source.dart';
import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';

class GoogleDriveRepositoryImpl implements GoogleDriveRepository {
  final GoogleDriveRemoteDataSource remoteDataSource;

  const GoogleDriveRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> backupDatabase() => remoteDataSource.uploadDb();

  @override
  Future<bool> restoreDatabase() => remoteDataSource.downloadDb();

  @override
  Future<void> signIn() => remoteDataSource.signIn();
}
