import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

// GoogleAuthClient for authenticated requests
class GoogleAuthClient(final Map<String, String> _headers)
    extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class GoogleDriveRemoteDataSource() {
  static const String _dbFileName = 'mocl-sembast.db';
  static const String _appDataFolderName = 'MoclFlutterApp';

  // Google Cloud Console OAuth 클라이언트 (프로젝트 275270612301)
  // 웹 클라이언트(type 3): Android 에서 serverClientId 로 필수.
  static const String _webClientId =
      '275270612301-3a26lcggh55ni94gq60eqvc0jfitsg91.apps.googleusercontent.com';
  // Android OAuth 클라이언트(type 1): iOS/macOS 등 비안드로이드에서 clientId 로 사용.
  static const String _clientId =
      '275270612301-3jajhso3ce2c9ungjkgifi3em060uupa.apps.googleusercontent.com';

  GoogleSignInAccount? _currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final GoogleSignIn signIn = GoogleSignIn.instance;

    // Android 는 clientId 를 네이티브(google-services.json)에서 해석하므로 넘기지 않고,
    // 대신 serverClientId(웹 클라이언트)가 v7 부터 필수다.
    final bool isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    await signIn.initialize(
      clientId: isAndroid ? null : _clientId,
      serverClientId: _webClientId,
    );

    // 1) 이전에 로그인한 적이 있으면 조용히 복원 시도
    _currentUser = await signIn.attemptLightweightAuthentication();

    // 2) 조용한 로그인이 실패하면 대화형 로그인으로 폴백
    if (_currentUser == null && signIn.supportsAuthenticate()) {
      try {
        _currentUser = await signIn.authenticate();
      } catch (e) {
        MoclLogger.log('Interactive sign-in failed: $e');
      }
    }

    return _currentUser;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    _currentUser = null;
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    final googleUser = _currentUser ?? await signIn();
    if (googleUser == null) {
      MoclLogger.log("Google Sign-In failed.");
      return null;
    }

    const List<String> scopes = [drive.DriveApi.driveFileScope];

    // v7 부터 인증(누구인지)과 인가(어떤 권한인지)가 분리됐다.
    // 이미 인가됐으면 헤더를 즉시 얻고, 아니면 대화형 스코프 인가를 요청한다.
    Map<String, String>? headers = await googleUser.authorizationClient
        .authorizationHeaders(scopes);
    if (headers == null) {
      try {
        final authorization = await googleUser.authorizationClient
            .authorizeScopes(scopes);
        headers = {'Authorization': 'Bearer ${authorization.accessToken}'};
      } catch (e) {
        MoclLogger.log('Scope authorization failed: $e');
        return null;
      }
    }

    final client = GoogleAuthClient(headers);

    return drive.DriveApi(client);
  }

  Future<File?> _getDbFile() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFile = File(path.join(dbDirectory.path, _dbFileName));
    if (await dbFile.exists()) {
      return dbFile;
    }
    return null;
  }

  Future<String?> _getOrCreateAppFolder(drive.DriveApi driveApi) async {
    try {
      final response = await driveApi.files.list(
        q: "mimeType='application/vnd.google-apps.folder' and name='$_appDataFolderName' and trashed=false",
        spaces: 'drive',
      );

      if (response.files != null && response.files!.isNotEmpty) {
        return response.files!.first.id;
      } else {
        final folder = drive.File()
          ..name = _appDataFolderName
          ..mimeType = 'application/vnd.google-apps.folder';
        final createdFolder = await driveApi.files.create(folder);
        return createdFolder.id;
      }
    } catch (e) {
      MoclLogger.log('Error creating/finding app folder: $e');
      return null;
    }
  }

  Future<drive.File?> getRemoteDbFileMetadata() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return null;

    final appFolderId = await _getOrCreateAppFolder(driveApi);
    if (appFolderId == null) return null;

    final response = await driveApi.files.list(
      q: "name='$_dbFileName' and '$appFolderId' in parents and trashed=false",
      spaces: 'drive',
      $fields: 'files(id, name, modifiedTime)',
    );

    if (response.files != null && response.files!.isNotEmpty) {
      return response.files!.first;
    }
    return null;
  }

  Future<bool> uploadDb() async {
    final driveApi = await _getDriveApi();
    final dbFile = await _getDbFile();

    if (driveApi == null || dbFile == null) {
      MoclLogger.log("Drive API or DB file not available.");
      return false;
    }

    try {
      final appFolderId = await _getOrCreateAppFolder(driveApi);
      if (appFolderId == null) {
        MoclLogger.log("Could not get or create app folder.");
        return false;
      }

      final listResponse = await driveApi.files.list(
        q: "name='$_dbFileName' and '$appFolderId' in parents and trashed=false",
        spaces: 'drive',
      );

      final driveFile = drive.File()..name = _dbFileName;
      final media = drive.Media(dbFile.openRead(), await dbFile.length());

      if (listResponse.files != null && listResponse.files!.isNotEmpty) {
        final fileId = listResponse.files!.first.id!;
        await driveApi.files.update(driveFile, fileId, uploadMedia: media);
        MoclLogger.log("Database updated successfully.");
      } else {
        driveFile.parents = [appFolderId];
        await driveApi.files.create(driveFile, uploadMedia: media);
        MoclLogger.log("Database uploaded successfully.");
      }
      return true;
    } catch (e) {
      MoclLogger.log('Error uploading DB: $e');
      return false;
    }
  }

  /// 원격 DB 를 임시 파일(`.tmp`)로 내려받는다.
  /// 성공 시 임시 파일 경로, 실패 시 null 을 반환한다.
  /// 실제 DB 파일은 건드리지 않으므로 다운로드가 중간에 끊겨도 기존 DB 가 안전하다.
  Future<String?> downloadDbToTemp() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      MoclLogger.log("Drive API not available.");
      return null;
    }

    try {
      final appFolderId = await _getOrCreateAppFolder(driveApi);
      if (appFolderId == null) {
        MoclLogger.log("Could not get or create app folder.");
        return null;
      }

      final listResponse = await driveApi.files.list(
        q: "name='$_dbFileName' and '$appFolderId' in parents and trashed=false",
        spaces: 'drive',
      );

      if (listResponse.files == null || listResponse.files!.isEmpty) {
        MoclLogger.log("No database file found on Google Drive.");
        return null;
      }

      final fileId = listResponse.files!.first.id!;
      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final dbDirectory = await getApplicationDocumentsDirectory();
      final tmpFile = File(path.join(dbDirectory.path, '$_dbFileName.tmp'));

      final fileStream = tmpFile.openWrite();
      await media.stream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      MoclLogger.log("Database downloaded to temp file successfully.");
      return tmpFile.path;
    } catch (e) {
      MoclLogger.log('Error downloading DB: $e');
      return null;
    }
  }

  /// 내려받은 임시 파일을 실제 DB 파일로 원자적으로 교체(rename)한다.
  /// 호출 전 반드시 [LocalDatabase] 를 close 해야 파일 핸들 충돌이 없다.
  Future<bool> applyDownloadedDb(String tmpPath) async {
    try {
      final dbDirectory = await getApplicationDocumentsDirectory();
      final dbPath = path.join(dbDirectory.path, _dbFileName);
      await File(tmpPath).rename(dbPath);
      MoclLogger.log("Downloaded DB applied successfully.");
      return true;
    } catch (e) {
      MoclLogger.log('Error applying downloaded DB: $e');
      return false;
    }
  }
}
