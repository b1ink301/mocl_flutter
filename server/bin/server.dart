import 'dart:async';
import 'dart:io';

import 'package:mocl_server/server.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

/// 환경 변수
/// - `PORT`: 듣는 포트(기본 8080)
/// - `CONFIG_PATH`: 원격 설정 파일(기본 config/remote_config.json)
/// - `DATA_DIR`: 알림 DB 위치(기본 data)
/// - `FIREBASE_SERVICE_ACCOUNT`: FCM 발송용 서비스 계정 JSON 경로. 없으면 보내지 않고 로그만 남긴다.
Future<void> main() async {
  installServerLogging();
  final Map<String, String> env = Platform.environment;

  final int port = int.parse(env['PORT'] ?? '8080');
  final ConfigStore configs = ConfigStore(
    File(env['CONFIG_PATH'] ?? 'config/remote_config.json'),
  )..loadInitial();

  final String dataDir = env['DATA_DIR'] ?? 'data';
  await Directory(dataDir).create(recursive: true);
  final AlertStore alerts = AlertStore(
    await databaseFactoryIo.openDatabase('$dataDir/alerts.db'),
  );

  final PushSender push = await _pushSender(env['FIREBASE_SERVICE_ACCOUNT']);
  final SiteFetcher fetcher = SiteFetcher(
    remoteConfig: () => configs.current.config,
  );
  final AlertCrawler crawler = AlertCrawler(
    store: alerts,
    push: push,
    fetch: (sub) => fetcher.fetchList(
      sub.site,
      board: sub.board,
      url: sub.url,
      boardTitle: sub.title,
    ),
  )..start();

  final HttpServer server = await shelf_io.serve(
    buildHandler(configs, alerts: alerts, crawlStatus: () => crawler.status),
    InternetAddress.anyIPv4,
    port,
    poweredByHeader: null,
  );
  server.autoCompress = true;
  serverLog(
    '[boot] listening on :${server.port}, devices=${await alerts.deviceCount()}',
  );

  // docker stop 은 SIGTERM 을 보낸다. 처리 중인 요청을 마치고 내려간다.
  late final StreamSubscription<ProcessSignal> sigterm;
  late final StreamSubscription<ProcessSignal> sigint;
  Future<void> shutdown(ProcessSignal signal) async {
    serverLog('[boot] $signal, shutting down');
    await sigterm.cancel();
    await sigint.cancel();
    await crawler.stop();
    await server.close();
    fetcher.close();
    await push.close();
  }

  sigterm = ProcessSignal.sigterm.watch().listen(shutdown);
  sigint = ProcessSignal.sigint.watch().listen(shutdown);
}

Future<PushSender> _pushSender(String? serviceAccountPath) async {
  if (serviceAccountPath != null && File(serviceAccountPath).existsSync()) {
    final FcmPushSender sender = await FcmPushSender.fromServiceAccountFile(
      serviceAccountPath,
    );
    serverLog('[push] FCM 발송 사용');
    return sender;
  }
  serverLog('[push] 서비스 계정이 없어 발송하지 않는다(dry-run)', error: true);
  return DryRunPushSender();
}
