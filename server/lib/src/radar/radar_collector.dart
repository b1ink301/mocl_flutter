import 'dart:async';

import 'package:mocl_shared/entities/mocl_list_item.dart';

import '../server_log.dart';
import 'radar_boards.dart';
import 'radar_store.dart';

typedef RadarFetch = Future<List<ListItem>> Function(RadarBoard board);

/// 레이더 게시판을 5분마다 받아 [RadarStore] 에 쌓는다.
class RadarCollector({
  required final RadarStore store,
  required final RadarFetch fetch,
  final List<RadarBoard> boards = radarBoards,
  final Duration politeDelay = const Duration(milliseconds: 1500),

  /// 한 바퀴를 마친 뒤 부른다(묶기 · 랭킹 다시 계산).
  final Future<void> Function()? onCollected,
}) {
  Timer? _timer;
  bool _running = false;

  /// 마지막 바퀴 시각(ms).
  int lastRunAt = 0;

  /// 게시판별 연속 실패 횟수.
  final Map<String, int> _streak = {};

  /// 2번 넘게 잇달아 실패한 게시판. 한 번씩 타임아웃 나는 사이트(엠팍)로
  /// 감시 상태가 깜빡이지 않게 연속 실패만 센다.
  Set<String> get failing => {
    for (final e in _streak.entries)
      if (e.value >= 2) e.key,
  };

  void start({Duration every = const Duration(minutes: 5)}) {
    _timer ??= Timer.periodic(every, (_) => unawaited(_guarded()));
    unawaited(_guarded());
  }

  Future<void> stop() async => _timer?.cancel();

  Future<void> _guarded() async {
    if (_running) return;
    _running = true;
    try {
      await collect(DateTime.now().millisecondsSinceEpoch);
      await onCollected?.call();
    } catch (e, st) {
      serverLog('[radar] 수집 실패: $e\n$st', error: true);
    } finally {
      _running = false;
    }
  }

  /// 한 바퀴. 테스트는 이 함수를 직접 부른다.
  Future<void> collect(int now) async {
    final Set<String> failed = {};
    int fresh = 0;
    for (int i = 0; i < boards.length; i++) {
      final RadarBoard board = boards[i];
      if (i > 0 && politeDelay > Duration.zero) {
        await Future<void>.delayed(politeDelay);
      }
      final List<ListItem> items;
      try {
        items = await fetch(board);
      } catch (e) {
        failed.add(board.key);
        _streak[board.key] = (_streak[board.key] ?? 0) + 1;
        serverLog('[radar] ${board.key} 실패: $e');
        continue;
      }
      _streak.remove(board.key);
      fresh += await store.upsert(board.site.name, board.board, [
        for (int r = 0; r < items.length; r++)
          if (items[r].id > 0 && items[r].title.trim().isNotEmpty)
            (
              items[r].id,
              items[r].title.trim(),
              items[r].url,
              RadarSample(
                now,
                RadarSample.parseCount(items[r].reply),
                RadarSample.parseCount(items[r].hit),
                RadarSample.parseCount(items[r].like),
                r,
              ),
            ),
      ], now);
    }
    final int pruned = await store.prune(now);
    lastRunAt = now;
    serverLog(
      '[radar] 새 글 $fresh · 실패 ${failed.length} · 정리 $pruned · 전체 ${await store.count()}',
    );
  }
}
