import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

@lazySingleton
class ApiClient {
  final dio = Dio();
  final cookieJar = CookieJar();

  static const userAgentMobile =
      'Mozilla/5.0 (Linux; Android 14; Pixel 8 Build/AP2A.240905.003; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/130.0.6723.58 Mobile Safari/537.36 Yappli/1673b203.20240919 (Linux; Android 14; Google Build/Pixel 8)';
  static const userAgentPc =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';

  @PostConstruct()
  void init() {
    dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () =>
            HttpClient()..badCertificateCallback = (_, __, ___) => true);
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
    final headers = {
      'User-Agent': item.siteType == SiteType.meeco
          ? ApiClient.userAgentMobile
          : ApiClient.userAgentPc
    };

    try {
      final response = await get(url, headers: headers);
      log('getList $url, $headers response = ${response.statusCode}');
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
    final headers = {
      'User-Agent': parser.siteType == SiteType.meeco
          ? ApiClient.userAgentMobile
          : ApiClient.userAgentPc
    };
    try {
      final response = await get(url, headers: headers);
      log('getDetail $url, $headers response = ${response.statusCode}');
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
