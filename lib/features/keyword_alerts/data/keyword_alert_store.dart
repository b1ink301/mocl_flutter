import 'dart:convert';
import 'dart:math';

import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 키워드 알림 구독을 기기에 둔다. 서버는 이 목록의 사본을 갖는다(앱이 원본).
final class KeywordAlertStore(final SharedPreferences _prefs) {
  static const String _keySubs = 'keyword_alert_subscriptions';
  static const String _keyInstallId = 'keyword_alert_install_id';
  static const String _keySynced = 'keyword_alert_synced';

  List<AlertSubscription> subscriptions() {
    final String? raw = _prefs.getString(_keySubs);
    if (raw == null) return const [];
    final List<AlertSubscription> result = [];
    try {
      for (final Object? json in jsonDecode(raw) as List) {
        try {
          result.add(AlertSubscription.fromJson(json));
        } on FormatException catch (e) {
          // 서버 쪽 규칙이 바뀌어(지원 사이트 축소 등) 더는 받을 수 없는 구독은 버린다.
          MoclLogger.w(() => '[keywordAlerts] 구독 하나를 버린다: $e');
        }
      }
    } catch (e) {
      MoclLogger.w(() => '[keywordAlerts] 저장값을 읽지 못함: $e');
    }
    return result;
  }

  Future<void> saveSubscriptions(List<AlertSubscription> subs) => _prefs
      .setString(_keySubs, jsonEncode([for (final s in subs) s.toJson()]));

  /// 서버에 이 기기를 가리키는 무작위 id. 이 값이 곧 등록을 고칠 권한이다.
  String installId() {
    final String? saved = _prefs.getString(_keyInstallId);
    if (saved != null) return saved;
    final Random random = Random.secure();
    final String id = List<String>.generate(
      32,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    _prefs.setString(_keyInstallId, id);
    return id;
  }

  /// 서버에 마지막으로 올린 내용(그대로 다시 올리지 않으려고). 지웠으면 null.
  String? get syncedSignature => _prefs.getString(_keySynced);

  Future<void> setSyncedSignature(String? value) => value == null
      ? _prefs.remove(_keySynced)
      : _prefs.setString(_keySynced, value);
}
