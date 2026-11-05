import 'dart:convert';
import 'dart:io';

import 'package:mocl_server/server.dart';
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
}
