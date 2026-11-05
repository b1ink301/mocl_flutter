import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart' as cookiejar;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart' as diocookie;
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_write.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_action.dart';

// UA 상수는 서버 크롤러와 함께 쓰도록 공유 패키지에 있다.
export 'package:mocl_shared/remote_config/user_agents.dart'
    show builtInUserAgents, userAgentMobile, userAgentPc;

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
  DioExceptionType.badResponse when e.response?.statusCode == 429 =>
    const RateLimitFailure(message: '요청이 너무 잦아 잠시 막혔어요.'),
  DioExceptionType.badResponse => ServerFailure(
    message: '서버 오류 (HTTP ${e.response?.statusCode ?? '?'})',
  ),
  _ => const NetworkFailure(message: '연결에 실패했어요.'),
};

/// 코드 결함이 아니라 네트워크 상태나 사이트 정책 때문에 생기는 실패인지.
/// 이런 실패는 Crashlytics 로 올리지 않는다(진짜 결함이 묻힌다).
bool isExpectedDioFailure(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout ||
  DioExceptionType.connectionError ||
  DioExceptionType.cancel => true,
  DioExceptionType.badResponse => e.response?.statusCode == 429,
  _ => false,
};

abstract class const BaseApi(final Dio _dio, final String userAgent)
    with BaseAction {
  void init(cookiejar.CookieJar cookieJar) {
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

  /// 컨테이너([parent]) 의 하위 메뉴 목록을 받아온다.
  /// URL 과 파싱은 파서가 정하므로 사이트별 API 구현이 따로 필요 없다.
  /// 쿠키 동기화가 필요한 사이트(네이버카페 등)만 오버라이드한다.
  Future<Either<Failure, List<MainItem>>> subMenu(
    MainItem parent,
    BaseParser parser,
  ) async {
    final String url = parser.urlBySubMenu(parent);
    final Response<dynamic> response = await get(
      url,
      headers: {'User-Agent': userAgent},
    );
    MoclLogger.d(() => '[subMenu] $url response = ${response.statusCode}');
    return response.statusCode == 200
        ? parser.subMenu(response, parent)
        : Left(
            GetMainFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  }

  Future<Response<dynamic>> postUri(
    String url, {
    Map<String, String>? headers,
    Object? data,
    ResponseType? responseType,
    String? contentType,

    /// [get] 과 같다. 오류 상태코드 본문에 사유를 담아 주는 쓰기 API 에 쓴다.
    bool Function(int?)? validateStatus,
  }) => _dio.postUri(
    Uri.parse(url),
    data: data,
    options: Options(
      headers: headers,
      responseType: responseType,
      contentType: contentType,
      validateStatus: validateStatus,
    ),
  );

  /// 이 사이트에서 앱으로 댓글을 쓸 수 있는지. 쓸 수 있는 사이트만 오버라이드한다.
  bool get supportsCommentWrite => false;

  /// 댓글(또는 [CommentWrite.parent] 에 다는 대댓글)을 쓴다.
  Future<Either<Failure, Unit>> writeComment(
    CommentWrite write,
    BaseParser parser,
  ) async =>
      const Left(WriteCommentFailure(message: '이 사이트는 앱에서 댓글을 쓸 수 없어요.'));

  Future<InterceptorsWrapper> _buildInterceptorCookie(String baseUrl) async {
    final webview.CookieManager cookieManager =
        webview.CookieManager.instance();
    // [baseUrl] 만으로 조회하면 경로가 `/` 라서 `Path=/service` 같은 하위 경로
    // 쿠키가 빠진다(클리앙 로그인 세션 `CLIEN_SESSION` 이 그렇다). 그래서
    // 요청마다 실제 URL 로도 조회해 합친다. 같은 이름이면 요청 URL 쪽이 이긴다.
    // 리다이렉트 중에 응답이 지우거나 바꾼 쿠키를 다음 요청에 반영해야 하므로
    // 둘 다 요청마다 새로 읽는다(미리 읽어 두면 지운 만료 세션이 계속 실려 루프).
    final InterceptorsWrapper interceptor = InterceptorsWrapper(
      onRequest: (options, handler) async {
        final Map<String, String> cookies = {};
        try {
          // http 로 내려가는 리다이렉트(클리앙 302 → http)에 https 쪽 Secure
          // 쿠키가 평문으로 실리지 않게 한다. 요청 URL 조회는 웹뷰가 걸러 준다.
          if (options.uri.scheme == 'https' || !baseUrl.startsWith('https')) {
            cookies.addAll(
              _cookieMap(
                await cookieManager.getCookies(url: webview.WebUri(baseUrl)),
              ),
            );
          }
          cookies.addAll(
            _cookieMap(
              await cookieManager.getCookies(
                url: webview.WebUri.uri(options.uri),
              ),
            ),
          );
        } catch (e) {
          MoclLogger.w(() => '[cookie] 요청 URL 쿠키 조회 실패: $e');
        }
        // cookiejar.Cookie 생성자는 RFC 6265 검증을 하므로 값에 큰따옴표(예:
        // Reddit 의 JSON 쿠키)가 들어가면 FormatException 을 던진다. 어차피
        // Cookie 헤더 문자열로만 쓰이므로 WebView 원본 name/value 로 직접 만든다.
        options.headers['Cookie'] = cookies.entries
            .map((e) => '${e.key}=${e.value}')
            .join('; ');
        _takeOverRedirects(options);
        handler.next(options);
      },
      onResponse: (response, handler) async {
        await _saveSetCookies(cookieManager, response);
        final RequestOptions options = response.requestOptions;
        final int status = response.statusCode ?? 0;
        if (options.extra[_redirectHopsKey] == null ||
            status < 300 ||
            status >= 400) {
          handler.next(response);
          return;
        }
        final String? location = response.headers.value(
          HttpHeaders.locationHeader,
        );
        final int hops = options.extra[_redirectHopsKey] as int;
        final bool Function(int?) validateStatus =
            options.extra[_validateStatusKey] as bool Function(int?);
        if (location == null || hops >= options.maxRedirects) {
          // 원래대로라면 dio 가 던졌을 응답이면 똑같이 던진다.
          validateStatus(status)
              ? handler.next(response)
              : handler.reject(
                  DioException.badResponse(
                    statusCode: status,
                    requestOptions: options,
                    response: response,
                  ),
                );
          return;
        }
        // 다시 이 인터셉터를 지나므로 쿠키는 방금 반영한 웹뷰 저장소에서 읽는다.
        final Map<String, dynamic> headers = {...options.headers}
          ..removeWhere((key, _) {
            final String lower = key.toLowerCase();
            return lower == 'host' || lower == 'cookie';
          });
        try {
          handler.resolve(
            await _dio.fetch<dynamic>(
              options.copyWith(
                path: options.uri.resolve(location).toString(),
                queryParameters: const {},
                headers: headers,
                extra: {...options.extra, _redirectHopsKey: hops + 1},
              ),
            ),
          );
        } on DioException catch (e) {
          handler.reject(e);
        }
      },
    );
    return interceptor;
  }

  static const String _redirectHopsKey = 'mocl.redirectHops';
  static const String _validateStatusKey = 'mocl.validateStatus';

  /// GET 의 리다이렉트를 dart:io 대신 [_buildInterceptorCookie] 가 따라가게 한다.
  ///
  /// dart:io 가 따라가면 중간 응답(302)의 Set-Cookie 를 볼 수 없다. 클리앙은 만료된
  /// `CLIEN_SESSION` 에 "쿠키 삭제 + 같은 주소로 302" 를 주는데, 이를 웹뷰
  /// 저장소에 반영하지 못하면 매 요청이 만료 쿠키로 나가 로그인이 풀린 채로 남는다.
  /// 지운 뒤 다시 요청하면 `remember-me` 로 새 세션을 받아 로그인이 이어진다.
  static void _takeOverRedirects(RequestOptions options) {
    if (options.method.toUpperCase() != 'GET') return;
    if (options.extra[_redirectHopsKey] == null) {
      if (!options.followRedirects) return;
      options.extra[_redirectHopsKey] = 0;
      options.extra[_validateStatusKey] = options.validateStatus;
    }
    final bool Function(int?) validateStatus =
        options.extra[_validateStatusKey] as bool Function(int?);
    options
      ..followRedirects = false
      ..validateStatus = (status) =>
          (status != null && status >= 300 && status < 400) ||
          validateStatus(status);
  }

  /// 응답의 Set-Cookie 를 웹뷰 쿠키 저장소에 반영한다. 요청 쿠키는 웹뷰 저장소에서
  /// 읽으므로, 여기에 반영하지 않으면 서버가 지우거나 새로 준 쿠키가 무시된다.
  static Future<void> _saveSetCookies(
    webview.CookieManager cookieManager,
    Response<dynamic> response,
  ) async {
    final List<String>? setCookies =
        response.headers[HttpHeaders.setCookieHeader];
    if (setCookies == null || setCookies.isEmpty) return;
    final webview.WebUri url = webview.WebUri.uri(response.requestOptions.uri);
    final DateTime now = DateTime.now();
    for (final String raw in setCookies) {
      try {
        final Cookie cookie = Cookie.fromSetCookieValue(raw);
        final int? maxAge = cookie.maxAge;
        final DateTime? expires = cookie.expires;
        final bool expired =
            (maxAge != null && maxAge <= 0) ||
            (maxAge == null && expires != null && expires.isBefore(now));
        if (expired) {
          await cookieManager.deleteCookie(
            url: url,
            name: cookie.name,
            path: cookie.path ?? '/',
            domain: cookie.domain,
          );
        } else {
          await cookieManager.setCookie(
            url: url,
            name: cookie.name,
            value: cookie.value,
            path: cookie.path ?? '/',
            domain: cookie.domain,
            maxAge: maxAge,
            expiresDate: expires?.millisecondsSinceEpoch,
            isSecure: cookie.secure,
            isHttpOnly: cookie.httpOnly,
            sameSite: switch (cookie.sameSite) {
              SameSite.lax => webview.HTTPCookieSameSitePolicy.LAX,
              SameSite.strict => webview.HTTPCookieSameSitePolicy.STRICT,
              SameSite.none => webview.HTTPCookieSameSitePolicy.NONE,
              _ => null,
            },
          );
        }
      } catch (e) {
        // 쿠키 값은 남기지 않는다.
        MoclLogger.w(() => '[cookie] Set-Cookie 반영 실패: ${e.runtimeType}');
      }
    }
  }

  static Map<String, String> _cookieMap(List<webview.Cookie> cookies) => {
    for (final cookie in cookies) cookie.name: '${cookie.value}',
  };

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
      // 연결 끊김 · 타임아웃 · 429 는 운영 중 늘 생기는 일이라 버그 리포트에서 뺀다.
      if (isExpectedDioFailure(e)) {
        MoclLogger.w(
          () => 'DioException ${e.type.name} ${e.response?.statusCode ?? ''}',
        );
      } else {
        MoclLogger.e('DioException', error: e);
      }
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
