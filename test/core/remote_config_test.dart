import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/network/application/network_provider.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:mocl_flutter/features/remote_config/application/remote_config_providers.dart';
import 'package:mocl_flutter/features/remote_config/data/remote_config_fetcher.dart';
import 'package:mocl_flutter/features/remote_config/data/remote_config_store.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 요청을 기록하고 정해 둔 응답을 돌려주는 어댑터.
class _FakeAdapter(final ResponseBody Function(RequestOptions) respond)
    implements HttpClientAdapter {
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

const String _configBody =
    '{"schemaVersion":1,"userAgents":{"mobile":"Remote Mobile"},'
    '"sites":{"clien":{"userAgent":"mobile"}}}';

void main() {
  late SharedPreferences prefs;
  late RemoteConfigStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    store = RemoteConfigStore(prefs);
  });

  group('RemoteConfigStore', () {
    test('저장된 게 없으면 빈 설정', () {
      expect(store.load().isEmpty, isTrue);
      expect(store.etag, isNull);
    });

    test('저장한 설정과 ETag 를 다시 읽는다', () async {
      await store.save(_configBody, '"abc"');
      final RemoteConfig config = store.load();
      expect(config.userAgents[UserAgentPreset.mobile], 'Remote Mobile');
      expect(store.etag, '"abc"');
    });

    test('깨진 저장값은 버리고 빈 설정으로 뜬다', () async {
      await store.save('{not json', null);
      expect(store.load().isEmpty, isTrue);
      await store.save('{"schemaVersion":2}', null);
      expect(store.load().isEmpty, isTrue);
    });
  });

  group('RemoteConfigFetcher', () {
    Dio dioWith(_FakeAdapter adapter) => Dio()..httpClientAdapter = adapter;

    test('200 이면 저장하고, 다음 요청에 If-None-Match 를 싣는다', () async {
      final adapter = _FakeAdapter(
        (_) => ResponseBody.fromString(
          _configBody,
          200,
          headers: {
            'etag': ['"v1"'],
            'content-type': ['application/json'],
          },
        ),
      );
      final fetcher = RemoteConfigFetcher(
        dioWith(adapter),
        'https://api.test',
        store,
      );

      expect(await fetcher.refresh(), isTrue);
      expect(
        adapter.requests.single.uri.toString(),
        'https://api.test/v1/config',
      );
      expect(store.etag, '"v1"');

      await fetcher.refresh();
      expect(adapter.requests.last.headers['If-None-Match'], '"v1"');
    });

    test('304 면 저장된 설정을 그대로 둔다', () async {
      await store.save(_configBody, '"v1"');
      final adapter = _FakeAdapter((_) => ResponseBody.fromString('', 304));
      final fetcher = RemoteConfigFetcher(dioWith(adapter), 'https://x', store);

      expect(await fetcher.refresh(), isFalse);
      expect(store.load().userAgents[UserAgentPreset.mobile], 'Remote Mobile');
    });

    test('서버 오류 · 형식 오류는 조용히 넘기고 기존 설정을 지킨다', () async {
      await store.save(_configBody, '"v1"');
      for (final ResponseBody Function(RequestOptions) respond in [
        (_) => ResponseBody.fromString('oops', 500),
        (_) => ResponseBody.fromString('{"schemaVersion":9}', 200),
        (_) => throw DioException.connectionError(
          requestOptions: RequestOptions(),
          reason: 'offline',
        ),
      ]) {
        final fetcher = RemoteConfigFetcher(
          dioWith(_FakeAdapter(respond)),
          'https://x',
          store,
        );
        expect(await fetcher.refresh(), isFalse);
      }
      expect(store.etag, '"v1"');
      expect(store.load().userAgents[UserAgentPreset.mobile], 'Remote Mobile');
    });
  });

  group('사이트 클라이언트 UA', () {
    String uaOf(ProviderContainer c, SiteType site) => switch (site) {
      SiteType.clien => c.read(clienApiClientProvider).userAgent,
      SiteType.ppomppu => c.read(ppomppuApiClientProvider).userAgent,
      SiteType.reddit => c.read(redditApiClientProvider).userAgent,
      _ => throw UnimplementedError(),
    };

    test('원격 설정이 없으면 지금까지의 기본 UA 를 쓴다', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      expect(uaOf(c, SiteType.clien), userAgentPc);
      expect(uaOf(c, SiteType.ppomppu), userAgentMobile);
    });

    test('원격 설정의 프리셋 · 사이트별 값을 따른다', () {
      final c = ProviderContainer(
        overrides: [
          remoteConfigProvider.overrideWithValue(
            RemoteConfigStore.parse(_configBody),
          ),
        ],
      );
      addTearDown(c.dispose);
      expect(uaOf(c, SiteType.clien), 'Remote Mobile'); // 사이트별: pc → mobile
      expect(uaOf(c, SiteType.ppomppu), 'Remote Mobile'); // 프리셋 덮어쓰기
      expect(uaOf(c, SiteType.reddit), userAgentPc); // 그대로
    });
  });

  test('응답 본문 예시가 서버 JSON 과 같은 모양이다', () {
    // 서버(server/)는 RemoteConfig.toJson 을 그대로 내보낸다.
    final RemoteConfig parsed = RemoteConfigStore.parse(_configBody);
    expect(
      RemoteConfigStore.parse(jsonEncode(parsed.toJson())).toJson(),
      parsed.toJson(),
    );
  });
}
