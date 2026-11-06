import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

/// 이슈 레이더 목록을 서버(`GET /v1/issues`)에서 받는다.
///
/// 같은 내용이면 서버가 304 를 주므로 마지막 응답을 들고 있다가 그대로 돌려준다.
final class IssueRadarApi(final Dio _dio, final String _baseUrl) {
  String? _etag;
  IssueFeed? _last;

  /// 받지 못하면 [DioException] · [FormatException] 을 던진다(화면이 오류로 보여 준다).
  Future<IssueFeed> fetch() async {
    final Response<String> response = await _dio.get<String>(
      '$_baseUrl/v1/issues',
      options: Options(
        responseType: ResponseType.plain,
        headers: {if (_last != null) 'If-None-Match': ?_etag},
        validateStatus: (int? s) => s == 200 || s == 304,
      ),
    );
    if (response.statusCode == 304 && _last != null) return _last!;
    final IssueFeed feed = IssueFeed.fromJson(jsonDecode(response.data ?? ''));
    _etag = response.headers.value('etag');
    _last = feed;
    return feed;
  }
}
