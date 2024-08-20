import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/mocl_list_item.dart';
import '../../domain/entities/mocl_main_item.dart';
import '../../domain/entities/mocl_result.dart';
import '../../domain/entities/mocl_site_type.dart';
import 'parser/base_parser.dart';

class ApiClient {
  final dio = Dio();
  final cookieJar = CookieJar();

  static const USER_AGETNT =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';

  ApiClient._() {
    dio.interceptors.add(CookieManager(cookieJar));
  }

  static ApiClient getInstance() => ApiClient._();

  Future<Response> getUri(
    Uri uri, {
    Map<String, String>? headers,
  }) =>
      dio.getUri(
        uri,
        options: headers != null ? Options(headers: headers) : null,
      );

  Future<Response> get(
    String url, {
    Map<String, String>? headers,
  }) =>
      dio.get(
        url,
        options: headers != null ? Options(headers: headers) : null,
      );

  Future<Result> getList(
    MainItem item,
    int page,
    int lastId,
    BaseParser parser,
    Future<bool> Function(SiteType, int) isRead,
  ) async {
    final params = item.siteType == SiteType.clien
        ? '&od=T31&category=0&po=$page'
        : 'page=$page';
    final url = '${item.url}?$params';
    final headers = {'User-Agent': ApiClient.USER_AGETNT};
    final response = await get(url, headers: headers);

    log('getList getList = $url response = ${response.statusCode}');

    return response.statusCode == 200
        ? parser.list(
            response,
            lastId,
            item.text,
            isRead,
          )
        : ResultFailure(failure: GetListFailure());
  }

  Future<Result> getDetail(
    ListItem item,
    BaseParser parser,
  ) async {
    final headers = {'User-Agent': ApiClient.USER_AGETNT};
    final response = await get(item.url, headers: headers);
    log('getDetail url=${item.url}, response = ${response.statusCode}');
    return response.statusCode == 200
        ? parser.detail(response)
        : ResultFailure(failure: GetDetailFailure());
  }
}
