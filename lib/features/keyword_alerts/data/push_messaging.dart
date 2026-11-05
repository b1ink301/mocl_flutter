import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

/// 알림 하나에서 앱이 쓰는 값. 서버는 `KeywordAlertPayload` 로 data 를 채운다.
class const PushTap(final Map<String, String> data) {
  String? get url => data['url'];
  String? get title => data['title'];
}

/// FCM 을 가리는 얇은 층(테스트에서 바꿔 끼운다).
abstract interface class PushMessaging() {
  /// 알림 권한을 묻는다(Android 13+ · iOS). 허용되면 true.
  Future<bool> requestPermission();

  Future<String?> token();

  Stream<String> get onTokenRefresh;

  /// 앱이 꺼져 있을 때 알림을 눌러 켰다면 그 알림.
  Future<PushTap?> initialTap();

  /// 앱이 뒤에 있을 때 알림을 눌렀다.
  Stream<PushTap> get onTap;

  /// 앱이 앞에 있을 때 온 알림(시스템이 띄우지 않는다).
  Stream<PushTap> get onForeground;
}

class FirebasePushMessaging() implements PushMessaging {
  FirebaseMessaging get _fm => FirebaseMessaging.instance;

  static Map<String, String> _data(RemoteMessage m) => {
    for (final MapEntry<String, dynamic> e in m.data.entries)
      e.key: '${e.value}',
    // 알림 제목은 data 에도 있지만, 없으면 notification 에서 가져온다.
    if (!m.data.containsKey('title') && m.notification?.body != null)
      'title': m.notification!.body!,
  };

  @override
  Future<bool> requestPermission() async {
    final NotificationSettings s = await _fm.requestPermission();
    return s.authorizationStatus == AuthorizationStatus.authorized ||
        s.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> token() => _fm.getToken();

  @override
  Stream<String> get onTokenRefresh => _fm.onTokenRefresh;

  @override
  Future<PushTap?> initialTap() async {
    final RemoteMessage? m = await _fm.getInitialMessage();
    return m == null ? null : PushTap(_data(m));
  }

  @override
  Stream<PushTap> get onTap =>
      FirebaseMessaging.onMessageOpenedApp.map((m) => PushTap(_data(m)));

  @override
  Stream<PushTap> get onForeground =>
      FirebaseMessaging.onMessage.map((m) => PushTap(_data(m)));
}
