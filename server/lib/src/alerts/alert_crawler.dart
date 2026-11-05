import 'dart:async';
import 'dart:math';

import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';

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
}) {
  Map<String, Object?> toJson(int now) => {
    'lastTickAgoSec': lastTickAt == 0 ? null : (now - lastTickAt) ~/ 1000,
    'boards': boards,
    'failingBoards': failingBoards,
    'devices': devices,
  };
}

/// 구독된 게시판을 돌며 새 글을 찾아 키워드가 맞는 기기에 알린다.
///
/// - 같은 게시판은 구독자가 몇 명이든 한 번만 받는다(사이트 부담 = 게시판 수).
/// - 게시판 첫 크롤은 지금 있는 글을 "본 것" 으로 기록만 한다(옛 글로 알림 폭탄 X).
/// - 실패하면 간격을 늘린다(최대 [maxBackoff]). 차단당했을 때 계속 두드리지 않는다.
class AlertCrawler({
  required final AlertStore store,
  required final BoardFetch fetch,
  required final PushSender push,
  final Duration interval = const Duration(minutes: 3),
  final Duration maxBackoff = const Duration(minutes: 60),

  /// 게시판 사이 쉬는 시간. 사이트에 몰아서 요청하지 않는다.
  final Duration politeDelay = const Duration(milliseconds: 1500),

  /// 한 번에 알릴 새 글 상한(게시판당). 처음 보는 대량 갱신에 폭주하지 않게.
  final int maxNewPerBoard = 30,
}) {
  Timer? _timer;
  bool _running = false;

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
    for (final Device device in devices) {
      for (final AlertSubscription sub in device.registration.subscriptions) {
        boards.putIfAbsent(sub.boardKey, () => sub);
        (subscribers[sub.boardKey] ??= []).add((device, sub));
      }
    }
    await store.pruneBoards(boards.keys.toSet());
    int failing = 0;

    bool first = true;
    for (final MapEntry<String, AlertSubscription> entry in boards.entries) {
      final BoardState state = await store.boardState(entry.key);
      // 한 번도 안 받은 게시판(lastCrawlAt 0)은 바로 받는다.
      if (state.lastCrawlAt > 0 &&
          state.lastCrawlAt + _delayFor(state).inMilliseconds > now) {
        if (state.failures > 0) failing++;
        continue;
      }

      if (!first && politeDelay > Duration.zero) {
        await Future<void>.delayed(politeDelay);
      }
      first = false;

      final List<ListItem> items;
      try {
        items = await fetch(entry.value);
      } catch (e) {
        final BoardState failed = BoardState(
          seenIds: state.seenIds,
          lastCrawlAt: now,
          failures: state.failures + 1,
          lastError: '$e',
        );
        await store.putBoardState(entry.key, failed);
        failing++;
        serverLog(
          '[crawl] ${entry.key} 실패(${failed.failures}회): $e',
          error: e is! FetchFailure || !e.isBlocked,
        );
        continue;
      }

      final Set<int> seen = state.seenIds.toSet();
      final List<ListItem> fresh = state.isSeeded
          ? items.where((ListItem i) => !seen.contains(i.id)).toList()
          : const [];
      await store.putBoardState(
        entry.key,
        BoardState(
          seenIds: [
            ...{...items.map((ListItem i) => i.id), ...state.seenIds},
          ].take(AlertStore.seenLimit).toList(),
          lastCrawlAt: now,
        ),
      );
      if (fresh.isEmpty) continue;
      serverLog('[crawl] ${entry.key} 새 글 ${fresh.length}개');
      if (fresh.length > maxNewPerBoard) {
        serverLog(
          '[crawl] ${entry.key} 새 글 ${fresh.length}개 중 $maxNewPerBoard개만 본다',
        );
      }
      await _notify(
        fresh.take(maxNewPerBoard).toList(),
        subscribers[entry.key] ?? const [],
      );
    }
    status = CrawlStatus(
      lastTickAt: now,
      boards: boards.length,
      failingBoards: failing,
      devices: devices.length,
    );
  }

  Future<void> _notify(
    List<ListItem> fresh,
    List<(Device, AlertSubscription)> subs,
  ) async {
    final Set<String> deadInstalls = {};
    for (final ListItem item in fresh) {
      for (final (Device device, AlertSubscription sub) in subs) {
        if (deadInstalls.contains(device.installId)) continue;
        final List<String> matched = KeywordAlerts.matchedKeywords(
          item.title,
          sub.keywords,
        );
        if (matched.isEmpty) continue;
        final PushResult result = await push.send(
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
        );
        if (result == PushResult.invalidToken) {
          deadInstalls.add(device.installId);
          await store.deleteDevice(device.installId);
          serverLog('[push] 토큰 무효로 기기 등록 삭제');
        }
      }
    }
  }
}
