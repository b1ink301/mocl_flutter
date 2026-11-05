import 'dart:async';
import 'dart:io';

import 'package:mocl_server/server.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// 환경 변수
/// - `PORT`: 듣는 포트(기본 8080)
/// - `CONFIG_PATH`: 원격 설정 파일(기본 config/remote_config.json)
Future<void> main() async {
  installServerLogging();

  final int port = int.parse(Platform.environment['PORT'] ?? '8080');
  final String configPath =
      Platform.environment['CONFIG_PATH'] ?? 'config/remote_config.json';

  final ConfigStore configs = ConfigStore(File(configPath))..loadInitial();

  final HttpServer server = await shelf_io.serve(
    buildHandler(configs),
    InternetAddress.anyIPv4,
    port,
    poweredByHeader: null,
  );
  server.autoCompress = true;
  serverLog('[boot] listening on :${server.port}');

  // docker stop 은 SIGTERM 을 보낸다. 처리 중인 요청을 마치고 내려간다.
  late final StreamSubscription<ProcessSignal> sigterm;
  late final StreamSubscription<ProcessSignal> sigint;
  Future<void> shutdown(ProcessSignal signal) async {
    serverLog('[boot] $signal, shutting down');
    await sigterm.cancel();
    await sigint.cancel();
    await server.close();
  }

  sigterm = ProcessSignal.sigterm.watch().listen(shutdown);
  sigint = ProcessSignal.sigint.watch().listen(shutdown);
}
