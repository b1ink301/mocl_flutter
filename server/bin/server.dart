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
/// - `ADMIN_TOKEN`: 관리 화면(`/admin`) 토큰(32자 이상). 없거나 짧으면 관리 화면을 열지 않는다.
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
  // 키워드 알림 · 레이더가 같은 게시판을 보면 한 번만 받는다.
  final BoardCache boards = BoardCache(fetcher.fetchList);
  final AlertCrawler crawler = AlertCrawler(
    store: alerts,
    push: push,
    ttl: () => configs.current.config.alerts.ttl,
    isAlertBoard: (site, board) =>
        configs.current.config.alerts.isAlertBoard(site, board),
    fetch: (sub) => boards.fetch(
      sub.site,
      board: sub.board,
      url: sub.url,
      boardTitle: sub.title,
    ),
  )..start();

  final RadarStore radarStore = RadarStore(
    await databaseFactoryIo.openDatabase('$dataDir/radar.db'),
  );
  final RadarFeed radarFeed = RadarFeed(radarStore);
  late final RadarCollector radar;
  radar = RadarCollector(
    store: radarStore,
    // 수집이 끝날 때마다 이슈 목록을 다시 계산해 둔다.
    onCollected: () => radarFeed.rebuild(
      DateTime.now().millisecondsSinceEpoch,
      failing: radar.failing,
    ),
    fetch: (b) =>
        boards.fetch(b.site, board: b.board, url: b.url, boardTitle: b.title),
  )..start();

  CrawlStatus crawlStatus() =>
      crawler.status.withRadar(radar.lastRunAt, radar.failing.length);

  final AdminAuth? adminAuth = AdminAuth.fromToken(env['ADMIN_TOKEN']);
  final AdminRoutes? admin = adminAuth == null
      ? null
      : AdminRoutes(
          configs: configs,
          auth: adminAuth,
          // 데이터 볼륨에 두어 매일 백업에 함께 묶인다.
          history: ConfigHistory(Directory('$dataDir/config-history')),
          status: () async => {
            'crawl': crawlStatus().toJson(
              DateTime.now().millisecondsSinceEpoch,
            ),
          },
        );
  serverLog(
    admin == null
        ? '[admin] ADMIN_TOKEN 이 없거나 ${AdminAuth.minLength}자 미만이라 관리 화면을 끈다'
        : '[admin] 관리 화면 사용(/admin)',
  );

  // 요청 제한용 IP 는 1분마다 비운다(요청이 없을 때도).
  final RateLimiter limiter = RateLimiter();
  // 이슈 목록은 앱이 탭을 열 때 · 복귀 때 받는다. 사람이 쓰는 양보다 넉넉하게.
  final RateLimiter issueLimiter = RateLimiter(limit: 120);
  final Timer pruneTimer = Timer.periodic(const Duration(minutes: 1), (_) {
    limiter.prune();
    issueLimiter.prune();
    admin?.prune();
  });

  final HttpServer server = await shelf_io.serve(
    buildHandler(
      configs,
      alerts: alerts,
      alertLimiter: limiter,
      validateToken: push is FcmPushSender ? push.validateToken : null,
      issueLimiter: issueLimiter,
      crawlStatus: crawlStatus,
      radarFeed: radarFeed,
      admin: admin,
    ),
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
    pruneTimer.cancel();
    await crawler.stop();
    await radar.stop();
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
