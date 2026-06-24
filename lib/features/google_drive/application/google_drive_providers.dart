import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/google_drive/data/datasources/google_drive_remote_data_source.dart';
import 'package:mocl_flutter/features/main_page/application/main_providers.dart';
import 'package:mocl_flutter/features/google_drive/data/repositories/google_drive_repository_impl.dart';
import 'package:mocl_flutter/features/google_drive/domain/repositories/google_drive_repository.dart';
import 'package:mocl_flutter/features/google_drive/domain/usecases/backup_database_usecase.dart';
import 'package:mocl_flutter/features/google_drive/domain/usecases/check_sync_status_usecase.dart';
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

@riverpod
CheckSyncStatusUseCase checkSyncStatusUseCase(Ref ref) =>
    CheckSyncStatusUseCase(ref.watch(googleDriveRepositoryProvider));

enum SyncStatus { idle, syncing, success, error }

@riverpod
class GoogleDriveSyncNotifier extends _$GoogleDriveSyncNotifier {
  @override
  SyncStatus build() => SyncStatus.idle;

  Future<void> backup({bool showToast = true}) async {
    state = SyncStatus.syncing;
    final success = await ref.read(backupDatabaseUseCaseProvider).call();
    state = success ? SyncStatus.success : SyncStatus.error;
    if (showToast) {
      _showResultToast(success, isBackup: true);
    }
    if (state != SyncStatus.syncing) {
      state = SyncStatus.idle;
    }
  }

  Future<void> restore({bool showToast = true}) async {
    state = SyncStatus.syncing;

    // 1) 원격 DB 를 임시 파일로 내려받는다. 이 동안 기존 DB 는 그대로 사용 가능.
    final tmpPath = await ref.read(restoreDatabaseUseCaseProvider).call();

    bool success = false;
    if (tmpPath != null) {
      // 2) DB close → 파일 원자적 교체 → reopen. 이 짧은 구간만 DB 가 닫힌다.
      final localDb = ref.read(localDatabaseProvider);
      await localDb.close();
      success = await ref
          .read(googleDriveRepositoryProvider)
          .applyDownloadedDatabase(tmpPath);
      await localDb.reopen();

      // 3) 교체 성공 시 DB 를 읽는 화면을 invalidate 해 즉시 새 데이터로 갱신한다.
      //    (재시작 불필요. 상세 페이지의 읽음 표시 등은 진입 시 on-demand 로 다시 읽힌다.)
      if (success) {
        ref.invalidate(mainItemsProvider);
      }
    }

    state = success ? SyncStatus.success : SyncStatus.error;
    if (showToast) {
      _showResultToast(success, isBackup: false);
    }
    if (state != SyncStatus.syncing) {
      state = SyncStatus.idle;
    }
  }

  void _showResultToast(bool success, {required bool isBackup}) {
    final action = isBackup ? '백업' : '복원';
    String message;
    if (success) {
      message = '$action 성공';
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
