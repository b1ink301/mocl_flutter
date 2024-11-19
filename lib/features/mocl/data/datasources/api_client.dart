import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart' as cookiejar;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as diocookie;
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  final cookieJar = cookiejar.CookieJar();

  static const userAgentMobile =
      'Mozilla/5.0 (Linux; Android 14; Pixel 8 Build/AP2A.240905.003; wv) '
      'AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/130.0.6723.58 Mobile '
      'Safari/537.36 Yappli/1673b203.20240919 (Linux; Android 14; Google Build/Pixel 8)';
  static const userAgentPc =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';

  @PostConstruct()
  void init() async {
    dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () =>
            HttpClient()..badCertificateCallback = (_, __, ___) => true);

    dio.interceptors.add(diocookie.CookieManager(cookieJar));
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
    ResponseType? responseType,
    String? contentType,
  }) =>
      dio.get(
        url,
        options: headers != null
            ? Options(
                headers: headers,
                responseType: responseType,
                contentType: contentType,
              )
            : null,
      );

  Future<Result> getList(
    MainItem item,
    int page,
    int lastId,
    BaseParser parser,
    Future<Map<int, bool>> Function(SiteType, List<int>) isReads,
  ) async {
    final String url;
    if (item.siteType == SiteType.clien) {
      url = '${item.url}?od=T31&category=0&po=$page';
    } else if (item.siteType == SiteType.naverCafe) {
      url = "https://apis.naver.com/cafe-web/cafe2/ArticleListV2dot1.json?"
          "search.clubid=${item.url}"
          "&search.queryType=lastArticle"
          "&search.perPage=50"
          "&ad=true"
          "&uuid=6dd62de1-7279-49f0-b009-6ccc554ac679"
          "&adUnit=MW_CAFE_ARTICLE_LIST_RS"
          "&search.page=$page";
    } else {
      url = '${item.url}?page=$page';
    }
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

  Future<InterceptorsWrapper> _buildInterceptorCookie(BaseParser parser) async {
    webview.CookieManager cookieManager = webview.CookieManager.instance();
    final uri = WebUri(parser.baseUrl);
    final cookies = await cookieManager.getCookies(url: uri);

    // Dio의 쿠키jar에 쿠키 추가
    final List<cookiejar.Cookie> dioCookies = cookies
        .map((cookie) => cookiejar.Cookie(cookie.name, cookie.value))
        .toList();

    final interceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Cookie'] = dioCookies
            .map((cookie) => '${cookie.name}=${cookie.value}')
            .join('; ');
        return handler.next(options);
      },
    );

    return interceptor;
  }

  Future<Result> getDetail(
    ListItem item,
    BaseParser parser,
  ) async {
    if (parser.siteType == SiteType.naverCafe) {
      final detailUrl =
          'https://apis.naver.com/cafe-web/cafe-articleapi/v2/cafes/${item.board}/articles/${item.id}';
      final commentUrl = '$detailUrl/comments';
      final headers = {
        'User-Agent': ApiClient.userAgentMobile,
      };

      final interceptor = await _buildInterceptorCookie(parser);
      dio.interceptors.add(interceptor);

      try {
        final commentFuture = get(
          commentUrl,
          headers: headers,
          responseType: ResponseType.json,
          // contentType: Headers.jsonContentType,
        );
        final detailFuture = get(
          detailUrl,
          headers: headers,
          responseType: ResponseType.json,
          // contentType: Headers.jsonContentType,
        );

        final responses = await Future.wait([detailFuture, commentFuture]);

        if (responses.first.statusCode == 200 &&
            responses.last.statusCode == 200) {
          var data = responses.map((response) => response.data).toList();
          var result = Response<List<dynamic>>(
              data: data, requestOptions: RequestOptions());
          return parser.detail(result);
        } else {
          return ResultFailure(
            failure: GetDetailFailure(message: 'response.statusCode = not 200'),
          );
        }
      } on DioException catch (e) {
        final message = e.message ?? 'Unknown Error';
        log('getDetail = $detailUrl message = $message');
        ResultFailure(failure: GetDetailFailure(message: message));
      } finally {
        dio.interceptors.remove(interceptor);
      }

      return ResultFailure(failure: GetDetailFailure(message: 'message'));
    } else {
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

  Future<Result> getMain(
    BaseParser parser,
  ) async {
    if (parser.siteType != SiteType.naverCafe) {
      throw FormatException('Not support site');
    }

    final interceptor = await _buildInterceptorCookie(parser);
    dio.interceptors.add(interceptor);

    final url =
        'https://apis.naver.com/cafe-home-web/cafe-home/v1/cafes/join?perPage=100';
    final headers = {'User-Agent': ApiClient.userAgentMobile};

    try {
      final response = await get(url, headers: headers);
      log('getMain $url, $headers response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.main(response)
          : ResultFailure(
              failure: GetMainFailure(
                  message: 'response.statusCode = ${response.statusCode}'),
            );
    } on DioException catch (e) {
      final message = e.message ?? 'Unknown Error';
      log('getMain = $url message = $message');
      return ResultFailure(failure: GetMainFailure(message: message));
    } on FormatException catch (e) {
      final message = e.message;
      log('getMain = $url message = $message');
      return ResultFailure(failure: GetMainFailure(message: message));
    } finally {
      dio.interceptors.remove(interceptor);
    }
  }
}
