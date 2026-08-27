import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

class FileDownloadService._() {
  /// base64 데이터를 파일로 저장
  static Future<Map<String, dynamic>> saveFile({
    required String base64Data,
    required String fileName,
    String? mimeType,
  }) async {
    try {
      final bytes = base64Decode(base64Data);
      return await _saveWithPicker(bytes, fileName);
    } catch (e) {
      MoclLogger.logWithTag('FileDownload', 'error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> _saveWithPicker(
    Uint8List bytes,
    String fileName,
  ) async {
    final outputPath = await FilePicker.saveFile(
      dialogTitle: '파일 저장',
      fileName: fileName,
      bytes: bytes,
    );

    if (outputPath == null) {
      return {'success': false, 'error': 'cancelled'};
    }

    if (Platform.isIOS) {
      final file = File.fromUri(outputPath);
      if (!await file.exists() || await file.length() == 0) {
        await file.writeAsBytes(bytes);
      }
    }

    return {'success': true, 'path': outputPath};
  }

  /// URL에서 직접 다운로드
  static Future<Map<String, dynamic>> downloadFromUrl({
    required String url,
    required String fileName,
    String? mimeType,
  }) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      final bytes = await consolidateHttpClientResponseBytes(response);
      httpClient.close();

      return await _saveWithPicker(bytes, fileName);
    } catch (e) {
      MoclLogger.logWithTag('FileDownload', 'downloadFromUrl error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }
}
