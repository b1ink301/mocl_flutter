import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/keyword_alerts/application/keyword_alert_providers.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/inbox_alert.dart';
import 'package:mocl_flutter/features/remote_config/application/remote_config_providers.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';

mixin class KeywordAlertEvent() {
  Future<AlertSyncResult> saveKeywordAlert(
    WidgetRef ref,
    AlertSubscription sub,
  ) => ref.read(keywordAlertsProvider.notifier).upsert(sub);

  /// 끝난(또는 곧 끝날) 알림을 지금부터 다시 센다.
  Future<AlertSyncResult> renewKeywordAlert(
    WidgetRef ref,
    AlertSubscription sub,
  ) => ref.read(keywordAlertsProvider.notifier).renew(sub);

  /// 알림 기한(원격 설정, null = 기한 없음). 흐름 안에서 한 번 읽을 때.
  Duration? readKeywordAlertTtl(WidgetRef ref) =>
      ref.read(remoteConfigProvider).alerts.ttl;

  /// [sub] 가 지금 알림을 받는 게시판인지(허용 목록에서 빠진 구독은 한도에도 세지 않는다).
  bool readIsAlertBoard(WidgetRef ref, AlertSubscription sub) =>
      ref.read(remoteConfigProvider).alerts.isAlertBoard(sub.site, sub.board);

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

  // ── 받은 알림(알림함) ──

  /// 푸시 하나를 알림함에 넣는다. [read] 면 읽음으로.
  Future<InboxAlert?> receiveKeywordAlert(
    WidgetRef ref,
    PushTap tap, {
    bool read = false,
  }) => ref.read(keywordAlertInboxProvider.notifier).receive(tap, read: read);

  /// 백그라운드에서 쌓인 알림을 다시 읽는다.
  Future<void> refreshKeywordAlertInbox(WidgetRef ref) =>
      ref.read(keywordAlertInboxProvider.notifier).refresh();

  Future<void> markKeywordAlertRead(WidgetRef ref, InboxAlert alert) =>
      ref.read(keywordAlertInboxProvider.notifier).markRead(alert.id);

  Future<void> markAllKeywordAlertsRead(WidgetRef ref) =>
      ref.read(keywordAlertInboxProvider.notifier).markAllRead();

  Future<void> removeInboxAlert(WidgetRef ref, InboxAlert alert) =>
      ref.read(keywordAlertInboxProvider.notifier).remove(alert.id);

  Future<void> restoreInboxAlert(WidgetRef ref, InboxAlert alert) =>
      ref.read(keywordAlertInboxProvider.notifier).restore(alert);

  Future<void> clearKeywordAlertInbox(WidgetRef ref) =>
      ref.read(keywordAlertInboxProvider.notifier).clear();
}
