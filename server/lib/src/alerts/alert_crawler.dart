import 'dart:async';
import 'dart:math';

import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/alerts_config.dart';

import '../crawl/site_fetcher.dart';
import '../server_log.dart';
import 'alert_store.dart';
import 'push_sender.dart';

typedef BoardFetch = Future<List<ListItem>> Function(AlertSubscription board);

/// 크롤러 상태(감시용 `/healthz/crawl`).
class const CrawlStatus({
  /// 마지막으로 한 바퀴를 끝낸 시각(ms). 0 이면 아직 없다.
  final int lastTickAt = 0,
  final int boards = 0,

  /// 마지막 시도가 실패한 게시판 수.
  final int failingBoards = 0,
  final int devices = 0,

  /// 기한이 지나 보지 않는 구독 수.
  final int expiredSubscriptions = 0,

  /// 사이트별 상한([AlertCrawler.maxBoardsPerSite])에 걸려 이번 바퀴에 보지 않은 게시판 수.
  final int skippedBoards = 0,

  /// 허용 게시판(원격 설정 `alerts.boards`)이 아니라 보지 않는 구독 수(옛 앱 · 목록에서 뺀 게시판).
  final int disallowedSubscriptions = 0,

  /// 이슈 레이더 수집(없으면 0).
  final int radarLastRunAt = 0,
  final int radarFailingBoards = 0,
}) {
  Map<String, Object?> toJson(int now) => {
    'lastTickAgoSec': lastTickAt == 0 ? null : (now - lastTickAt) ~/ 1000,
    'boards': boards,
    'failingBoards': failingBoards + radarFailingBoards,
    'devices': devices,
    'expiredSubscriptions': expiredSubscriptions,
    'skippedBoards': skippedBoards,
    'disallowedSubscriptions': disallowedSubscriptions,
    'radarLastRunAgoSec': radarLastRunAt == 0
        ? null
        : (now - radarLastRunAt) ~/ 1000,
  };

  CrawlStatus withRadar(int lastRunAt, int failing) => CrawlStatus(
    lastTickAt: lastTickAt,
    boards: boards,
    failingBoards: failingBoards,
    devices: devices,
    expiredSubscriptions: expiredSubscriptions,
    skippedBoards: skippedBoards,
    disallowedSubscriptions: disallowedSubscriptions,
    radarLastRunAt: lastRunAt,
    radarFailingBoards: failing,
  );
}

