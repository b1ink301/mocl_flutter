import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as webview;
import 'package:mocl_flutter/features/network/data/webview_fetch/app_scroll_activity.dart';
import 'package:mocl_flutter/features/network/data/webview_fetch/webview_fetcher.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 출처(scheme + host) · UA 마다 헤드리스 웹뷰를 하나 살려 두고, 그 안에서 `fetch` 로 받는다.
///
/// - 처음 쓸 때 페이지를 띄워 Cloudflare 보안 검사를 통과시킨다(GET 은 그 주소,
///   POST 는 출처 첫 화면). 그다음부터는 같은 웹뷰의 `fetch` 라 렌더링 없이 원본 응답만 받는다.
///   파서는 Dio 때와 같은 HTML 을 받는다(렌더된 DOM 이 아니다).
/// - 웹뷰는 동시에 [maxWebViews] 개까지. 넘으면 가장 오래 안 쓴 것을 버린다.
/// - [idleTimeout] 동안 안 쓰면 버린다. 생성 · 해제는 Android 메인 스레드(= UI 스레드)를
///   잠깐 막으므로 해제는 스크롤이 멈춘 뒤([AppScrollActivity])로 미룬다.
/// - 응답이 다시 검사 페이지면(통과 쿠키 만료) 페이지를 다시 띄워 한 번만 재시도한다.
class HeadlessWebViewFetcher._() implements WebViewFetcher {
  static final HeadlessWebViewFetcher instance = HeadlessWebViewFetcher._();

  static const int maxWebViews = 2;
  static const Duration idleTimeout = Duration(minutes: 3);
  static const Duration readyTimeout = Duration(seconds: 20);
  static const Duration fetchTimeout = Duration(seconds: 20);
  static const Duration _poll = Duration(milliseconds: 300);

  /// 쓴 순서(앞이 가장 오래 안 쓴 것).
  final LinkedHashMap<String, _Session> _sessions = LinkedHashMap();

  @override
  Future<WebViewResponse> fetch(WebViewRequest request) async {
    if (kIsWeb) throw const ChallengeException('웹에서는 웹뷰로 받을 수 없어요');
    final _Session session = _sessionFor(request);
    try {
      WebViewResponse response = await session.fetch(request);
      if (response.challenged) {
        MoclLogger.w(
          () => '[webviewFetch] ${request.url.host} 다시 검사 → 페이지 재로드',
        );
        await session.reload(request);
        response = await session.fetch(request);
        if (response.challenged) {
          throw const ChallengeException('보안 검사를 통과하지 못했어요');
        }
      }
      return response;
    } on ChallengeException {
      _drop(session);
      rethrow;
    } catch (e) {
      _drop(session);
      throw ChallengeException('웹뷰 요청 실패: $e');
    } finally {
      session.touch(() => _drop(session));
    }
  }

  _Session _sessionFor(WebViewRequest request) {
    final String key = '${request.url.origin}|${request.userAgent}';
    final _Session? existing = _sessions.remove(key);
    if (existing != null) {
      _sessions[key] = existing; // 맨 뒤(최근)로
      return existing;
    }
    while (_sessions.length >= maxWebViews) {
      _drop(_sessions.values.first);
    }
    final _Session created = _Session(
      key,
      request.userAgent,
      _Session._entryUrl(request),
    );
    _sessions[key] = created;
    return created;
  }

  /// [session] 을 버린다. 같은 키로 새로 만든 세션은 건드리지 않는다.
  void _drop(_Session session) {
    if (identical(_sessions[session.key], session)) {
      _sessions.remove(session.key);
    }
    session.disposeWhenQuiet();
  }
}

class _Session(final String key, final String _userAgent, Uri entry) {
  this {
    _ready = _open(entry);
  }
  webview.HeadlessInAppWebView? _headless;
  late Future<void> _ready;
  Timer? _idle;
  bool _disposed = false;

  /// GET 은 그 주소를 띄워 검사를 통과시킨다. 다른 메서드는 띄울 수 없으니 출처 첫 화면.
  static Uri _entryUrl(WebViewRequest request) =>
      request.method == 'GET' ? request.url : Uri.parse(request.url.origin);

