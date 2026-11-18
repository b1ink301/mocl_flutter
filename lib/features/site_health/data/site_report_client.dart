import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocl_shared/reports/site_report.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 서버 `POST /v1/reports` 로 신고를 보낸다. 서버 주소가 없는 빌드면 [available] 이 false.
///
/// 서버 쪽 실패(오프라인 · 5xx · 요청 제한)는 `MoclLogger.w` 로만 남긴다(Crashlytics 로 올리지 않음).
class SiteReportClient(final Dio _dio, final String _baseUrl) {
  bool get available => _baseUrl.isNotEmpty;

  /// 보냈으면 true.
  Future<bool> send(SiteReport report) async {
    if (!available) return false;
    try {
      await _dio.post<void>(
        '$_baseUrl/v1/reports',
        data: jsonEncode(report.toJson()),
        options: Options(contentType: 'application/json'),
      );
      return true;
    } on DioException catch (e) {
      MoclLogger.w(
        () => '[siteReport] 보내지 못함: ${e.type} ${e.response?.statusCode ?? ''}',
      );
      return false;
    }
  }
}
