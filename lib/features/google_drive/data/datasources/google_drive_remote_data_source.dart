import 'dart:async';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

// GoogleAuthClient for authenticated requests
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class GoogleDriveRemoteDataSource {
  static const String _dbFileName = 'mocl-sembast.db';
  static const String _appDataFolderName = 'MoclFlutterApp';

  GoogleSignInAccount? _currentUser;

  Future<GoogleSignInAccount?> signIn() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    final GoogleSignIn signIn = GoogleSignIn.instance;

    await signIn
        .initialize(clientId: '275270612301-3jajhso3ce2c9ungjkgifi3em060uupa', serverClientId: null);

      // _googleSignIn.authenticationEvents
      //     .listen(_handleAuthenticationEvent)
      //     .onError(_handleAuthenticationError);

    _currentUser = await signIn.attemptLightweightAuthentication();
    // _currentUser = await signIn.authenticate();
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

    final headers = await googleUser.authorizationClient.authorizationHeaders([
      drive.DriveApi.driveFileScope,
    ]);
    if (headers == null) {
      return null;
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

  Future<bool> downloadDb() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) {
      MoclLogger.log("Drive API not available.");
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

      if (listResponse.files == null || listResponse.files!.isEmpty) {
        MoclLogger.log("No database file found on Google Drive.");
        return false;
      }

      final fileId = listResponse.files!.first.id!;
      final media =
          await driveApi.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final dbDirectory = await getApplicationDocumentsDirectory();
      final dbFile = File(path.join(dbDirectory.path, _dbFileName));

      final fileStream = dbFile.openWrite();
      await media.stream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      MoclLogger.log("Database downloaded successfully.");
      return true;
    } catch (e) {
      MoclLogger.log('Error downloading DB: $e');
      return false;
    }
  }
}
