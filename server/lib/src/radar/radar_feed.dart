import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mocl_shared/radar/issue_feed.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../rate_limiter.dart';
import '../server_log.dart';
import 'radar_ranker.dart';
import 'radar_store.dart';

/// 계산해 둔 이슈 목록. 요청은 이 캐시만 내보낸다(계산은 수집 직후 한 번).
class RadarFeed(
  final RadarStore _store, {
  final RadarRanker ranker = const RadarRanker(),
}) {
  IssueFeed? _feed;
  List<int> _body = const [];
  String _etag = '';
  Map<String, Map<String, Object?>> _byId = const {};

  IssueFeed? get current => _feed;

  Future<void> rebuild(int now, {Set<String> failing = const {}}) async {
    final Stopwatch w = Stopwatch()..start();
    final IssueFeed feed = ranker.rank(
      await _store.posts(),
      now,
      failing: failing,
    );
    final Map<String, Object?> json = feed.toJson();
    _feed = feed;
    _body = utf8.encode(jsonEncode(json));
    _etag = '"${sha256.convert(_body).toString().substring(0, 32)}"';
    _byId = {
      for (final Object? i in json['issues']! as List)
        (i! as Map<String, Object?>)['id']! as String:
            i as Map<String, Object?>,
    };
    serverLog('[radar] 이슈 ${feed.issues.length}개 · ${w.elapsedMilliseconds}ms');
  }

  /// [limiter] 가 있으면 IP 당 요청 수를 제한한다(공개 데이터지만 긁어 가기 · 트래픽 남용 방지).
  void mount(Router router, {RateLimiter? limiter}) {
    const Map<String, String> json = {
      'content-type': 'application/json; charset=utf-8',
    };
    Response? limited(Request request) =>
        limiter == null || limiter.allow(RateLimiter.clientKey(request))
        ? null
        : Response(429, body: '{"error":"rate_limited"}', headers: json);
    router
      ..get('/v1/issues', (Request request) {
        final Response? rejected = limited(request);
        if (rejected != null) return rejected;
        if (_feed == null) {
          return Response(503, body: '{"error":"warming_up"}', headers: json);
        }
        final Map<String, String> headers = {
          'etag': _etag,
          'cache-control': 'public, max-age=60',
        };
        if (request.headers['if-none-match'] == _etag) {
          return Response.notModified(headers: headers);
        }
        return Response.ok(_body, headers: {...json, ...headers});
      })
      ..get('/v1/issues/<id>', (Request request, String id) {
        final Response? rejected = limited(request);
        if (rejected != null) return rejected;
        final Map<String, Object?>? issue = _byId[id];
        if (issue == null) {
          return Response.notFound('{"error":"not_found"}', headers: json);
        }
        return Response.ok(
          jsonEncode(issue),
          headers: {...json, 'cache-control': 'public, max-age=60'},
        );
      });
  }
}
