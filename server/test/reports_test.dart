import 'dart:convert';
import 'dart:io';

import 'package:mocl_server/server.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

const String _token = 'test-admin-token-0123456789abcdef0123';

class _Recorder() implements OpsNotifier {
  final List<OpsAlert> sent = [];
  @override
  Future<void> send(OpsAlert alert) async => sent.add(alert);
}

SiteReport _auto({SiteType site = SiteType.clien}) => SiteReport(
  kind: SiteReportKind.auto,
  reason: SiteReportReason.listParse,
  appVersion: '1.6.4+412',
  platform: 'android',
  site: site,
  board: 'park',
);

SiteReport _user({SiteType? site = SiteType.clien, String? message}) =>
    SiteReport(
      kind: SiteReportKind.user,
      reason: SiteReportReason.comments,
      appVersion: '1.6.4+412',
      platform: 'android',
      site: site,
      url: 'https://m.clien.net/service/board/park/1',
      message: message,
    );

const int _min = 60 * 1000;

void main() {
  group('POST /v1/reports', () {
    late Directory dir;
    late ReportStore store;
    late _Recorder recorder;
    late Handler handler;

    setUp(() async {
      dir = Directory.systemTemp.createTempSync('mocl_reports_test');
      final File file = File('${dir.path}/remote_config.json')
        ..writeAsStringSync('{"schemaVersion": 1}');
      final ConfigStore configs = ConfigStore(
        file,
        checkInterval: Duration.zero,
      )..loadInitial();
      store = ReportStore(
        await databaseFactoryMemory.openDatabase('reports.db'),
      );
      recorder = _Recorder();
      handler = buildHandler(
        configs,
        reports: store,
        reportLimiter: RateLimiter(limit: 3),
        reportAlerter: ReportAlerter(notifier: recorder),
        admin: AdminRoutes(
          configs: configs,
          auth: AdminAuth.fromToken(_token)!,
          history: ConfigHistory(Directory('${dir.path}/history')),
          reports: store,
        ),
      );
    });

    tearDown(() async {
      await databaseFactoryMemory.deleteDatabase('reports.db');
      dir.deleteSync(recursive: true);
    });

    Future<Response> post(Object? body) async => await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/reports'),
        body: body is String ? body : jsonEncode(body),
        headers: {'x-forwarded-for': '1.2.3.4'},
      ),
    );

    Future<Map<String, Object?>> admin(String method, String path) async {
      final Response response = await handler(
        Request(
          method,
          Uri.parse('http://localhost/admin/api$path'),
          headers: {'authorization': 'Bearer $_token'},
        ),
      );
      expect(response.statusCode, 200);
      return jsonDecode(await response.readAsString()) as Map<String, Object?>;
    }

    test('받아 저장하고 사용자 제보는 바로 알린다', () async {
      final Response response = await post(_user(message: '댓글이 없어요').toJson());
      expect(response.statusCode, 204);
      expect(await store.count(), 1);
      await Future<void>.delayed(Duration.zero);
      expect(recorder.sent, hasLength(1));
      expect(recorder.sent.single.title, contains('클리앙'));
      expect(recorder.sent.single.body, contains('댓글이 없어요'));
    });

    test('잘못된 신고 · 큰 본문은 거절한다', () async {
      expect((await post({'kind': 'auto'})).statusCode, 400);
      expect((await post('not json')).statusCode, 400);
      expect((await post('x' * 5000)).statusCode, 413);
      expect(await store.count(), 0);
    });

    test('IP 당 요청 수를 제한한다', () async {
      for (int i = 0; i < 3; i++) {
        expect((await post(_auto().toJson())).statusCode, 204);
      }
      expect((await post(_auto().toJson())).statusCode, 429);
    });

    test('관리 API 가 목록 · 사이트별 건수를 주고 확인함을 표시한다', () async {
      await post(_user().toJson());
      await post(_auto(site: SiteType.ppomppu).toJson());
      Map<String, Object?> data = await admin('GET', '/reports');
      final List<Object?> items = data['items']! as List<Object?>;
      expect(items, hasLength(2));
      expect(data['bySite24h'], {'clien': 1, 'ppomppu': 1});

      final int id = (items.first! as Map<String, Object?>)['id']! as int;
      await admin('POST', '/reports/$id/ack');
      data = await admin('GET', '/reports');
      expect(data['items'], hasLength(1));
      data = await admin('GET', '/reports?all=1');
      expect(data['items'], hasLength(2));
    });

    test('관리 API 는 토큰이 필요하다', () async {
      final Response response = await handler(
        Request('GET', Uri.parse('http://localhost/admin/api/reports')),
      );
      expect(response.statusCode, 401);
    });
  });

  group('ReportAlerter', () {
    test('사용자 제보는 사이트마다 10분에 한 번, 나머지는 묶어 보낸다', () async {
      final _Recorder r = _Recorder();
      final ReportAlerter alerter = ReportAlerter(notifier: r);
      await alerter.onReport(_user(), 0);
      await alerter.onReport(_user(), 1 * _min);
      await alerter.onReport(_user(), 2 * _min);
      // 다른 사이트는 따로 센다.
      await alerter.onReport(_user(site: SiteType.damoang), 2 * _min);
      expect(r.sent, hasLength(2));

      await alerter.flush(5 * _min); // 아직 10분 안 됨
      expect(r.sent, hasLength(2));
      await alerter.flush(10 * _min);
      expect(r.sent, hasLength(3));
      expect(r.sent.last.body, contains('외 1건'));
      await alerter.flush(30 * _min); // 더 보낼 것 없음
      expect(r.sent, hasLength(3));
    });

    test('자동 신고는 1시간 안 5건부터 한 번, 6시간 동안 다시 알리지 않는다', () async {
      final _Recorder r = _Recorder();
      final ReportAlerter alerter = ReportAlerter(notifier: r);
      for (int i = 0; i < 4; i++) {
        await alerter.onReport(_auto(), i * _min);
      }
      expect(r.sent, isEmpty);
      await alerter.onReport(_auto(), 5 * _min);
      expect(r.sent, hasLength(1));
      expect(r.sent.single.urgent, isTrue);
      expect(r.sent.single.title, contains('클리앙'));

      for (int i = 0; i < 10; i++) {
        await alerter.onReport(_auto(), (10 + i) * _min);
      }
      expect(r.sent, hasLength(1));

      // 6시간 뒤 다시 5건이 모이면 또 알린다.
      for (int i = 0; i < 5; i++) {
        await alerter.onReport(_auto(), 7 * 60 * _min + i * _min);
      }
      expect(r.sent, hasLength(2));
    });

    test('1시간 넘게 흩어진 자동 신고는 알리지 않는다', () async {
      final _Recorder r = _Recorder();
      final ReportAlerter alerter = ReportAlerter(notifier: r);
      for (int i = 0; i < 10; i++) {
        await alerter.onReport(_auto(), i * 20 * _min);
      }
      expect(r.sent, isEmpty);
    });
  });

  test('ReportStore 는 오래된 신고 · 상한을 넘는 신고를 지운다', () async {
    final ReportStore store = ReportStore(
      await databaseFactoryMemory.openDatabase('prune.db'),
      keep: const Duration(days: 1),
      maxReports: 3,
    );
    const int day = 24 * 60 * _min;
    await store.add(_auto(), 0);
    for (int i = 0; i < 4; i++) {
      await store.add(_auto(), 2 * day + i);
    }
    await store.prune(2 * day + 10);
    expect(await store.count(), 3);
    await databaseFactoryMemory.deleteDatabase('prune.db');
  });
}
