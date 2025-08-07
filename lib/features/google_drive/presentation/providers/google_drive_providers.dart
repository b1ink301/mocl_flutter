import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mocl_flutter/features/google_drive/data/datasources/google_drive_remote_data_source.dart';
import 'package:mocl_flutter/features/google_drive/data/repositories/google_drive_repository_impl.dart';
import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';
import 'package:mocl_flutter/features/google_drive/domain/usecases/backup_database_usecase.dart';
import 'package:mocl_flutter/features/google_drive/domain/usecases/restore_database_usecase.dart';
import 'package:mocl_flutter/features/google_drive/domain/usecases/sign_in_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_drive_providers.g.dart';

@riverpod
GoogleDriveRemoteDataSource googleDriveRemoteDataSource(Ref ref) =>
    GoogleDriveRemoteDataSource();

@riverpod
GoogleDriveRepository googleDriveRepository(Ref ref) =>
    GoogleDriveRepositoryImpl(ref.watch(googleDriveRemoteDataSourceProvider));

@riverpod
SignInUseCase signInUseCase(Ref ref) =>
    SignInUseCase(ref.watch(googleDriveRepositoryProvider));

@riverpod
BackupDatabaseUseCase backupDatabaseUseCase(Ref ref) =>
    BackupDatabaseUseCase(ref.watch(googleDriveRepositoryProvider));

@riverpod
RestoreDatabaseUseCase restoreDatabaseUseCase(Ref ref) =>
    RestoreDatabaseUseCase(ref.watch(googleDriveRepositoryProvider));

enum SyncStatus { idle, syncing, success, error }

@riverpod
class GoogleDriveSyncNotifier extends _$GoogleDriveSyncNotifier {
  @override
  SyncStatus build() => SyncStatus.idle;

  Future<void> backup() async {
    state = SyncStatus.syncing;
    await ref.read(signInUseCaseProvider).call();
    final success = await ref.read(backupDatabaseUseCaseProvider).call();
    state = success ? SyncStatus.success : SyncStatus.error;
    _showResultToast(success, isBackup: true);
    if (state != SyncStatus.syncing) {
      state = SyncStatus.idle;
    }
  }

  Future<void> restore() async {
    state = SyncStatus.syncing;
    await ref.read(signInUseCaseProvider).call();
    final success = await ref.read(restoreDatabaseUseCaseProvider).call();
    state = success ? SyncStatus.success : SyncStatus.error;
    _showResultToast(success, isBackup: false);
    if (state != SyncStatus.syncing) {
      state = SyncStatus.idle;
    }
  }

  void _showResultToast(bool success, {required bool isBackup}) {
    final action = isBackup ? '백업' : '복원';
    String message;
    if (success) {
      message = isBackup ? '$action 성공' : '$action 성공. 앱을 재시작하세요.';
    } else {
      message = '$action 실패';
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }
}
