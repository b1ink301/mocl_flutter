import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../server_log.dart';

/// 푸시 한 건.
class const PushMessage({
  required final String token,
  required final String title,
  required final String body,
  required final Map<String, String> data,

  /// 같은 글 알림이 여러 번 쌓이지 않게 하는 태그.
  required final String collapseKey,
});

enum PushResult() {
  sent,

  /// 토큰이 더는 유효하지 않다(앱 삭제 등). 기기 등록을 지운다.
  invalidToken,

  /// 일시 오류. 이번 건만 버린다.
  failed,
}

abstract interface class PushSender() {
  Future<PushResult> send(PushMessage message);
  Future<void> close();
}

/// 발송 키가 없을 때. 보낼 내용만 로그로 남긴다(개발 · 키 연결 전).
class DryRunPushSender() implements PushSender {
  final List<PushMessage> sent = [];

  @override
  Future<PushResult> send(PushMessage message) async {
    sent.add(message);
    serverLog('[push:dry-run] ${message.title} | ${message.body}');
    return PushResult.sent;
  }

  @override
  Future<void> close() async {}
}

/// FCM HTTP v1 발송. 서비스 계정 JSON(Firebase 콘솔 → 프로젝트 설정 → 서비스 계정)으로 인증한다.
class FcmPushSender(
  final String _projectId,
  final AutoRefreshingAuthClient _client,
) implements PushSender {
  static const String channelId = 'keyword_alerts';

  static Future<FcmPushSender> fromServiceAccountFile(String path) async {
    final Map<String, Object?> json =
        jsonDecode(await File(path).readAsString()) as Map<String, Object?>;
    final AutoRefreshingAuthClient client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(json),
      const ['https://www.googleapis.com/auth/firebase.messaging'],
    );
    return FcmPushSender(json['project_id'] as String, client);
  }

  @override
  Future<PushResult> send(PushMessage m) async {
    final Uri uri = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
    );
    final Map<String, Object?> body = {
      'message': {
        'token': m.token,
        'notification': {'title': m.title, 'body': m.body},
        'data': m.data,
        'android': {
          'priority': 'high',
          'collapse_key': m.collapseKey,
          'notification': {'channel_id': channelId, 'tag': m.collapseKey},
        },
        'apns': {
          'headers': {'apns-collapse-id': m.collapseKey},
          'payload': {
            'aps': {'sound': 'default'},
          },
        },
      },
    };
    try {
      final http.Response response = await _client
          .post(
            uri,
            headers: {'content-type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) return PushResult.sent;
      // UNREGISTERED(404) · 잘못된 토큰(400 INVALID_ARGUMENT) 은 다시 보내도 소용없다.
      final bool invalid =
          response.statusCode == 404 ||
          (response.statusCode == 400 &&
              response.body.contains('registration token'));
      serverLog(
        '[push] ${response.statusCode} ${invalid ? '(토큰 무효)' : ''} '
        '${response.body.length > 300 ? response.body.substring(0, 300) : response.body}',
        error: !invalid,
      );
      return invalid ? PushResult.invalidToken : PushResult.failed;
    } catch (e) {
      serverLog('[push] 발송 실패: $e', error: true);
      return PushResult.failed;
    }
  }

  @override
  Future<void> close() async => _client.close();
}
