import 'dart:convert';
import 'dart:io';

import 'package:mocl_server/server.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

const String _install = 'install-0000000000000001';

Map<String, Object?> _reg({
  String token = 'tok-1',
  List<String> keywords = const ['에어팟'],
}) => {
  'fcmToken': token,
  'platform': 'android',
  'subscriptions': [
    {
      'site': 'ppomppu',
      'board': 'ppomppu',
      'url': 'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
      'title': '뽐뿌게시판',
      'keywords': keywords,
    },
  ],
};

ListItem _item(int id, String title) => ListItem.empty().copyWith(
  id: id,
  title: title,
  url: 'https://www.ppomppu.co.kr/zboard/view.php?id=ppomppu&no=$id',
);

/// 실패를 흉내 내는 발송기.
class _ScriptedSender(final PushResult result) implements PushSender {
  final List<PushMessage> sent = [];
  @override
  Future<PushResult> send(PushMessage message) async {
    sent.add(message);
    return result;
  }

  @override
  Future<void> close() async {}
}

void main() {
  late AlertStore store;
  late Directory dir;
  late ConfigStore configs;

  setUp(() async {
    store = AlertStore(
      await databaseFactoryMemory.openDatabase(
        't${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
    dir = Directory.systemTemp.createTempSync('alerts_test');
    File('${dir.path}/c.json').writeAsStringSync('{"schemaVersion":1}');
    configs = ConfigStore(File('${dir.path}/c.json'))..loadInitial();
  });
  tearDown(() => dir.deleteSync(recursive: true));

  group('API', () {
    Future<Response> call(
      Handler h,
      String method,
      String path, {
      Object? body,
      String ip = '1.1.1.1',
    }) async => await h(
      Request(
        method,
        Uri.parse('http://localhost$path'),
        body: body == null ? null : jsonEncode(body),
        headers: {'x-forwarded-for': ip},
      ),
    );

    test('등록 · 덮어쓰기 · 삭제', () async {
      final Handler h = buildHandler(configs, alerts: store);
      expect(
        (await call(h, 'PUT', '/v1/alerts/$_install', body: _reg())).statusCode,
        204,
      );
      expect((await store.devices()).single.registration.fcmToken, 'tok-1');

      await call(h, 'PUT', '/v1/alerts/$_install', body: _reg(token: 'tok-2'));
      expect((await store.devices()).single.registration.fcmToken, 'tok-2');

      expect((await call(h, 'DELETE', '/v1/alerts/$_install')).statusCode, 204);
      expect(await store.devices(), isEmpty);
    });

    test('구독이 비면 등록을 지운다', () async {
      final Handler h = buildHandler(configs, alerts: store);
      await call(h, 'PUT', '/v1/alerts/$_install', body: _reg());
      await call(
        h,
        'PUT',
        '/v1/alerts/$_install',
        body: {..._reg(), 'subscriptions': <Object>[]},
      );
      expect(await store.devices(), isEmpty);
    });

    test('잘못된 id · 본문은 400', () async {
      final Handler h = buildHandler(configs, alerts: store);
      expect(
        (await call(h, 'PUT', '/v1/alerts/short', body: _reg())).statusCode,
        400,
      );
      final Response bad = await call(
        h,
        'PUT',
        '/v1/alerts/$_install',
        body: {..._reg(), 'platform': 'web'},
      );
      expect(bad.statusCode, 400);
      expect(await bad.readAsString(), contains('invalid'));
    });

    test('같은 FCM 토큰은 한 기기만 갖는다(재설치)', () async {
      final Handler h = buildHandler(configs, alerts: store);
      await call(h, 'PUT', '/v1/alerts/$_install', body: _reg());
      await call(h, 'PUT', '/v1/alerts/install-0000000000000002', body: _reg());
      expect(
        (await store.devices()).single.installId,
        'install-0000000000000002',
      );
    });

    test('IP 별 요청 수를 제한한다', () async {
      final Handler h = buildHandler(
        configs,
        alerts: store,
        alertLimiter: RateLimiter(limit: 2),
      );
      for (int i = 0; i < 2; i++) {
        expect(
          (await call(h, 'DELETE', '/v1/alerts/$_install')).statusCode,
          204,
        );
      }
      expect((await call(h, 'DELETE', '/v1/alerts/$_install')).statusCode, 429);
      expect(
        (await call(
          h,
          'DELETE',
          '/v1/alerts/$_install',
          ip: '2.2.2.2',
        )).statusCode,
        204,
      );
    });
  });

  group('AlertCrawler', () {
    late List<ListItem> page;
    late int fetches;
    Object? failWith;

    AlertCrawler crawler(PushSender push) => AlertCrawler(
      store: store,
      push: push,
      politeDelay: Duration.zero,
      interval: const Duration(minutes: 3),
      fetch: (AlertSubscription sub) async {
        fetches++;
        if (failWith != null) throw failWith!;
        return page;
      },
    );

    setUp(() async {
      page = [_item(1, '옛 글 에어팟')];
      fetches = 0;
      failWith = null;
      await store.putDevice(
        _install,
        AlertRegistration.fromJson(_reg(keywords: ['에어팟', '갤럭시'])),
        0,
      );
    });

    test('첫 크롤은 기록만 하고, 이후 새 글 중 키워드가 맞는 것만 알린다', () async {
      final DryRunPushSender push = DryRunPushSender();
      final AlertCrawler c = crawler(push);
      const int t0 = 1000000;

      await c.tick(t0);
      expect(push.sent, isEmpty);

      page = [
        _item(3, '[쿠팡] 에어팟 프로 2'),
        _item(2, '[G마켓] 라면 박스'),
        _item(1, '옛 글 에어팟'),
      ];
      await c.tick(t0 + 60 * 1000); // 간격 전 → 받지 않음
      expect(fetches, 1);

      await c.tick(t0 + 3 * 60 * 1000);
      expect(fetches, 2);
      final PushMessage m = push.sent.single;
      expect(m.title, '뽐뿌게시판 · 에어팟');
      expect(m.body, '[쿠팡] 에어팟 프로 2');
      expect(m.token, 'tok-1');
      expect(m.data['type'], KeywordAlertPayload.type);
      expect(m.data['url'], contains('no=3'));
      expect(m.collapseKey, 'ppomppu-3');

      // 같은 글은 다시 알리지 않는다
      await c.tick(t0 + 6 * 60 * 1000);
      expect(push.sent, hasLength(1));
    });

    test('실패하면 간격을 늘린다', () async {
      final AlertCrawler c = crawler(DryRunPushSender());
      failWith = const FetchFailure('HTTP', statusCode: 403);
      const int t0 = 1000000;
      await c.tick(t0);
      expect((await store.boardState('ppomppu|ppomppu')).failures, 1);

      await c.tick(t0 + 3 * 60 * 1000); // 기본 간격이면 받았겠지만 실패 1회 → 6분
      expect(fetches, 1);
      await c.tick(t0 + 6 * 60 * 1000);
      expect(fetches, 2);
    });

    test('토큰이 무효면 기기 등록을 지운다', () async {
      final _ScriptedSender push = _ScriptedSender(PushResult.invalidToken);
      final AlertCrawler c = crawler(push);
      await c.tick(0);
      page = [_item(9, '갤럭시 탭'), _item(8, '에어팟 맥스')];
      await c.tick(3 * 60 * 1000);
      expect(push.sent, hasLength(1), reason: '지운 기기에는 더 보내지 않는다');
      expect(await store.devices(), isEmpty);
    });

    group('기한', () {
      const int day = 24 * 60 * 60 * 1000;
      Duration? ttl = const Duration(days: 3);

      AlertCrawler withTtl(PushSender push) => AlertCrawler(
        store: store,
        push: push,
        politeDelay: Duration.zero,
        ttl: () => ttl,
        fetch: (AlertSubscription sub) async {
          fetches++;
          return page;
        },
      );

      Future<void> register({int? startedAt, required int updatedAt}) =>
          store.putDevice(
            _install,
            AlertRegistration.fromJson({
              ..._reg(),
              'subscriptions': [
                {
                  ...(_reg()['subscriptions']! as List).single as Map,
                  'startedAt': ?startedAt,
                },
              ],
            }),
            updatedAt,
          );

      setUp(() => ttl = const Duration(days: 3));

      test('기한이 지난 구독은 보지 않고 게시판 상태도 지운다', () async {
        await register(startedAt: 0, updatedAt: 0);
        final AlertCrawler c = withTtl(DryRunPushSender());
        await c.tick(3 * day - 1);
        expect(fetches, 1);
        await c.tick(3 * day);
        expect(fetches, 1);
        expect(c.status.boards, 0);
        expect(c.status.expiredSubscriptions, 1);
        expect((await store.boardState('ppomppu|ppomppu')).isSeeded, isFalse);
      });

      test('기한 없음(0일)이면 계속 본다', () async {
        await register(startedAt: 0, updatedAt: 0);
        ttl = null;
        final AlertCrawler c = withTtl(DryRunPushSender());
        await c.tick(100 * day);
        expect(fetches, 1);
      });

      test('startedAt 이 없거나(옛 앱) 서버 시각보다 앞서면 등록 시각으로 센다', () async {
        await register(updatedAt: 10 * day);
        final AlertCrawler c = withTtl(DryRunPushSender());
        await c.tick(12 * day);
        expect(fetches, 1, reason: '등록 시각부터 2일');
        await c.tick(13 * day);
        expect(fetches, 1);

        await register(startedAt: 100 * day, updatedAt: 20 * day);
        await c.tick(23 * day);
        expect(fetches, 1, reason: '기기 시계가 앞서도 기한을 미래로 늘리지 못한다');
      });
    });

    test('구독자가 없어진 게시판 상태는 지운다', () async {
      final AlertCrawler c = crawler(DryRunPushSender());
      await c.tick(0);
      expect((await store.boardState('ppomppu|ppomppu')).isSeeded, isTrue);
      await store.deleteDevice(_install);
      await c.tick(1);
      expect((await store.boardState('ppomppu|ppomppu')).isSeeded, isFalse);
    });
  });

  test('뽐뿌 RSS 를 목록 항목으로 읽는다', () {
    const String rss = '''<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0"><channel><title>뽐뿌</title>
<item>
<title>[롯데온] 라인바싸 탄산수 500ml (13,940원/무료)</title>
<link>http://www.ppomppu.co.kr/zboard/view.php?id=ppomppu&amp;no=746159</link>
<author>애옹이10</author>
<pubDate>Thu, 05 Nov 2026 05:49:54 GMT</pubDate>
</item>
<item><title>링크 없음</title></item>
</channel></rss>''';
    final List<ListItem> items = SiteFetcher.parsePpomppuRss(
      rss,
      board: 'ppomppu',
    );
    expect(items, hasLength(1));
    expect(items.single.id, 746159);
    expect(
      items.single.url,
      'https://www.ppomppu.co.kr/zboard/view.php?id=ppomppu&no=746159',
    );
    expect(items.single.userInfo.nickName, '애옹이10');
  });

  test('/healthz/crawl 은 크롤러가 멈추면 503', () async {
    CrawlStatus status = const CrawlStatus();
    final Handler h = buildHandler(configs, crawlStatus: () => status);
    Future<int> code() async =>
        (await h(Request('GET', Uri.parse('http://localhost/healthz/crawl'))))
            .statusCode;

    expect(await code(), 503, reason: '아직 한 바퀴도 안 돌았다');
    status = CrawlStatus(
      lastTickAt: DateTime.now().millisecondsSinceEpoch,
      boards: 2,
    );
    expect(await code(), 200);
    status = CrawlStatus(
      lastTickAt: DateTime.now()
          .subtract(const Duration(minutes: 11))
          .millisecondsSinceEpoch,
    );
    expect(await code(), 503);
  });

  test('크롤러는 한 바퀴마다 상태를 남긴다', () async {
    await store.putDevice(_install, AlertRegistration.fromJson(_reg()), 0);
    final AlertCrawler c = AlertCrawler(
      store: store,
      push: DryRunPushSender(),
      politeDelay: Duration.zero,
      fetch: (_) async => throw const FetchFailure('HTTP', statusCode: 403),
    );
    await c.tick(1000);
    expect(c.status.lastTickAt, 1000);
    expect(c.status.boards, 1);
    expect(c.status.failingBoards, 1);
    expect(c.status.devices, 1);
  });
}
