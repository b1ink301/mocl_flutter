import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_inbox.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/inbox_alert.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 앱이 뒤에 있거나 꺼져 있을 때 온 알림을 알림함에 넣는다(별도 isolate 에서 돈다).
///
/// Android 는 시스템이 띄우는 notification 메시지도 여기로 온다. iOS 는
/// `content-available` 없이는 오지 않으므로, 눌렀을 때(`KeywordAlertGate`)만 남는다.
@pragma('vm:entry-point')
Future<void> keywordAlertBackgroundHandler(RemoteMessage message) async {
  try {
    final PushTap tap = FirebasePushMessaging.tapOf(message);
    final InboxAlert? alert = InboxAlert.fromPush(
      tap.data,
      notificationTitle: tap.notificationTitle,
      sentAt: tap.sentAt,
    );
    if (alert == null) return;
    await KeywordAlertInbox(SharedPreferencesInboxStorage()).add(alert);
  } catch (e) {
    // 이 isolate 에는 Crashlytics 가 붙어 있지 않다.
    MoclLogger.w(() => '[keywordAlertInbox] 백그라운드 저장 실패: $e');
  }
}

/// Firebase 초기화 뒤 한 번 부른다. 모바일이 아니면 하지 않는다.
void registerKeywordAlertBackgroundHandler() {
  if (!(Platform.isAndroid || Platform.isIOS)) return;
  FirebaseMessaging.onBackgroundMessage(keywordAlertBackgroundHandler);
}
