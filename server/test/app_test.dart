import 'dart:convert';
import 'dart:io';

import 'package:mocl_server/server.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('mocl_server_test');
    file = File('${dir.path}/remote_config.json');
  });

  tearDown(() => dir.deleteSync(recursive: true));

  void writeConfig(Map<String, Object?> json, {DateTime? modified}) {
    file.writeAsStringSync(jsonEncode(json));
    // 같은 초 안에 두 번 쓰면 수정 시각이 같을 수 있어 직접 옮긴다.
    if (modified != null) file.setLastModifiedSync(modified);
  }

  Future<Response> get(Handler handler, String path, {String? etag}) async =>
      await handler(
        Request(
          'GET',
          Uri.parse('http://localhost$path'),
          headers: {'if-none-match': ?etag},
        ),
      );

  ConfigStore store() =>
      ConfigStore(file, checkInterval: Duration.zero)..loadInitial();

  test('healthz', () async {
    writeConfig({'schemaVersion': 1});
    final Response response = await get(buildHandler(store()), '/healthz');
    expect(response.statusCode, 200);
  });

  test('설정을 JSON 과 ETag 로 내보내고, 같은 ETag 면 304', () async {
    writeConfig({
      'schemaVersion': 1,
      'sites': {
        'geekNews': {'userAgent': 'mobile'},
      },
    });
    final Handler handler = buildHandler(store());

    final Response first = await get(handler, '/v1/config');
    expect(first.statusCode, 200);
    expect(first.headers['content-type'], startsWith('application/json'));
    final Map<String, Object?> body =
        jsonDecode(await first.readAsString()) as Map<String, Object?>;
    expect(body['sites'], {
      'geekNews': {'userAgent': 'mobile'},
    });

    final String etag = first.headers['etag']!;
    final Response second = await get(handler, '/v1/config', etag: etag);
    expect(second.statusCode, 304);
  });

  test('파일이 바뀌면 다시 읽고, 깨진 파일이면 이전 설정을 유지한다', () async {
    final DateTime t0 = DateTime(2026, 1, 1);
    writeConfig({'schemaVersion': 1}, modified: t0);
    final Handler handler = buildHandler(store());
    final String etag0 = (await get(handler, '/v1/config')).headers['etag']!;

    writeConfig({
      'schemaVersion': 1,
      'userAgents': {'pc': 'Remote PC'},
    }, modified: t0.add(const Duration(minutes: 1)));
    final Response changed = await get(handler, '/v1/config');
    final String etag1 = changed.headers['etag']!;
    expect(etag1, isNot(etag0));

    // 모르는 사이트 → 엄격 검증 실패 → 직전 설정 유지
    writeConfig({
      'schemaVersion': 1,
      'sites': {'nope': <String, Object?>{}},
    }, modified: t0.add(const Duration(minutes: 2)));
    final Response kept = await get(handler, '/v1/config');
    expect(kept.headers['etag'], etag1);
  });

  test('처음부터 깨진 파일이면 서버가 뜨지 않는다', () {
    writeConfig({'schemaVersion': 99});
    expect(store, throwsFormatException);
  });

  test('없는 경로는 404', () async {
    writeConfig({'schemaVersion': 1});
    final Response response = await get(buildHandler(store()), '/nope');
    expect(response.statusCode, 404);
  });

  test('접속 로그 경로는 설치 id 를 가린다', () {
    expect(redactPath('v1/alerts/abcdef0123456789'), '/v1/alerts/***');
    expect(redactPath('v1/config'), '/v1/config');
    expect(redactPath('v1/issues/i_1234'), '/v1/issues/i_1234');
  });

  test('요청 제한은 IP 를 1분 넘게 들고 있지 않는다', () {
    DateTime now = DateTime(2026);
    final RateLimiter limiter = RateLimiter(clock: () => now);
    limiter.allow('1.1.1.1');
    limiter.allow('2.2.2.2');
    expect(limiter.trackedKeys, 2);
    now = now.add(const Duration(seconds: 61));
    limiter.allow('3.3.3.3');
    expect(limiter.trackedKeys, 1, reason: '지난 창의 IP 는 지워진다');
  });

  test('이슈 목록은 IP 별 요청 수를 제한한다', () async {
    writeConfig({'schemaVersion': 1});
    final RadarFeed feed = RadarFeed(
      RadarStore(await databaseFactoryMemory.openDatabase('issues_limit')),
    );
    final Handler handler = buildHandler(
      store(),
      radarFeed: feed,
      issueLimiter: RateLimiter(limit: 2),
    );
    // 아직 계산 전이라 503(warming_up) 이지만, 제한은 그보다 먼저 건다.
    expect((await get(handler, '/v1/issues')).statusCode, 503);
    expect((await get(handler, '/v1/issues/x')).statusCode, 404);
    expect((await get(handler, '/v1/issues')).statusCode, 429);
  });
}
