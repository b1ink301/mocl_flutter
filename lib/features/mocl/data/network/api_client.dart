import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart' as cookiejar;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as diocookie;
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

const String _userAgentMobile =
    'Mozilla/5.0 (Linux; Android 14; Pixel 8 Build/AP2A.240905.003; wv) '
    'AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/130.0.6723.58 Mobile '
    'Safari/537.36 Yappli/1673b203.20240919 (Linux; Android 14; Google Build/Pixel 8)';
const String _userAgentPc =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';

class ApiClient {
  final Dio _dio;

  const ApiClient(this._dio);

  void init(cookiejar.CookieJar cookieJar) {
    _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () =>
            HttpClient()..badCertificateCallback = (_, __, ___) => true);

    _dio.interceptors.add(diocookie.CookieManager(cookieJar));
  }

  Future<Response> getUri(
    Uri uri, {
    Map<String, String>? headers,
  }) =>
      _dio.getUri(
        uri,
        options: headers != null ? Options(headers: headers) : null,
      );

  Future<Response> get(
    String url, {
    Map<String, String>? headers,
    ResponseType? responseType,
    String? contentType,
  }) =>
      _dio.get(
        url,
        options: headers != null
            ? Options(
                headers: headers,
                responseType: responseType,
                contentType: contentType,
              )
            : null,
      );

  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    final String url =
        parser.urlByList(item.url, item.board, page, sortType, lastId);
    final String host = WebUri(parser.baseUrl).host;
    final Map<String, String> headers = {
      'Host': host,
      'Cache-control': 'no-cache',
      'Pragma': 'no-cache',
      'User-Agent':
          item.siteType == SiteType.meeco ? _userAgentMobile : _userAgentPc
    };

    final InterceptorsWrapper interceptor =
        await _buildInterceptorCookie(item.url);
    _dio.interceptors.add(interceptor);

    try {
      final Response response = await get(url, headers: headers);
      log('[getList] $url, $headers response = ${response.statusCode}');

      return response.statusCode == 200
          ? parser.list(
              response,
              lastId,
              item.text,
              isReads,
            )
          : Left(
              GetListFailure(
                  message: 'response.statusCode = ${response.statusCode}'),
            );
    } on DioException catch (e) {
      final String message = e.message ?? 'Unknown Error';
      log('[getList] = $url message = $message');
      if (e.response?.statusCode == 400) {
        await webview.CookieManager.instance().removeSessionCookies();
      }

      return Left(GetListFailure(message: message));
    } finally {
      _dio.interceptors.remove(interceptor);
    }
  }

  Future<Either<Failure, List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    final String url =
        parser.urlBySearchList(item.url, item.board, page, keyword, lastId);
    final host = WebUri(parser.baseUrl).host;
    final Map<String, String> headers = {
      'Host': host,
      'Referer': item.url,
      'User-Agent':
          item.siteType == SiteType.meeco ? _userAgentMobile : _userAgentPc,
    };

    log('getSearchList $url, $headers');

    final InterceptorsWrapper interceptor =
        await _buildInterceptorCookie(item.url);
    _dio.interceptors.add(interceptor);

    try {
      final Response response = await get(url, headers: headers);
      log('getSearchList $url, $headers response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.list(
              response,
              lastId,
              item.text,
              isReads,
            )
          : Left(
              GetListFailure(
                  message: 'response.statusCode = ${response.statusCode}'),
            );
    } on DioException catch (e) {
      final String message = e.message ?? 'Unknown Error';
      if (e.response?.statusCode == 400) {
        await webview.CookieManager.instance().removeSessionCookies();
      }
      log('getSearchList = $url message = $message');
      return Left(GetListFailure(message: message));
    } finally {
      _dio.interceptors.remove(interceptor);
    }
  }

  Future<InterceptorsWrapper> _buildInterceptorCookie(String baseUrl) async {
    final webview.CookieManager cookieManager =
        webview.CookieManager.instance();
    final webview.WebUri uri = WebUri(baseUrl);

    final List<webview.Cookie> cookies =
        await cookieManager.getCookies(url: uri);

    final List<cookiejar.Cookie> dioCookies = cookies
        .map((cookie) => cookiejar.Cookie(cookie.name, cookie.value))
        .toList();

    final InterceptorsWrapper interceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Cookie'] = dioCookies
            .map((cookie) => '${cookie.name}=${cookie.value}')
            .join('; ');

        log('[_buildInterceptorCookie] ${options.headers['Cookie']}');
        return handler.next(options);
      },
    );
    return interceptor;
  }

  Future<Either<Failure, Details>> getDetail(
    ListItem item,
    BaseParser parser,
  ) async {
    final String url = parser.urlByDetail(item.url, item.board, item.id);
    if (parser.siteType == SiteType.naverCafe) {
      final String commentUrl = '$url/comments';
      final Map<String, String> headers = {'User-Agent': _userAgentMobile};

      final InterceptorsWrapper interceptor =
          await _buildInterceptorCookie(parser.baseUrl);
      _dio.interceptors.add(interceptor);

      try {
        final Future<Response> commentFuture =
            get(commentUrl, headers: headers, responseType: ResponseType.json);
        final Future<Response> detailFuture =
            get(url, headers: headers, responseType: ResponseType.json);
        final List<Response> responses =
            await Future.wait([detailFuture, commentFuture]);

        log('[getDetail] $url, commentUrl=$commentUrl');

        if (responses.first.statusCode == 200 &&
            responses.last.statusCode == 200) {
          final List data = responses.map((response) => response.data).toList();
          final Response<List> result = Response<List<dynamic>>(
              data: data, requestOptions: RequestOptions());
          return parser.detail(result);
        } else {
          return Left(
            GetDetailFailure(message: 'response.statusCode = not 200'),
          );
        }
      } on DioException catch (e) {
        final String message = e.message ?? 'Unknown Error';
        log('getDetail = $url message = $message');
        return Left(GetDetailFailure(message: message));
      } finally {
        _dio.interceptors.remove(interceptor);
      }
    } else {
      final Map<String, String> headers = {
        'User-Agent':
            parser.siteType == SiteType.meeco ? _userAgentMobile : _userAgentPc
      };

      final InterceptorsWrapper interceptor =
          await _buildInterceptorCookie(parser.baseUrl);
      _dio.interceptors.add(interceptor);
      try {
        final Response response = await get(url, headers: headers);
        log('[getDetail] $url, $headers response = ${response.statusCode}');
        return response.statusCode == 200
            ? parser.detail(response)
            : Left(
                GetDetailFailure(
                    message: 'response.statusCode = ${response.statusCode}'),
              );
      } on DioException catch (e) {
        final String message = e.message ?? 'Unknown Error';
        log('getDetail = $url message = $message');
        return Left(GetDetailFailure(message: message));
      } finally {
        _dio.interceptors.remove(interceptor);
      }
    }
  }

  Future<Either<Failure, List<MainItem>>> getMain(BaseParser parser) async {
    final String url = parser.urlByMain();
    final Map<String, String> headers = {'User-Agent': _userAgentMobile};
    final InterceptorsWrapper interceptor = await _buildInterceptorCookie(url);
    _dio.interceptors.add(interceptor);

    try {
      final Response response = await get(url, headers: headers);
      log('[getMain] $url, $headers response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.main(response)
          : Left(
              GetMainFailure(
                  message: 'response.statusCode = ${response.statusCode}'),
            );
    } on DioException catch (e) {
      final String message = e.message ?? 'Unknown Error';
      log('getMain = $url message = $message');
      return Left(GetMainFailure(message: message));
    } on FormatException catch (e) {
      final String message = e.message;
      log('getMain = $url message = $message');
      return Left(GetMainFailure(message: message));
    } finally {
      _dio.interceptors.remove(interceptor);
    }
  }
}

extension SortTypeExtension on SortType {
  String toQuery(SiteType siteType) {
    switch (siteType) {
      case SiteType.clien:
        return switch (this) {
          SortType.recent => '&od=T31',
          SortType.recommend => '&od=T33',
        };
      case SiteType.damoang:
        switch (this) {
          case SortType.recent:
            return '';
          case SortType.recommend:
            final now = DateTime.now();
            final today =
                '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
            return '&&sfl=wr_datetime&sst=wr_good&stx=$today';
        }
      case SiteType.meeco:
        return '';
      case SiteType.naverCafe:
        return '';
      case SiteType.settings:
        return '';
      case SiteType.reddit:
        switch (this) {
          case SortType.recent:
            return 'new';
          case SortType.recommend:
            return 'hot';
        }
    }
  }
}
