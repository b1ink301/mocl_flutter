import 'package:cookie_jar/cookie_jar.dart' as cookiejar;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as diocookie;
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_action.dart';

// 차단 회피를 위해 최신 Chrome(2026.06 기준 150) UA 로 맞춘다. 웹뷰 식별
// 토큰(`; wv`)을 빼 일반 모바일 Chrome 으로 보이게 해 차단률을 낮춘다.
const String userAgentMobile =
    'Mozilla/5.0 (Linux; Android 16; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Mobile Safari/537.36';
const String userAgentPc =
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36';

/// [DioException] 을 사용자에게 그대로 보여줄 수 있는 짧은 한국어 사유의
/// [Failure] 로 바꾼다. dio 의 기본 message 는 영문 설명 + MDN 링크까지 담긴
/// 여러 줄 문자열이라 화면에 노출하면 안 된다.
Failure failureFromDio(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => const NetworkFailure(
    message: '서버 응답이 너무 느려요.',
  ),
  DioExceptionType.connectionError => const NetworkFailure(
    message: '인터넷에 연결할 수 없어요.',
  ),
  DioExceptionType.badCertificate => const NetworkFailure(
    message: '보안 인증서를 확인할 수 없어요.',
  ),
  DioExceptionType.cancel => const NetworkFailure(message: '요청이 취소되었어요.'),
  DioExceptionType.badResponse => ServerFailure(
    message: '서버 오류 (HTTP ${e.response?.statusCode ?? '?'})',
  ),
  _ => const NetworkFailure(message: '연결에 실패했어요.'),
};

abstract class const BaseApi(final Dio _dio, final String userAgent)
    with BaseAction {
  void init(cookiejar.CookieJar cookieJar) {
    _dio.httpClientAdapter = IOHttpClientAdapter();

    if (!kIsWeb) {
      _dio.interceptors.clear();
      _dio.interceptors.add(diocookie.CookieManager(cookieJar));
    }
  }

  Future<Response<dynamic>> getUri(Uri uri, {Map<String, String>? headers}) =>
      _dio.getUri(
        uri,
        options: headers != null ? Options(headers: headers) : null,
      );

  Future<Response<dynamic>> get(
    String url, {
    Map<String, String>? headers,
    ResponseType? responseType,
    String? contentType,

    /// true 를 돌려주면 해당 상태코드에서 예외를 던지지 않는다. 서버가 오류
    /// 상태코드(예: 500)의 **본문**에 사람이 읽을 수 있는 사유를 담아 보내는
    /// API 에서, 그 본문을 파서로 넘기기 위해 사용한다.
    bool Function(int?)? validateStatus,
  }) => _dio.get(
    url,
    options: headers != null || validateStatus != null
        ? Options(
            headers: headers,
            responseType: responseType,
            contentType: contentType,
            validateStatus: validateStatus,
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
      MoclLogger.e('DioException', error: e);
      return Left(failureFromDio(e));
    } on Failure catch (e) {
      MoclLogger.e('DioException', error: e);
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
      MoclLogger.e('[fetchRenderedHtml] $url error', error: e);
      return null;
    } finally {
      await headless?.dispose();
    }
  }
}
