import 'dart:developer';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart' as cookiejar;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as diocookie;
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_action.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';

const String userAgentMobile =
    'Mozilla/5.0 (Linux; Android 14; Pixel 8 Build/AP2A.240905.003; wv) '
    'AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/130.0.6723.58 Mobile '
    'Safari/537.36 Yappli/1673b203.20240919 (Linux; Android 14; Google Build/Pixel 8)';
const String userAgentPc =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0';

abstract class BaseApi with BaseAction {
  final Dio _dio;

  final String userAgent;

  const BaseApi(this._dio, this.userAgent);

  void init(cookiejar.CookieJar cookieJar) {
    _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () =>
            HttpClient()..badCertificateCallback = (_, __, ___) => true);

    _dio.interceptors.clear();
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

  Future<Response> postUri(
    String url, {
    Map<String, String>? headers,
    Object? data,
    ResponseType? responseType,
    String? contentType,
  }) =>
      _dio.postUri(
        Uri.parse(url),
        data: data,
        options: headers != null
            ? Options(
                headers: headers,
                responseType: responseType,
                contentType: contentType,
              )
            : null,
      );

  Future<InterceptorsWrapper> _buildInterceptorCookie(String baseUrl) async {
    final webview.CookieManager cookieManager =
        webview.CookieManager.instance();
    final webview.WebUri uri = webview.WebUri(baseUrl);

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

        return handler.next(options);
      },
    );
    return interceptor;
  }

  Future<Result<T>> withSyncCookie<T>(
    String baseUrl,
    Future<Result<T>> Function() action,
  ) async {
    final InterceptorsWrapper interceptor =
        await _buildInterceptorCookie(baseUrl);
    try {
      _dio.interceptors.add(interceptor);
      return await action();
    } on DioException catch (e) {
      log('DioException: $e');
      final String message = e.message ?? 'Unknown Error';
      return Result.failure(NetworkFailure(message: message));
    } on Failure catch (e) {
      return Result.failure(e);
    } finally {
      _dio.interceptors.remove(interceptor);
    }
  }
}
