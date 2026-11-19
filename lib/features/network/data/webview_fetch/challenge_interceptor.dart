import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/network/data/webview_fetch/webview_fetcher.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:mocl_shared/util/cloudflare_challenge.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// Cloudflare 보안 검사에 걸린 요청을 웹뷰([WebViewFetcher])로 다시 받는다.
///
/// 사이트 Dio 마다 하나 붙는다(`network_provider.dart` 의 `_buildDio`). 사이트 API ·
/// 파서는 이걸 모른다 — 웹뷰로 받은 응답도 Dio 응답처럼 돌려준다.
/// - [mode] `auto`: Dio 로 받고, 검사 응답(403/503)이면 웹뷰로 다시 받는다. 그 호스트는
///   [hold] 동안 Dio 를 건너뛰고 바로 웹뷰로 받는다(403 왕복을 줄인다).
/// - `webview`: 처음부터 웹뷰. `dio`: 아무것도 하지 않는다.
/// 웹뷰로 바꿀 수 없는 요청(FormData · 바이트 응답)은 손대지 않는다.
class ChallengeInterceptor(
  final SiteFetchMode mode,
  final String userAgent,
  final WebViewFetcher fetcher, {
  final DateTime Function() now = DateTime.now,
}) extends Interceptor {
  static const Duration hold = Duration(minutes: 10);

  /// 호스트 → 웹뷰로 받는 기한. 같은 호스트를 쓰는 Dio 가 함께 본다.
  static final Map<String, DateTime> _challengedUntil = {};

  /// 테스트용.
  static void resetForTest() => _challengedUntil.clear();

  bool _held(String host) => _challengedUntil[host]?.isAfter(now()) ?? false;

  void _markChallenged(String host) {
    _challengedUntil[host] = now().add(hold);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (mode == SiteFetchMode.dio || !_convertible(options)) {
      return handler.next(options);
    }
    if (mode == SiteFetchMode.webview || _held(options.uri.host)) {
      _viaWebView(
        options,
        onResolve: (r) => handler.resolve(r, true),
        onReject: (e) => handler.reject(e, true),
      );
      return;
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    // validateStatus 로 4xx 를 응답으로 받는 곳(레딧 등)도 여기서 거른다.
    if (_shouldFallBack(response)) {
      _viaWebView(
        response.requestOptions,
        onResolve: handler.next,
        onReject: handler.reject,
      );
      return;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final Response<dynamic>? response = err.response;
    if (response != null && _shouldFallBack(response)) {
      _viaWebView(
        err.requestOptions,
        onResolve: handler.resolve,
        onReject: handler.next,
      );
      return;
    }
    handler.next(err);
  }

  bool _shouldFallBack(Response<dynamic> response) {
    final RequestOptions options = response.requestOptions;
    if (mode == SiteFetchMode.dio || !_convertible(options)) return false;
    if (options.extra[_viaWebViewKey] == true) return false;
    final bool challenged = CloudflareChallenge.isChallenge(
      status: response.statusCode,
      headers: response.headers.map,
      body: response.data,
    );
    if (challenged) {
      MoclLogger.w(
        () =>
            '[challenge] ${options.uri.host} ${response.statusCode} → 웹뷰로 받는다',
      );
      _markChallenged(options.uri.host);
    }
    return challenged;
  }

  Future<void> _viaWebView(
    RequestOptions options, {
    required void Function(Response<dynamic>) onResolve,
    required void Function(DioException) onReject,
  }) async {
    try {
      final WebViewResponse r = await fetcher.fetch(
        WebViewRequest(
          url: options.uri,
          method: options.method.toUpperCase(),
          headers: _forwardHeaders(options),
          body: _encodeBody(options),
          userAgent: userAgent,
        ),
      );
      options.extra[_viaWebViewKey] = true;
      final Response<dynamic> response = Response<dynamic>(
        requestOptions: options,
        statusCode: r.status,
        data: _decodeBody(options, r),
        headers: Headers.fromMap({
          if (r.contentType.isNotEmpty)
            Headers.contentTypeHeader: [r.contentType],
        }),
        // 리다이렉트를 따라갔으면 최종 주소를 realUri 로 보이게 한다.
        isRedirect: r.url != options.uri,
        redirects: [
          if (r.url != options.uri)
            RedirectRecord(r.status, options.method, r.url),
        ],
      );
      final bool ok = options.validateStatus(r.status);
      if (ok) return onResolve(response);
      onReject(
        DioException.badResponse(
          statusCode: r.status,
          requestOptions: options,
          response: response,
        ),
      );
    } on ChallengeException catch (e) {
      onReject(
        DioException(requestOptions: options, error: e, message: e.message),
      );
    } catch (e, st) {
      onReject(DioException(requestOptions: options, error: e, stackTrace: st));
    }
  }

  static const String _viaWebViewKey = 'mocl.viaWebView';

  /// 웹뷰 `fetch` 로 옮길 수 있는 요청인지.
  static bool _convertible(RequestOptions options) {
    if (options.responseType == ResponseType.bytes ||
        options.responseType == ResponseType.stream) {
      return false;
    }
    final Object? data = options.data;
    return data == null || data is String || data is Map || data is List;
  }

  /// 웹뷰가 스스로 정하는 헤더(쿠키 · UA · 호스트 · 길이)는 넘기지 않는다.
  static const Set<String> _skipHeaders = {
    'cookie',
    'host',
    'user-agent',
    'content-length',
    'accept-encoding',
    'connection',
  };

  static Map<String, String> _forwardHeaders(RequestOptions options) {
    final Map<String, String> headers = {
      for (final MapEntry<String, dynamic> e in options.headers.entries)
        if (!_skipHeaders.contains(e.key.toLowerCase()) && e.value != null)
          e.key: '${e.value}',
    };
    final String? contentType = options.contentType;
    if (options.data != null && contentType != null) {
      headers.removeWhere((k, _) => k.toLowerCase() == 'content-type');
      headers['Content-Type'] = contentType;
    }
    return headers;
  }

  static String? _encodeBody(RequestOptions options) {
    final Object? data = options.data;
    if (data == null || data is String) return data as String?;
    final String contentType = options.contentType ?? Headers.jsonContentType;
    if (data is Map && contentType.contains('x-www-form-urlencoded')) {
      return Transformer.urlEncodeMap(data.cast<String, dynamic>());
    }
    return jsonEncode(data);
  }

  static Object? _decodeBody(RequestOptions options, WebViewResponse r) {
    if (options.responseType == ResponseType.json &&
        r.contentType.toLowerCase().contains('json') &&
        r.body.isNotEmpty) {
      try {
        return jsonDecode(r.body);
      } on FormatException {
        return r.body;
      }
    }
    return r.body;
  }
}
