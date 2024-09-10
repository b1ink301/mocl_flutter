import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiClient {
  final dio = Dio();
  final cookieJar = CookieJar();

  static const USER_AGETNT =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';

  @PostConstruct()
  void init() {
    dio.interceptors.add(CookieManager(cookieJar));
  }

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
    Future<Map<int, bool>> Function(SiteType, List<int>) isReads,
  ) async {
    final params = item.siteType == SiteType.clien
        ? '&od=T31&category=0&po=$page'
        : 'page=$page';
    final url = '${item.url}?$params';
    final headers = {'User-Agent': ApiClient.USER_AGETNT};

    try {
      final response = await get(url, headers: headers);
      log('getList getList = $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.list(
              response,
              lastId,
              item.text,
              isReads,
            )
          : ResultFailure(
              failure: GetListFailure(
                  message: 'response.statusCode = ${response.statusCode}'),
            );
    } on DioException catch (e) {
      final message = e.message ?? 'Unknown Error';
      log('getList = $url message = $message');
      return ResultFailure(failure: GetListFailure(message: message));
    }
  }

  Future<Result> getDetail(
    ListItem item,
    BaseParser parser,
  ) async {
    final url = item.url;
    final headers = {'User-Agent': ApiClient.USER_AGETNT};
    try {
      final response = await get(url, headers: headers);
      log('getDetail url=$url, response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.detail(response)
          : ResultFailure(
              failure: GetDetailFailure(
                  message: 'response.statusCode = ${response.statusCode}'),
            );
    } on DioException catch (e) {
      final message = e.message ?? 'Unknown Error';
      log('getDetail = $url message = $message');
      return ResultFailure(failure: GetDetailFailure(message: message));
    }
  }
}
