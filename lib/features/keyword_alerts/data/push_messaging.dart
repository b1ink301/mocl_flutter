import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

/// 알림 하나에서 앱이 쓰는 값. 서버는 `KeywordAlertPayload` 로 data 를 채운다.
class const PushTap(
  final Map<String, String> data, {

  /// 시스템 알림 제목(`'{게시판} · {키워드}'`).
  final String? notificationTitle,

  /// FCM 이 보낸 시각.
  final DateTime? sentAt,
}) {
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

  /// [RemoteMessage] 에서 앱이 쓰는 값만 꺼낸다(백그라운드 핸들러도 쓴다).
  static PushTap tapOf(RemoteMessage m) => PushTap(
    _data(m),
    notificationTitle: m.notification?.title,
    sentAt: m.sentTime,
  );

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

  // firebase_messaging 17 은 register() · onRegistered(FID 직접 발송)를 권하지만,
  // 서버(server/)는 FCM HTTP v1 에 등록 토큰으로 보낸다. 서버 발송을 FID 로 바꿀 때 함께 옮긴다.
  @override
  // ignore: deprecated_member_use
  Future<String?> token() => _fm.getToken();

  @override
  // ignore: deprecated_member_use
  Stream<String> get onTokenRefresh => _fm.onTokenRefresh;

  @override
  Future<PushTap?> initialTap() async {
    final RemoteMessage? m = await _fm.getInitialMessage();
    return m == null ? null : tapOf(m);
  }

  @override
  Stream<PushTap> get onTap => FirebaseMessaging.onMessageOpenedApp.map(tapOf);

  @override
  Stream<PushTap> get onForeground => FirebaseMessaging.onMessage.map(tapOf);
}
