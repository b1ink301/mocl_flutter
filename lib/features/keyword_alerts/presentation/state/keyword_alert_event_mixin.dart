import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/keyword_alerts/application/keyword_alert_providers.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';

mixin class KeywordAlertEvent() {
  Future<AlertSyncResult> saveKeywordAlert(
    WidgetRef ref,
    AlertSubscription sub,
  ) => ref.read(keywordAlertsProvider.notifier).upsert(sub);

  Future<AlertSyncResult> removeKeywordAlert(
    WidgetRef ref,
    AlertSubscription sub,
  ) => ref.read(keywordAlertsProvider.notifier).remove(sub);

  Future<AlertSyncResult> restoreKeywordAlert(
    WidgetRef ref,
    AlertSubscription sub,
    int index,
  ) => ref.read(keywordAlertsProvider.notifier).restore(sub, index);

  /// 알림 권한을 묻는다. 허용되면 true.
  Future<bool> requestAlertPermission(WidgetRef ref) =>
      ref.read(pushMessagingProvider).requestPermission();

  /// 앱 시작 · 토큰 갱신 때 서버와 다시 맞춘다.
  Future<AlertSyncResult> syncKeywordAlerts(
    WidgetRef ref, {
    bool force = false,
  }) => ref.read(keywordAlertsProvider.notifier).sync(force: force);

  /// 알림 수신 이벤트(게이트가 듣는다).
  PushMessaging readPushMessaging(WidgetRef ref) =>
      ref.read(pushMessagingProvider);

  bool readKeywordAlertsAvailable(WidgetRef ref) =>
      ref.read(keywordAlertsAvailableProvider);

  List<AlertSubscription> readKeywordAlerts(WidgetRef ref) =>
      ref.read(keywordAlertsProvider);

  bool readHasKeywordAlerts(WidgetRef ref) =>
      ref.read(keywordAlertsProvider).isNotEmpty;
}
