import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_store.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

enum AlertSyncResult() {
  /// 서버에 반영됐다(또는 이미 같았다).
  synced,

  /// 서버 주소가 없는 빌드라 보내지 않았다.
  noServer,

  /// 알림 토큰을 받지 못했다(권한 · Play 서비스 · APNs 미설정 등).
  noToken,

  /// 네트워크 · 서버 오류. 다음 실행 때 다시 시도한다.
  failed,
}

/// 기기의 구독 목록을 서버(`/v1/alerts/{installId}`)에 맞춘다.
///
/// 항상 전체를 올린다(덮어쓰기). 지난번에 올린 내용과 같으면 요청하지 않는다.
final class KeywordAlertSync(
  final Dio _dio,
  final String _baseUrl,
  final KeywordAlertStore _store,
  final PushMessaging _messaging,
  final String _platform,
) {
  Future<AlertSyncResult> sync({bool force = false}) async {
    if (_baseUrl.isEmpty) return AlertSyncResult.noServer;
    final String url = '$_baseUrl/v1/alerts/${_store.installId()}';
    final List<AlertSubscription> subs = _store.subscriptions();
    try {
      if (subs.isEmpty) {
        if (_store.syncedSignature == null && !force) {
          return AlertSyncResult.synced;
        }
        await _dio.delete<void>(url);
        await _store.setSyncedSignature(null);
        return AlertSyncResult.synced;
      }

      final String? token = await _messaging.token();
      if (token == null || token.isEmpty) return AlertSyncResult.noToken;
      final String body = jsonEncode(
        AlertRegistration(
          fcmToken: token,
          platform: _platform,
          subscriptions: subs,
        ).toJson(),
      );
      if (!force && body == _store.syncedSignature) {
        return AlertSyncResult.synced;
      }
      await _dio.put<void>(
        url,
        data: body,
        options: Options(contentType: 'application/json'),
      );
      await _store.setSyncedSignature(body);
      return AlertSyncResult.synced;
    } on DioException catch (e) {
      // 서버가 잠깐 내려가 있어도 앱에는 문제가 없다. 다음 실행 때 다시 맞춘다.
      MoclLogger.w(
        () =>
            '[keywordAlerts] 동기화 실패: ${e.type} ${e.response?.statusCode ?? ''}',
      );
      return AlertSyncResult.failed;
    } catch (e, st) {
      // 토큰 조회 실패(Play 서비스 없음 등)
      MoclLogger.w(() => '[keywordAlerts] 동기화 실패: $e\n$st');
      return AlertSyncResult.failed;
    }
  }
}
