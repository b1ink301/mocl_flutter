import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'alerts/alert_crawler.dart';
import 'alerts/alert_routes.dart';
import 'alerts/alert_store.dart';
import 'config_store.dart';
import 'rate_limiter.dart';
import 'server_log.dart';

const Map<String, String> _jsonHeaders = {
  'content-type': 'application/json; charset=utf-8',
};

/// 서버 전체 핸들러. 테스트는 이 함수로 만든 핸들러를 직접 부른다.
Handler buildHandler(
  ConfigStore configs, {
  AlertStore? alerts,
  RateLimiter? alertLimiter,
  CrawlStatus Function()? crawlStatus,
  Duration crawlStaleAfter = const Duration(minutes: 10),
}) {
  final Router router = Router()
    ..get('/healthz', (Request request) => Response.ok('ok'))
    ..get('/v1/config', (Request request) => _config(request, configs))
    // 크롤러가 멈췄는지(감시용). 마지막 한 바퀴가 오래됐으면 503.
    ..get('/healthz/crawl', (Request request) {
      final CrawlStatus? status = crawlStatus?.call();
      if (status == null) return Response.notFound('no crawler');
      final int now = DateTime.now().millisecondsSinceEpoch;
      final bool stale =
          status.lastTickAt == 0 ||
          now - status.lastTickAt > crawlStaleAfter.inMilliseconds;
      return Response(
        stale ? 503 : 200,
        body: jsonEncode(status.toJson(now)),
        headers: _jsonHeaders,
      );
    });
  if (alerts != null) {
    mountAlertRoutes(router, alerts, alertLimiter ?? RateLimiter());
  }

  return const Pipeline()
      .addMiddleware(_accessLog())
      .addMiddleware(_errorsAsJson())
      .addHandler(router.call);
}

Response _config(Request request, ConfigStore configs) {
  final ServedConfig served = configs.current;
  final Map<String, String> headers = {
    'etag': served.etag,
    // 앱은 실행할 때 한 번만 받으므로 길게 둘 필요는 없다. 프록시 캐시는 막지 않는다.
    'cache-control': 'public, max-age=300',
  };
  if (request.headers['if-none-match'] == served.etag) {
    return Response.notModified(headers: headers);
  }
  return Response.ok(served.body, headers: {..._jsonHeaders, ...headers});
}

/// 접속 로그. 쿼리스트링 · 헤더는 남기지 않는다(앞으로 토큰이 실릴 수 있다).
Middleware _accessLog() =>
    (Handler inner) => (Request request) async {
      final Stopwatch watch = Stopwatch()..start();
      final Response response = await inner(request);
      serverLog(
        '${request.method} /${request.url.path} ${response.statusCode} '
        '${watch.elapsedMilliseconds}ms',
      );
      return response;
    };

/// 처리하지 못한 예외를 500 JSON 으로 바꾼다. 내부 사유는 응답에 싣지 않는다.
Middleware _errorsAsJson() =>
    (Handler inner) => (Request request) async {
      try {
        return await inner(request);
      } on HijackException {
        rethrow;
      } catch (e, st) {
        serverLog('[unhandled] $e\n$st', error: true);
        return Response.internalServerError(
          body: jsonEncode({'error': 'internal'}),
          headers: _jsonHeaders,
        );
      }
    };
