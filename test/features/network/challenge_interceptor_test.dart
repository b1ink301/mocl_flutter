import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/network/data/webview_fetch/challenge_interceptor.dart';
import 'package:mocl_flutter/features/network/data/webview_fetch/webview_fetcher.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';

/// 네트워크 대신 정해 둔 응답을 돌려주는 어댑터. 요청 수를 센다.
class _FakeAdapter(
  final int status,
  final String body, {
  final Map<String, List<String>> headers = const {},
}) implements HttpClientAdapter {
  int calls = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    calls++;
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['text/html; charset=UTF-8'],
        ...headers,
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeFetcher({
  final WebViewResponse? response,
  final ChallengeException? error,
}) implements WebViewFetcher {  final List<WebViewRequest> requests = [];

  @override
  Future<WebViewResponse> fetch(WebViewRequest request) async {
    requests.add(request);
    if (error != null) throw error!;
    return response!;
  }
}

const String _challengeBody =
    '<html><head><title>Just a moment...</title></head>'
    '<body><script>window._cf_chl_opt = {};</script></body></html>';

Dio _dio(_FakeAdapter adapter, _FakeFetcher fetcher, SiteFetchMode mode) =>
    Dio()
      ..httpClientAdapter = adapter
      ..interceptors.add(ChallengeInterceptor(mode, 'UA/1.0', fetcher));

void main() {
  setUp(ChallengeInterceptor.resetForTest);

  final Uri url = Uri.parse('https://theqoo.net/hot?page=1');
  WebViewResponse ok(String body, {String contentType = 'text/html'}) =>
      WebViewResponse(
        status: 200,
        url: url,
        body: body,
        contentType: contentType,
      );

  test('auto: 검사 403 이면 웹뷰로 받고, 그 뒤엔 Dio 를 건너뛴다', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(response: ok('<ul class="list">ok</ul>'));
    final dio = _dio(adapter, fetcher, SiteFetchMode.auto);

    final first = await dio.getUri<dynamic>(url);
    expect(first.statusCode, 200);
    expect(first.data, '<ul class="list">ok</ul>');
    expect(adapter.calls, 1);
    expect(fetcher.requests.single.userAgent, 'UA/1.0');

    final second = await dio.getUri<dynamic>(url);
    expect(second.data, '<ul class="list">ok</ul>');
    expect(adapter.calls, 1, reason: '검사 중인 호스트는 Dio 로 보내지 않는다');
    expect(fetcher.requests, hasLength(2));
  });

  test('auto: 검사가 아닌 403 은 그대로 실패', () async {
    final adapter = _FakeAdapter(403, 'Forbidden');
    final fetcher = _FakeFetcher(response: ok('x'));
    final dio = _dio(adapter, fetcher, SiteFetchMode.auto);

    await expectLater(
      dio.getUri<dynamic>(url),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          403,
        ),
      ),
    );
    expect(fetcher.requests, isEmpty);
  });

  test('auto: cf-mitigated 헤더만 있어도 검사로 본다', () async {
    final adapter = _FakeAdapter(
      403,
      'blocked',
      headers: {
        'cf-mitigated': ['challenge'],
      },
    );
    final fetcher = _FakeFetcher(response: ok('ok'));
    final res = await _dio(
      adapter,
      fetcher,
      SiteFetchMode.auto,
    ).getUri<dynamic>(url);
    expect(res.data, 'ok');
  });

  test('validateStatus 로 403 을 받는 곳도 검사면 웹뷰로 받는다', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(response: ok('ok'));
    final res = await _dio(adapter, fetcher, SiteFetchMode.auto)
        .getUri<dynamic>(
          url,
          options: Options(validateStatus: (s) => s != null && s < 500),
        );
    expect(res.data, 'ok');
  });

  test('dio: 폴백하지 않는다', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(response: ok('ok'));
    await expectLater(
      _dio(adapter, fetcher, SiteFetchMode.dio).getUri<dynamic>(url),
      throwsA(isA<DioException>()),
    );
    expect(fetcher.requests, isEmpty);
  });

  test('webview: Dio 로 보내지 않는다', () async {
    final adapter = _FakeAdapter(200, 'dio');
    final fetcher = _FakeFetcher(response: ok('webview'));
    final res = await _dio(
      adapter,
      fetcher,
      SiteFetchMode.webview,
    ).getUri<dynamic>(url);
    expect(res.data, 'webview');
    expect(adapter.calls, 0);
  });

  test('POST 본문 · 헤더를 옮기고 JSON 응답을 풀어 준다', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(
      response: ok('{"a":1}', contentType: 'application/json'),
    );
    final res = await _dio(adapter, fetcher, SiteFetchMode.auto)
        .postUri<dynamic>(
          Uri.parse('https://theqoo.net/index.php'),
          data: {'act': 'x', 'document_srl': 3},
          options: Options(
            headers: {'Cookie': 'a=b', 'origin': 'https://theqoo.net'},
            responseType: ResponseType.json,
          ),
        );
    expect(res.data, {'a': 1});
    final WebViewRequest sent = fetcher.requests.single;
    expect(sent.method, 'POST');
    expect(jsonDecode(sent.body!), {'act': 'x', 'document_srl': 3});
    expect(sent.headers.keys, isNot(contains('Cookie')));
    expect(sent.headers['origin'], 'https://theqoo.net');
    expect(sent.headers['Content-Type'], contains('application/json'));
  });

  test('폼 본문은 urlencoded 로 옮긴다', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(response: ok('ok'));
    await _dio(adapter, fetcher, SiteFetchMode.auto).postUri<dynamic>(
      Uri.parse('https://theqoo.net/index.php'),
      data: {'a': '1', 'b': '가'},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    expect(fetcher.requests.single.body, 'a=1&b=%EA%B0%80');
  });

  test('웹뷰로도 통과 못 하면 ChallengeException 을 담아 실패', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(error: const ChallengeException('timeout'));
    await expectLater(
      _dio(adapter, fetcher, SiteFetchMode.auto).getUri<dynamic>(url),
      throwsA(
        isA<DioException>().having(
          (e) => e.error,
          'error',
          isA<ChallengeException>(),
        ),
      ),
    );
  });

  test('웹뷰 응답이 4xx 면 Dio 처럼 badResponse 로 실패', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(
      response: WebViewResponse(status: 404, url: url, body: 'nope'),
    );
    await expectLater(
      _dio(adapter, fetcher, SiteFetchMode.auto).getUri<dynamic>(url),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'status',
          404,
        ),
      ),
    );
  });

  test('바이트 응답은 손대지 않는다', () async {
    final adapter = _FakeAdapter(403, _challengeBody);
    final fetcher = _FakeFetcher(response: ok('ok'));
    await expectLater(
      _dio(adapter, fetcher, SiteFetchMode.auto).getUri<dynamic>(
        url,
        options: Options(responseType: ResponseType.bytes),
      ),
      throwsA(isA<DioException>()),
    );
    expect(fetcher.requests, isEmpty);
  });
}
