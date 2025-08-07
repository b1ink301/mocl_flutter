import 'dart:io';

import 'package:mocl_flutter/features/google_drive/data/datasources/google_drive_remote_data_source.dart';
import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class GoogleDriveRepositoryImpl implements GoogleDriveRepository {
  final GoogleDriveRemoteDataSource remoteDataSource;

  const GoogleDriveRepositoryImpl(this.remoteDataSource);

  @override
  Future<bool> backupDatabase() => remoteDataSource.uploadDb();

  @override
  Future<bool> restoreDatabase() => remoteDataSource.downloadDb();

  @override
  Future<void> signIn() => remoteDataSource.signIn();

  @override
  Future<DateTime?> getRemoteFileModifiedTime() async {
    final metadata = await remoteDataSource.getRemoteDbFileMetadata();
    return metadata?.modifiedTime;
  }

  @override
  Future<DateTime?> getLocalFileModifiedTime() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFile = File(path.join(dbDirectory.path, 'mocl-sembast.db'));
    if (await dbFile.exists()) {
      return await dbFile.lastModified();
    }
    return null;
  }
}
