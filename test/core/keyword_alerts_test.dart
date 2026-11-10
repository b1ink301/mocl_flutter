import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_store.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAdapter(final int status) implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  final List<String> bodies = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream != null) {
      bodies.add(utf8.decode(await requestStream.expand((c) => c).toList()));
    }
    return ResponseBody.fromString('', status);
  }

  @override
  void close({bool force = false}) {}
}

class _FakeMessaging(final String? _token) implements PushMessaging {
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<String?> token() async => _token;
  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
  @override
  Future<PushTap?> initialTap() async => null;
  @override
  Stream<PushTap> get onTap => const Stream.empty();
  @override
  Stream<PushTap> get onForeground => const Stream.empty();
}

const AlertSubscription _sub = AlertSubscription(
  site: SiteType.ppomppu,
  board: 'ppomppu',
  url: 'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
  title: '뽐뿌게시판',
  keywords: ['에어팟'],
);

void main() {
  late KeywordAlertStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = KeywordAlertStore(await SharedPreferences.getInstance());
  });

  KeywordAlertSync syncWith(
    _FakeAdapter adapter, {
    String? token = 'tok',
    String baseUrl = 'https://api.test',
  }) => KeywordAlertSync(
    Dio()..httpClientAdapter = adapter,
    baseUrl,
    store,
    _FakeMessaging(token),
    'android',
  );

  test('설치 id 는 한 번 만들면 그대로다', () {
    final String id = store.installId();
    expect(id, hasLength(32));
    expect(store.installId(), id);
  });

  test('구독을 저장하고 다시 읽는다', () async {
    await store.saveSubscriptions([_sub]);
    expect(store.subscriptions().single.toJson(), _sub.toJson());
  });

  test('구독을 통째로 PUT 하고, 바뀌지 않았으면 다시 보내지 않는다', () async {
    await store.saveSubscriptions([_sub]);
    final adapter = _FakeAdapter(204);
    final sync = syncWith(adapter);

    expect(await sync.sync(), AlertSyncResult.synced);
    expect(adapter.requests.single.method, 'PUT');
    expect(
      adapter.requests.single.uri.toString(),
      'https://api.test/v1/alerts/${store.installId()}',
    );
    final Map<String, Object?> body =
        jsonDecode(adapter.bodies.single) as Map<String, Object?>;
    expect(body['fcmToken'], 'tok');
    expect(
      AlertRegistration.fromJson(body).subscriptions.single.board,
      'ppomppu',
    );

    await sync.sync();
    expect(adapter.requests, hasLength(1));
    await sync.sync(force: true);
    expect(adapter.requests, hasLength(2));
  });

  test('허용 게시판이 아닌 구독은 올리지 않고, 다시 허용되면 올린다', () async {
    final AlertSubscription other = AlertSubscription(
      site: SiteType.clien,
      board: 'bug',
      url: 'https://m.clien.net/service/board/bug',
      title: '버그신고',
      keywords: const ['에어팟'],
    );
    await store.saveSubscriptions([other, _sub]);
    final adapter = _FakeAdapter(204);
    bool allowBug = false;
    KeywordAlertSync sync() => KeywordAlertSync(
      Dio()..httpClientAdapter = adapter,
      'https://api.test',
      store,
      _FakeMessaging('tok'),
      'android',
      isAlertBoard: (site, board) => board == 'ppomppu' || allowBug,
    );

    expect(await sync().sync(), AlertSyncResult.synced);
    expect(
      AlertRegistration.fromJson(jsonDecode(adapter.bodies.single))
          .subscriptions
          .map((s) => s.board),
      ['ppomppu'],
    );

    allowBug = true;
    await sync().sync();
    expect(adapter.requests, hasLength(2));
    expect(
      AlertRegistration.fromJson(jsonDecode(adapter.bodies.last)).subscriptions
          .map((s) => s.board),
      ['bug', 'ppomppu'],
    );
  });

  test('허용 게시판이 하나도 없으면 서버 등록을 지운다', () async {
    await store.saveSubscriptions([_sub]);
    final adapter = _FakeAdapter(204);
    await syncWith(adapter).sync();
    final KeywordAlertSync none = KeywordAlertSync(
      Dio()..httpClientAdapter = adapter,
      'https://api.test',
      store,
      _FakeMessaging('tok'),
      'android',
      isAlertBoard: (_, _) => false,
    );
    await none.sync();
    expect(adapter.requests.last.method, 'DELETE');
  });

  test('구독을 다 지우면 서버 등록을 DELETE 한다(등록한 적 있을 때만)', () async {
    final adapter = _FakeAdapter(204);
    final sync = syncWith(adapter);
    await sync.sync();
    expect(adapter.requests, isEmpty, reason: '등록한 적 없으면 요청하지 않는다');

    await store.saveSubscriptions([_sub]);
    await sync.sync();
    await store.saveSubscriptions([]);
    await sync.sync();
    expect(adapter.requests.last.method, 'DELETE');
    expect(store.syncedSignature, isNull);
  });

  test('서버 오류면 failed 이고 다음에 다시 보낸다', () async {
    await store.saveSubscriptions([_sub]);
    expect(await syncWith(_FakeAdapter(500)).sync(), AlertSyncResult.failed);
    expect(store.syncedSignature, isNull);
    final adapter = _FakeAdapter(204);
    await syncWith(adapter).sync();
    expect(adapter.requests, hasLength(1));
  });

  test('토큰이 없거나 서버 주소가 없으면 보내지 않는다', () async {
    await store.saveSubscriptions([_sub]);
    final adapter = _FakeAdapter(204);
    expect(
      await syncWith(adapter, token: null).sync(),
      AlertSyncResult.noToken,
    );
    expect(
      await syncWith(adapter, baseUrl: '').sync(),
      AlertSyncResult.noServer,
    );
    expect(adapter.requests, isEmpty);
  });
}
