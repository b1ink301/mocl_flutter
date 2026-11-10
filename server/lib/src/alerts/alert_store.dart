import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:sembast/sembast.dart';

/// 등록된 기기 하나.
class const Device(
  final String installId,
  final AlertRegistration registration,
  final int updatedAt,
);

/// 게시판 하나의 크롤 상태.
class const BoardState({
  /// 이미 본 글 id(최근 것만). 처음 크롤은 여기를 채우기만 하고 알리지 않는다.
  final List<int> seenIds = const [],
  final int lastCrawlAt = 0,
  final int failures = 0,
  final String lastError = '',
}) {
  bool get isSeeded => seenIds.isNotEmpty || lastCrawlAt > 0;

  Map<String, Object?> toJson() => {
    'seenIds': seenIds,
    'lastCrawlAt': lastCrawlAt,
    'failures': failures,
    'lastError': lastError,
  };

  factory fromJson(Map<String, Object?> json) => BoardState(
    seenIds: [
      for (final Object? id in json['seenIds'] as List? ?? []) id as int,
    ],
    lastCrawlAt: json['lastCrawlAt'] as int? ?? 0,
    failures: json['failures'] as int? ?? 0,
    lastError: json['lastError'] as String? ?? '',
  );
}

/// 알림 데이터 저장소(sembast 파일 DB). 기기 수천 대 규모까지는 이걸로 충분하다.
class AlertStore(final Database _db) {
  static final StoreRef<String, Map<String, Object?>> _devices =
      stringMapStoreFactory.store('devices');
  static final StoreRef<String, Map<String, Object?>> _boards =
      stringMapStoreFactory.store('boards');

  /// 한 게시판에서 기억할 글 id 수. 1쪽 글 수보다 넉넉하면 된다.
  static const int seenLimit = 300;

  /// 전체 기기 수 상한(남용 방지).
  static const int maxDevices = 20000;

  Future<int> deviceCount() => _devices.count(_db);

  /// 등록을 저장한다. 이미 있는 기기면 덮어쓴다. 새 기기인데 상한이면 false.
  Future<bool> putDevice(String installId, AlertRegistration reg, int now) =>
      _db.transaction((txn) async {
        final bool exists = await _devices.record(installId).exists(txn);
        if (!exists && await _devices.count(txn) >= maxDevices) return false;
        // 같은 FCM 토큰을 다른 installId 가 갖고 있으면(재설치 등) 옛 것을 지운다.
        await _devices.delete(
          txn,
          finder: Finder(
            filter: Filter.and([
              Filter.equals('reg.fcmToken', reg.fcmToken),
              Filter.notEquals(Field.key, installId),
            ]),
          ),
        );
        await _devices.record(installId).put(txn, {
          'reg': reg.toJson(),
          'updatedAt': now,
        });
        return true;
      });

  /// 저장된 기기의 FCM 토큰(없으면 null).
  Future<String?> fcmTokenOf(String installId) async {
    final Map<String, Object?>? json = await _devices
        .record(installId)
        .get(_db);
    final Object? reg = json?['reg'];
    return reg is Map ? reg['fcmToken'] as String? : null;
  }

  Future<bool> deleteDevice(String installId) async =>
      await _devices.record(installId).delete(_db) != null;

  Future<List<Device>> devices() async {
    final records = await _devices.find(_db);
    final List<Device> result = [];
    for (final r in records) {
      try {
        result.add(
          Device(
            r.key,
            AlertRegistration.fromJson(r.value['reg']),
            r.value['updatedAt'] as int? ?? 0,
          ),
        );
      } on FormatException {
        // 규칙이 바뀌어(사이트 제외 등) 더는 맞지 않는 등록. 다음 동기화 때 고쳐진다.
      }
    }
    return result;
  }

  Future<BoardState> boardState(String boardKey) async {
    final Map<String, Object?>? json = await _boards.record(boardKey).get(_db);
    return json == null ? const BoardState() : BoardState.fromJson(json);
  }

  Future<void> putBoardState(String boardKey, BoardState state) =>
      _boards.record(boardKey).put(_db, state.toJson());

  /// 구독자가 없어진 게시판 상태를 지운다.
  Future<void> pruneBoards(Set<String> activeKeys) => _boards.delete(
    _db,
    finder: Finder(
      filter: Filter.custom((r) => !activeKeys.contains(r.key as String)),
    ),
  );
}
