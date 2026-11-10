import 'dart:async';
import 'dart:convert';

import 'package:mocl_flutter/features/keyword_alerts/domain/inbox_alert.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 알림함이 쓰는 저장 칸(테스트에서 바꿔 끼운다).
abstract interface class InboxStorage() {
  Future<String?> read();

  Future<void> write(String? value);
}

/// 실제 저장. 백그라운드 isolate(앱이 뒤에 있을 때 FCM 핸들러)와 메인 isolate 가 같이 쓰므로
/// 캐시가 없는 [SharedPreferencesAsync] 를 쓴다. sembast 는 메인 isolate 가 열고 있어
/// 다른 isolate 에서 쓰면 파일이 깨질 수 있다.
final class SharedPreferencesInboxStorage() implements InboxStorage {
  static const String _key = 'keyword_alert_inbox';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  @override
  Future<String?> read() => _prefs.getString(_key);

  @override
  Future<void> write(String? value) =>
      value == null ? _prefs.remove(_key) : _prefs.setString(_key, value);
}

/// 받은 키워드 알림을 기기에 쌓아 둔다(최신순, [maxItems]개 · [retention] 까지).
final class KeywordAlertInbox(
  final InboxStorage _storage, {

  /// 테스트용 시계.
  final DateTime Function()? clock,
}) {
  static const int maxItems = 100;
  static const Duration retention = Duration(days: 14);

  /// 같은 isolate 안에서 읽고-고쳐-쓰기가 겹치지 않게 차례로 돌린다.
  Future<void> _queue = Future<void>.value();

  Future<List<InboxAlert>> all() => _run((list) => list, write: false);

  /// 알림 하나를 넣는다. 이미 있으면 그대로 두고, [read] 면 읽음으로만 바꾼다.
  Future<List<InboxAlert>> add(InboxAlert alert, {bool read = false}) =>
      _run((list) {
        final int i = list.indexWhere((a) => a.id == alert.id);
        if (i >= 0) {
          if (read && !list[i].read) list[i] = list[i].copyWith(read: true);
          return list;
        }
        return [...list, read ? alert.copyWith(read: true) : alert];
      });

  Future<List<InboxAlert>> markRead(String id) => _run(
    (list) => [for (final a in list) a.id == id ? a.copyWith(read: true) : a],
  );

  Future<List<InboxAlert>> markAllRead() =>
      _run((list) => [for (final a in list) a.copyWith(read: true)]);

  Future<List<InboxAlert>> remove(String id) =>
      _run((list) => list.where((a) => a.id != id).toList());

  /// 실행 취소용: 지운 알림을 되돌린다(읽음 상태 그대로).
  Future<List<InboxAlert>> restore(InboxAlert alert) =>
      _run((list) => [...list.where((a) => a.id != alert.id), alert]);

  Future<List<InboxAlert>> clear() => _run((_) => const []);

  Future<List<InboxAlert>> _run(
    List<InboxAlert> Function(List<InboxAlert>) change, {
    bool write = true,
  }) {
    final Completer<List<InboxAlert>> done = Completer();
    _queue = _queue.then((_) async {
      try {
        final List<InboxAlert> before = await _load();
        final List<InboxAlert> after = _trim(change([...before]));
        if (write) {
          await _storage.write(
            after.isEmpty
                ? null
                : jsonEncode([for (final a in after) a.toJson()]),
          );
        }
        done.complete(after);
      } catch (e, st) {
        done.completeError(e, st);
      }
    });
    return done.future;
  }

  Future<List<InboxAlert>> _load() async {
    final String? raw = await _storage.read();
    if (raw == null) return [];
    final List<InboxAlert> result = [];
    try {
      for (final Object? json in jsonDecode(raw) as List) {
        try {
          result.add(InboxAlert.fromJson(json));
        } on FormatException catch (e) {
          MoclLogger.w(() => '[keywordAlertInbox] 알림 하나를 버린다: $e');
        }
      }
    } catch (e) {
      MoclLogger.w(() => '[keywordAlertInbox] 저장값을 읽지 못함: $e');
    }
    return result;
  }

  /// 최신순으로 줄 세우고, 기한이 지났거나 한도를 넘는 것은 버린다.
  List<InboxAlert> _trim(List<InboxAlert> list) {
    final int oldest = (clock ?? DateTime.now)()
        .subtract(retention)
        .millisecondsSinceEpoch;
    final List<InboxAlert> kept =
        list.where((a) => a.receivedAt >= oldest).toList()
          ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    return kept.length > maxItems ? kept.sublist(0, maxItems) : kept;
  }
}
