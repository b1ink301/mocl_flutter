import 'dart:convert';
import 'dart:io';

import 'package:mocl_server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

const String _token = 'test-admin-token-0123456789abcdef0123';

void main() {
  late Directory dir;
  late File file;
  late ConfigStore configs;
  late ConfigHistory history;
  late Handler handler;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('mocl_admin_test');
    file = File('${dir.path}/remote_config.json')
      ..writeAsStringSync('{"schemaVersion": 1}');
    configs = ConfigStore(file, checkInterval: Duration.zero)..loadInitial();
    history = ConfigHistory(Directory('${dir.path}/history'), keep: 3);
    handler = buildHandler(
      configs,
      admin: AdminRoutes(
        configs: configs,
        auth: AdminAuth.fromToken(_token)!,
        history: history,
        status: () async => {'crawl': null},
        failLimit: 3,
      ),
    );
  });

  tearDown(() => dir.deleteSync(recursive: true));

  Future<Response> call(
    String method,
    String path, {
    Object? body,
    String? token = _token,
    String ip = '1.1.1.1',
  }) async => await handler(
    Request(
      method,
      Uri.parse('http://localhost$path'),
      headers: {
        'authorization': ?(token == null ? null : 'Bearer $token'),
        'x-forwarded-for': ip,
      },
      body: body == null ? null : jsonEncode(body),
    ),
  );

  Future<Map<String, Object?>> json(Response r) async =>
      jsonDecode(await r.readAsString()) as Map<String, Object?>;

  test('짧거나 없는 토큰이면 관리 화면을 열지 않는다', () {
    expect(AdminAuth.fromToken(null), isNull);
    expect(AdminAuth.fromToken('short'), isNull);
    expect(AdminAuth.fromToken(_token), isNotNull);
  });

  test('화면은 토큰 없이 받지만 API 는 토큰이 필요하다', () async {
    final Response page = await call('GET', '/admin', token: null);
    expect(page.statusCode, 200);
    expect(page.headers['content-type'], startsWith('text/html'));
    expect(page.headers['cache-control'], 'no-store');
    expect(page.headers['x-frame-options'], 'DENY');

    expect(
      (await call('GET', '/admin/api/config', token: null)).statusCode,
      401,
    );
    expect(
      (await call('GET', '/admin/api/config', token: 'x' * 40)).statusCode,
      401,
    );
    expect((await call('GET', '/admin/api/config')).statusCode, 200);
  });

  test('토큰이 여러 번 틀리면 그 IP 는 잠시 막는다', () async {
    for (int i = 0; i < 3; i++) {
      expect(
        (await call(
          'GET',
          '/admin/api/config',
          token: 'bad' * 12,
          ip: '9.9.9.9',
        )).statusCode,
        401,
      );
    }
    // 맞는 토큰이어도 막힌다(무차별 대입 중에 맞혀도 알려 주지 않는다).
    expect(
      (await call('GET', '/admin/api/config', ip: '9.9.9.9')).statusCode,
      429,
    );
    // 다른 IP 는 그대로.
    expect(
      (await call('GET', '/admin/api/config', ip: '2.2.2.2')).statusCode,
      200,
    );
  });

  test('설정과 화면용 메타를 준다', () async {
    final Map<String, Object?> body = await json(
      await call('GET', '/admin/api/config'),
    );
    expect(body['text'], '{"schemaVersion": 1}');
    final Map<String, Object?> meta = body['meta'] as Map<String, Object?>;
    expect(meta['detailSizes'], containsAll(['compact', 'small', 'off']));
    expect(meta['sites'], contains('clien'));
    expect(meta['alertSites'], containsAll(['clien', 'damoang']));
    expect(meta['alertSites'], isNot(contains('ruliweb')));
    expect(
      (meta['defaults'] as Map<String, Object?>)['boards'],
      containsPair('clien', containsPair('park', '모두의공원')),
    );
  });

  test('검사는 문제를 모두 돌려준다', () async {
    final Map<String, Object?> body = await json(
      await call(
        'POST',
        '/admin/api/validate',
        body: {
          'text': jsonEncode({
            'schemaVersion': 1,
            'ads': {
              'detail': 'huge',
              'list': {'interval': 1},
            },
          }),
        },
      ),
    );
    expect(body['issues'], hasLength(2));
  });

  test('저장하면 바로 적용되고 이전본이 남는다', () async {
    final Map<String, Object?> before = await json(
      await call('GET', '/admin/api/config'),
    );
    final Response saved = await call(
      'PUT',
      '/admin/api/config',
      body: {
        'text': jsonEncode({
          'schemaVersion': 1,
          'ads': {'detail': 'medium'},
        }),
        'baseEtag': before['fileEtag'],
      },
    );
    expect(saved.statusCode, 200);
    expect(configs.current.config.ads.detail?.name, 'medium');
    expect(file.readAsStringSync(), contains('"detail": "medium"'));

    final Map<String, Object?> list = await json(
      await call('GET', '/admin/api/history'),
    );
    final List<Object?> items = list['items'] as List<Object?>;
    expect(items, hasLength(1));
    final String id = (items.single as Map)['id'] as String;
    final Map<String, Object?> item = await json(
      await call('GET', '/admin/api/history/$id'),
    );
    expect(item['text'], '{"schemaVersion": 1}');
  });

  test('잘못된 설정 · 다른 곳에서 바뀐 설정은 저장하지 않는다', () async {
    final Map<String, Object?> before = await json(
      await call('GET', '/admin/api/config'),
    );
    final Response invalid = await call(
      'PUT',
      '/admin/api/config',
      body: {
        'text': '{"schemaVersion": 1, "ads": {"detail": "huge"}}',
        'baseEtag': before['fileEtag'],
      },
    );
    expect(invalid.statusCode, 422);

    file.writeAsStringSync('{"schemaVersion": 1, "sites": {}}');
    final Response conflict = await call(
      'PUT',
      '/admin/api/config',
      body: {
        'text': '{"schemaVersion": 1, "ads": {"detail": "large"}}',
        'baseEtag': before['fileEtag'],
      },
    );
    expect(conflict.statusCode, 409);
    expect(file.readAsStringSync(), '{"schemaVersion": 1, "sites": {}}');
    expect(history.list(), isEmpty);
  });

  test('이력은 개수를 넘으면 오래된 것부터 지우고, 이상한 id 는 읽지 않는다', () {
    for (int i = 0; i < 5; i++) {
      history.add('v$i', 1700000000000 + i);
    }
    expect(history.list().map((e) => e.id), [
      '1700000000004',
      '1700000000003',
      '1700000000002',
    ]);
    expect(history.read('../remote_config'), isNull);
    expect(history.read('1700000000004'), 'v4');
  });
}
