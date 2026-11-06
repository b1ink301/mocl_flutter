import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mocl_server/src/canary/canary.dart';
import 'package:mocl_server/src/crawl/site_fetcher.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:test/test.dart';

/// 주소별로 정해 둔 응답을 돌려주는 가짜 어댑터. 값이 null 이면 연결 실패를 흉내 낸다.
class _FakeAdapter(final ({int status, String body})? Function(Uri) route)
    implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final r = route(options.uri);
    if (r == null) {
      throw DioException.connectionTimeout(
        timeout: const Duration(seconds: 15),
        requestOptions: options,
      );
    }
    return ResponseBody.fromBytes(utf8.encode(r.body), r.status);
  }

  @override
  void close({bool force = false}) {}
}

String _fixture(String name) =>
    File('../packages/mocl_shared/test/fixtures/$name').readAsStringSync();

const CanaryTarget _geek = CanaryTarget(
  SiteType.geekNews,
  'past',
  'https://news.hada.io/past',
);

Canary _canary(({int status, String body})? Function(Uri) route) => Canary(
  fetcher: SiteFetcher(
    dioFactory: (_) => Dio(
      BaseOptions(
        responseType: ResponseType.bytes,
        validateStatus: (_) => true,
      ),
    )..httpClientAdapter = _FakeAdapter(route),
  ),
  pause: Duration.zero,
);

void main() {
  test('목록 · 상세를 읽으면 ok', () async {
    final r = await _canary(
      (uri) => uri.path == '/topic'
          ? (status: 200, body: _fixture('geek_news_detail.html'))
          : (status: 200, body: _fixture('geek_news_list.html')),
    ).check(_geek);
    expect(r.status, CanaryStatus.ok, reason: r.message);
    expect(r.listCount, greaterThan(0));
  });

  test('403 · 429 · 연결 실패는 막힘(파서 문제로 보지 않는다)', () async {
    for (final int code in [403, 429, 503]) {
      final r = await _canary((_) => (status: code, body: '')).check(_geek);
      expect(r.status, CanaryStatus.unreachable, reason: '$code');
    }
    final r = await _canary((_) => null).check(_geek);
    expect(r.status, CanaryStatus.unreachable);
  });

  test('없어진 게시판(410) · 빈 목록 · 빈 본문은 고장', () async {
    expect(
      (await _canary((_) => (status: 410, body: '')).check(_geek)).status,
      CanaryStatus.broken,
    );
    expect(
      (await _canary((_) => (status: 200, body: '<html><body></body></html>'))
              .check(_geek))
          .status,
      CanaryStatus.broken,
    );
    final r = await _canary(
      (uri) => uri.path == '/topic'
          ? (status: 200, body: '<html><body>바뀐 화면</body></html>')
          : (status: 200, body: _fixture('geek_news_list.html')),
    ).check(_geek);
    expect(r.status, CanaryStatus.broken);
    expect(r.message, startsWith('상세'));
  });
}