  Future<void> _open(Uri url) async {
    final Stopwatch watch = Stopwatch()..start();
    final webview.HeadlessInAppWebView headless = webview.HeadlessInAppWebView(
      initialUrlRequest: webview.URLRequest(url: webview.WebUri.uri(url)),
      initialSettings: webview.InAppWebViewSettings(
        userAgent: _userAgent,
        javaScriptEnabled: true,
        cacheEnabled: true,
        incognito: false,
        sharedCookiesEnabled: true,
        thirdPartyCookiesEnabled: true,
        // 보이지 않는 웹뷰라 이미지 · 미디어는 받지 않는다(데이터 · 메모리 절약).
        blockNetworkImage: true,
        mediaPlaybackRequiresUserGesture: true,
      ),
    );
    _headless = headless;
    await headless.run();
    await _waitPassed();
    MoclLogger.d(
      () => '[webviewFetch] ${url.host} 준비 ${watch.elapsedMilliseconds}ms',
    );
  }

  /// 페이지가 다 뜨고 검사 표시가 사라질 때까지 기다린다.
  Future<void> _waitPassed() async {
    final DateTime deadline = DateTime.now().add(
      HeadlessWebViewFetcher.readyTimeout,
    );
    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(HeadlessWebViewFetcher._poll);
      if (_disposed) throw const ChallengeException('웹뷰가 닫혔어요');
      try {
        final Object? passed = await _headless?.webViewController
            ?.evaluateJavascript(
              source:
                  "document.readyState !== 'loading' && "
                  "typeof window._cf_chl_opt === 'undefined' && "
                  "!location.pathname.startsWith('/cdn-cgi/')",
            );
        if (passed == true) return;
      } catch (_) {
        // 검사 통과 직후 페이지가 바뀌는 중이면 실패할 수 있다. 다시 본다.
      }
    }
    throw const ChallengeException('보안 검사를 통과하지 못했어요(시간 초과)');
  }

  Future<void> reload(WebViewRequest request) async {
    _ready = () async {
      await _headless?.webViewController?.loadUrl(
        urlRequest: webview.URLRequest(
          url: webview.WebUri.uri(_entryUrl(request)),
        ),
      );
      await _waitPassed();
    }();
    await _ready;
  }

  Future<WebViewResponse> fetch(WebViewRequest request) async {
    _idle?.cancel();
    await _ready;
    final webview.CallAsyncJavaScriptResult? result = await _headless
        ?.webViewController
        ?.callAsyncJavaScript(
          functionBody: _fetchScript,
          arguments: {
            'url': request.url.toString(),
            'method': request.method,
            'headers': request.headers,
            'body': request.body,
          },
        )
        .timeout(HeadlessWebViewFetcher.fetchTimeout);
    final Object? value = result?.value;
    if (result?.error != null || value is! String) {
      throw ChallengeException('fetch 실패: ${result?.error}');
    }
    final Map<String, dynamic> json = jsonDecode(value) as Map<String, dynamic>;
    return WebViewResponse(
      status: json['status'] as int,
      url: Uri.parse(json['url'] as String? ?? request.url.toString()),
      body: json['body'] as String? ?? '',
      contentType: json['contentType'] as String? ?? '',
      challenged: json['challenged'] == true,
    );
  }

  /// 응답 전체를 문자열 하나(JSON)로 돌려준다 — 채널을 한 번만 건넌다.
  static const String _fetchScript = r'''
const r = await fetch(url, {
  method: method,
  headers: headers,
  body: method === 'GET' || method === 'HEAD' ? undefined : body,
  credentials: 'include',
  redirect: 'follow',
});
const text = await r.text();
const challenged = (r.status === 403 || r.status === 503) &&
  (r.headers.get('cf-mitigated') === 'challenge' ||
   text.includes('/cdn-cgi/challenge-platform/') || text.includes('_cf_chl_opt'));
return JSON.stringify({
  status: r.status,
  url: r.url,
  contentType: r.headers.get('content-type') || '',
  challenged: challenged,
  body: text,
});
''';

  /// 마지막으로 쓴 뒤 [HeadlessWebViewFetcher.idleTimeout] 이 지나면 [onIdle].
  void touch(void Function() onIdle) {
    _idle?.cancel();
    if (_disposed) return;
    _idle = Timer(HeadlessWebViewFetcher.idleTimeout, onIdle);
  }

  /// 스크롤 중이면 멈출 때까지 미뤘다가 버린다.
  void disposeWhenQuiet() {
    _idle?.cancel();
    if (_disposed) return;
    _disposed = true;
    void tryDispose() {
      if (!AppScrollActivity.isQuiet) {
        Timer(AppScrollActivity.quietAfter, tryDispose);
        return;
      }
      final webview.HeadlessInAppWebView? headless = _headless;
      _headless = null;
      MoclLogger.d(() => '[webviewFetch] ${key.split('|').first} 웹뷰 정리');
      unawaited(headless?.dispose());
    }

    tryDispose();
  }
}