/// 구독된 게시판을 돌며 새 글을 찾아 키워드가 맞는 기기에 알린다.
///
/// - 같은 게시판은 구독자가 몇 명이든 한 번만 받는다(사이트 부담 = 게시판 수).
/// - 사이트끼리는 동시에, 한 사이트 안에서는 [politeDelay] 를 두고 차례로 받는다.
///   사이트 하나가 받는 요청 간격은 그대로이고 처리량은 사이트 수만큼 늘어난다.
/// - 사이트마다 [maxBoardsPerSite] 개까지만 본다(구독자가 많은 게시판부터). 한 바퀴가
///   [interval] 안에 끝나게 하는 상한이자, 가짜 등록으로 게시판을 늘리는 남용을 막는다.
/// - 게시판 첫 크롤은 지금 있는 글을 "본 것" 으로 기록만 한다(옛 글로 알림 폭탄 X).
/// - 실패하면 간격을 늘린다(최대 [maxBackoff]). 차단당했을 때 계속 두드리지 않는다.
/// - 허용 게시판([isAlertBoard], 원격 설정 `alerts.boards`)이 아닌 구독은 보지 않는다.
/// - 기한([ttl], 원격 설정 `alerts.ttlDays`)이 지난 구독은 보지 않는다. 구독이 모두 끝난
///   게시판은 받지 않고 상태도 지운다(연장하면 첫 크롤부터 다시).
/// - 구독이 모두 끝나고 [staleGrace] 가 더 지난 기기는 등록을 지운다(앱을 지운 기기가
///   [AlertStore.maxDevices] 자리를 계속 차지하지 않게). 앱에서 다시 켜면 새로 등록된다.
/// - 알림은 기기마다 차례로, 기기끼리는 [pushConcurrency] 대까지 동시에 보낸다.
class AlertCrawler({
  required final AlertStore store,
  required final BoardFetch fetch,
  required final PushSender push,
  final Duration interval = const Duration(minutes: 3),
  final Duration maxBackoff = const Duration(minutes: 60),

  /// 같은 사이트 안에서 게시판 사이 쉬는 시간. 사이트에 몰아서 요청하지 않는다.
  final Duration politeDelay = const Duration(milliseconds: 1500),

  /// 한 번에 알릴 새 글 상한(게시판당). 처음 보는 대량 갱신에 폭주하지 않게.
  final int maxNewPerBoard = 30,

  /// 사이트마다 볼 게시판 상한. 게시판 하나에 2~3초(받기 + [politeDelay])라
  /// 60개면 한 사이트가 [interval](3분) 안에 한 바퀴를 돈다.
  final int maxBoardsPerSite = 60,

  /// 동시에 알림을 보낼 기기 수(FCM HTTP 요청 수).
  final int pushConcurrency = 16,

  /// 기한이 끝난 기기 등록을 지우기까지 기다리는 시간.
  final Duration staleGrace = const Duration(days: 7),

  /// 알림 기한. null 이면 기한 없음. 관리 화면에서 바꾸면 다음 바퀴부터 따른다.
  final Duration? Function() ttl = _defaultTtl,

  /// 알림을 걸 수 있는 게시판인지(원격 설정 `alerts.boards`). 관리 화면에서 바꾸면 다음 바퀴부터 따른다.
  /// 허용 밖 구독은 보지 않는다 — 옛 앱은 아무 게시판에나 걸 수 있었다.
  final bool Function(SiteType site, String board) isAlertBoard =
      _defaultIsAlertBoard,
}) {
  static Duration? _defaultTtl() => AlertsRemoteConfig.empty.ttl;
  static bool _defaultIsAlertBoard(SiteType site, String board) =>
      AlertsRemoteConfig.empty.isAlertBoard(site, board);

  /// 구독이 시작된 시각. 앱이 준 값이 없거나(옛 앱) 기기 시계가 앞서 있으면
  /// 서버가 등록을 받은 시각으로 센다(기한을 미래로 늘릴 수 없게).
  static int startedAtOf(Device device, AlertSubscription sub) {
    final int? started = sub.startedAt;
    return started == null || started > device.updatedAt
        ? device.updatedAt
        : started;
  }

  Timer? _timer;
  bool _running = false;
  late final _Slots _pushSlots = _Slots(max(1, pushConcurrency));

  /// 마지막 한 바퀴의 상태.
  CrawlStatus status = const CrawlStatus();

  void start({Duration every = const Duration(seconds: 30)}) {
    _timer ??= Timer.periodic(every, (_) => unawaited(_guardedTick()));
    unawaited(_guardedTick());
  }

  Future<void> stop() async => _timer?.cancel();

  Future<void> _guardedTick() async {
    if (_running) return;
    _running = true;
    try {
      await tick(DateTime.now().millisecondsSinceEpoch);
    } catch (e, st) {
      serverLog('[crawl] tick 실패: $e\n$st', error: true);
    } finally {
      _running = false;
    }
  }

  Duration _delayFor(BoardState state) {
    if (state.failures == 0) return interval;
    final int factor = 1 << min(state.failures, 6);
    final Duration backoff = interval * factor;
    return backoff > maxBackoff ? maxBackoff : backoff;
  }

  /// 한 바퀴. 테스트는 이 함수를 직접 부른다.
  Future<void> tick(int now) async {
    final List<Device> devices = await store.devices();

    // 게시판별 구독자 묶기
    final Map<String, AlertSubscription> boards = {};
    final Map<String, List<(Device, AlertSubscription)>> subscribers = {};
    final Duration? ttl = this.ttl();
    final List<String> stale = [];
    int expired = 0;
    int disallowed = 0;
    for (final Device device in devices) {
      // 옛 서버가 한도 없이 저장한 등록도 한도만큼만, 허용 게시판만 본다.
      final List<AlertSubscription> subs = device.registration
          .limited(
            allow: (AlertSubscription s) => isAlertBoard(s.site, s.board),
          )
          .subscriptions;
      disallowed += device.registration.subscriptions
          .where((AlertSubscription s) => !isAlertBoard(s.site, s.board))
          .length;
      bool active = false;
      int lastExpiry = 0;
      for (final AlertSubscription sub in subs) {
        final int started = startedAtOf(device, sub);
        if (KeywordAlerts.isExpired(started, now, ttl)) {
          expired++;
          lastExpiry = max(lastExpiry, KeywordAlerts.expiresAt(started, ttl!));
          continue;
        }
        active = true;
        boards.putIfAbsent(sub.boardKey, () => sub);
        (subscribers[sub.boardKey] ??= []).add((device, sub));
      }
      if (!active && now >= lastExpiry + staleGrace.inMilliseconds) {
        stale.add(device.installId);
      }
    }
    for (final String installId in stale) {
      await store.deleteDevice(installId);
    }
    if (stale.isNotEmpty) {
      serverLog('[crawl] 기한이 끝난 기기 등록 ${stale.length}개를 지웠다');
    }

    // 사이트별로 나누고, 상한을 넘으면 구독자가 많은 게시판부터 남긴다.
    final Map<SiteType, List<String>> lanes = {};
    for (final MapEntry<String, AlertSubscription> e in boards.entries) {
      (lanes[e.value.site] ??= []).add(e.key);
    }
    int skipped = 0;
    for (final List<String> keys in lanes.values) {
      if (keys.length <= maxBoardsPerSite) continue;
      keys.sort((String a, String b) {
        final int bySubs = subscribers[b]!.length.compareTo(
          subscribers[a]!.length,
        );
        return bySubs != 0 ? bySubs : a.compareTo(b);
      });
      skipped += keys.length - maxBoardsPerSite;
      keys.removeRange(maxBoardsPerSite, keys.length);
    }
    if (skipped > 0) {
      serverLog('[crawl] 사이트별 상한으로 게시판 $skipped개를 이번 바퀴에 건너뛴다');
    }
    // 보지 않는 게시판 상태는 지운다(다시 보게 되면 첫 크롤부터 → 옛 글로 알리지 않음).
    await store.pruneBoards({for (final keys in lanes.values) ...keys});

    final List<int> failing = [0];
    await Future.wait([
      for (final List<String> keys in lanes.values)
        _crawlLane(keys, boards, subscribers, now, failing),
    ]);

    status = CrawlStatus(
      lastTickAt: now,
      boards: boards.length - skipped,
      failingBoards: failing[0],
      devices: devices.length - stale.length,
      expiredSubscriptions: expired,
      skippedBoards: skipped,
      disallowedSubscriptions: disallowed,
    );
  }

  /// 한 사이트의 게시판을 차례로 받는다.
  Future<void> _crawlLane(
    List<String> keys,
    Map<String, AlertSubscription> boards,
    Map<String, List<(Device, AlertSubscription)>> subscribers,
    int now,
    List<int> failing,
  ) async {
    bool first = true;
    for (final String key in keys) {
      final BoardState state = await store.boardState(key);
      // 한 번도 안 받은 게시판(lastCrawlAt 0)은 바로 받는다.
      if (state.lastCrawlAt > 0 &&
          state.lastCrawlAt + _delayFor(state).inMilliseconds > now) {
        if (state.failures > 0) failing[0]++;
        continue;
      }

      if (!first && politeDelay > Duration.zero) {
        await Future<void>.delayed(politeDelay);
      }
      first = false;

      final List<ListItem> items;
      try {
        items = await fetch(boards[key]!);
      } catch (e) {
        final BoardState failed = BoardState(
          seenIds: state.seenIds,
          lastCrawlAt: now,
          failures: state.failures + 1,
          lastError: '$e',
        );
        await store.putBoardState(key, failed);
        failing[0]++;
        serverLog(
          '[crawl] $key 실패(${failed.failures}회): $e',
          error: e is! FetchFailure || !e.isBlocked,
        );
        continue;
      }

      final Set<int> seen = state.seenIds.toSet();
      final List<ListItem> fresh = state.isSeeded
          ? items.where((ListItem i) => !seen.contains(i.id)).toList()
          : const [];
      await store.putBoardState(
        key,
        BoardState(
          seenIds: [
            ...{...items.map((ListItem i) => i.id), ...state.seenIds},
          ].take(AlertStore.seenLimit).toList(),
          lastCrawlAt: now,
        ),
      );
      if (fresh.isEmpty) continue;
      serverLog('[crawl] $key 새 글 ${fresh.length}개');
      if (fresh.length > maxNewPerBoard) {
        serverLog('[crawl] $key 새 글 ${fresh.length}개 중 $maxNewPerBoard개만 본다');
      }
      await _notify(
        fresh.take(maxNewPerBoard).toList(),
        subscribers[key] ?? const [],
      );
    }
  }

  Future<void> _notify(
    List<ListItem> fresh,
    List<(Device, AlertSubscription)> subs,
  ) async {
    // 기기마다 보낼 알림을 모은다(새 글 순서대로).
    final List<(Device, List<PushMessage>)> outbox = [];
    for (final (Device device, AlertSubscription sub) in subs) {
      final List<PushMessage> messages = [
        for (final ListItem item in fresh)
          if (KeywordAlerts.matchedKeywords(item.title, sub.keywords)
              case final List<String> matched when matched.isNotEmpty)
            PushMessage(
              token: device.registration.fcmToken,
              title: '${sub.title} · ${matched.join(', ')}',
              body: item.title,
              data: KeywordAlertPayload.build(
                site: sub.site,
                board: sub.board,
                url: item.url,
                title: item.title,
                keywords: matched,
              ),
              collapseKey: '${sub.site.name}-${item.id}',
            ),
      ];
      if (messages.isNotEmpty) outbox.add((device, messages));
    }
    await Future.wait([
      for (final (Device device, List<PushMessage> messages) in outbox)
        _pushSlots.run(() => _sendAll(device, messages)),
    ]);
  }

  /// 한 기기에 차례로 보낸다. 토큰이 무효면 등록을 지우고 남은 것은 보내지 않는다.
  Future<void> _sendAll(Device device, List<PushMessage> messages) async {
    for (final PushMessage message in messages) {
      final PushResult result = await push.send(message);
      if (result == PushResult.invalidToken) {
        await store.deleteDevice(device.installId);
        serverLog('[push] 토큰 무효로 기기 등록 삭제');
        return;
      }
    }
  }
}

/// 동시에 [_max] 개까지만 돌리는 자리표.
class _Slots(final int _max) {
  int _busy = 0;
  final List<Completer<void>> _waiting = [];

  Future<T> run<T>(Future<T> Function() task) async {
    if (_busy >= _max) {
      final Completer<void> turn = Completer<void>();
      _waiting.add(turn);
      await turn.future;
    } else {
      _busy++;
    }
    try {
      return await task();
    } finally {
      if (_waiting.isNotEmpty) {
        _waiting.removeAt(0).complete(); // 자리를 그대로 넘긴다
      } else {
        _busy--;
      }
    }
  }
}
