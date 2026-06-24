import 'dart:developer';

import 'package:cookie_jar/cookie_jar.dart' as cookiejar;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as diocookie;
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_action.dart';

// 차단 회피를 위해 최신 Chrome(2026.06 기준 150) UA 로 맞춘다. 웹뷰 식별
// 토큰(`; wv`)을 빼 일반 모바일 Chrome 으로 보이게 해 차단률을 낮춘다.
const String userAgentMobile =
    'Mozilla/5.0 (Linux; Android 16; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36';
const String userAgentPc =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36';

abstract class BaseApi with BaseAction {
  final Dio _dio;

  final String userAgent;

  const BaseApi(this._dio, this.userAgent);

  void init(cookiejar.CookieJar cookieJar) {
    _dio.httpClientAdapter = IOHttpClientAdapter();

    if (!kIsWeb) {
      _dio.interceptors.clear();
      _dio.interceptors.add(diocookie.CookieManager(cookieJar));
    }
  }

  Future<Response<dynamic>> getUri(Uri uri, {Map<String, String>? headers}) => _dio
      .getUri(uri, options: headers != null ? Options(headers: headers) : null);

  Future<Response<dynamic>> get(
    String url, {
    Map<String, String>? headers,
    ResponseType? responseType,
    String? contentType,
  }) => _dio.get(
    url,
    options: headers != null
        ? Options(
            headers: headers,
            responseType: responseType,
            contentType: contentType,
          )
        : null,
  );

  Future<Response<dynamic>> postUri(
    String url, {
    Map<String, String>? headers,
    Object? data,
    ResponseType? responseType,
    String? contentType,
  }) => _dio.postUri(
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

    final List<webview.Cookie> cookies = await cookieManager.getCookies(
      url: uri,
    );

    // cookiejar.Cookie 생성자는 RFC 6265 검증을 하므로 값에 큰따옴표(예: Reddit
    // 의 JSON 쿠키)가 들어가면 FormatException 을 던진다. 어차피 Cookie 헤더
    // 문자열로만 쓰이므로 WebView 원본 name/value 로 직접 헤더를 구성한다.
    final String cookieHeader = cookies
        .map((cookie) => '${cookie.name}=${cookie.value}')
        .join('; ');

    final InterceptorsWrapper interceptor = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Cookie'] = cookieHeader;
        return handler.next(options);
      },
    );
    return interceptor;
  }

  /// 웹뷰 쿠키스토어의 로그인 쿠키를 [cookieUrl] 도메인 기준으로 주입해 GET 한다.
  /// 비로그인 상태에선 쿠키가 비어 단순 GET 과 동일하게 동작하므로, 로그인이
  /// 선택적인 사이트의 읽기 요청에 그대로 적용해도 안전하다.
  Future<Response<dynamic>> getWithCookies(
    String url,
    String cookieUrl, {
    Map<String, String>? headers,
    ResponseType? responseType,
    String? contentType,
  }) async {
    if (kIsWeb) {
      return get(
        url,
        headers: headers,
        responseType: responseType,
        contentType: contentType,
      );
    }
    final InterceptorsWrapper interceptor = await _buildInterceptorCookie(
      cookieUrl,
    );
    try {
      _dio.interceptors.add(interceptor);
      return await get(
        url,
        headers: headers,
        responseType: responseType,
        contentType: contentType,
      );
    } finally {
      _dio.interceptors.remove(interceptor);
    }
  }

  Future<Either<Failure, T>> withSyncCookie<T>(
    String baseUrl,
    Future<Either<Failure, T>> Function() action,
  ) async {
    if (kIsWeb) return await action();

    final InterceptorsWrapper interceptor = await _buildInterceptorCookie(
      baseUrl,
    );
    try {
      _dio.interceptors.add(interceptor);
      return await action();
    } on DioException catch (e) {
      log('DioException: $e');
      final String message = e.message ?? 'Unknown Error';
      return Left(NetworkFailure(message: message));
    } on Failure catch (e) {
      log('DioException: $e');
      return Left(e);
    } finally {
      _dio.interceptors.remove(interceptor);
    }
  }

  /// 헤드리스 웹뷰로 [url] 을 로드해 JS 렌더링/Cloudflare 통과 후의 전체 HTML 을
  /// 반환한다. [readyMarkers] 중 하나가 HTML 에 나타날 때까지(또는 타임아웃까지)
  /// 폴링한다. 직접 HTTP 로 받기 어려운 메뉴/디렉터리 파싱에 사용.
  Future<String?> fetchRenderedHtml(
    String url, {
    List<String> readyMarkers = const [],
    int maxTries = 25,
    Duration interval = const Duration(milliseconds: 800),
  }) async {
    if (kIsWeb) return null;
    webview.HeadlessInAppWebView? headless;
    try {
      headless = webview.HeadlessInAppWebView(
        initialUrlRequest: webview.URLRequest(url: webview.WebUri(url)),
        initialSettings: webview.InAppWebViewSettings(
          userAgent: userAgent,
          javaScriptEnabled: true,
          cacheEnabled: true,
          incognito: false,
          sharedCookiesEnabled: true,
          thirdPartyCookiesEnabled: true,
        ),
      );
      await headless.run();
      final controller = headless.webViewController;
      String? last;
      for (int i = 0; i < maxTries; i++) {
        await Future<void>.delayed(interval);
        final result = await controller?.evaluateJavascript(
          source: 'document.documentElement.outerHTML',
        );
        if (result is! String || result.isEmpty) continue;
        last = result;
        final bool blocked = result.contains('Just a moment');
        final bool ready = readyMarkers.isEmpty
            ? !blocked
            : readyMarkers.any(result.contains);
        if (ready) return result;
      }
      return last;
    } catch (e) {
      log('[fetchRenderedHtml] $url error: $e');
      return null;
    } finally {
      await headless?.dispose();
    }
  }
}
