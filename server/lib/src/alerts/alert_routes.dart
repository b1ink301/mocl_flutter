import 'dart:async';
import 'dart:convert';

import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../rate_limiter.dart';
import 'alert_store.dart';
import 'push_sender.dart';

/// 앱이 만든 무작위 설치 id. 이 값이 곧 등록을 고칠 권한이라 충분히 길어야 한다.
final RegExp _installId = RegExp(r'^[A-Za-z0-9-]{16,64}$');

const int _maxBodyBytes = 64 * 1024;

/// [isAlertBoard] 는 지금 원격 설정의 허용 게시판 판정(`alerts.boards`), [validateToken] 은 FCM 토큰
/// 확인(서비스 계정이 없으면 null — 확인하지 않는다).
void mountAlertRoutes(
  Router router,
  AlertStore store,
  RateLimiter limiter, {
  required bool Function(SiteType site, String board) isAlertBoard,
  TokenValidator? validateToken,
}) {
  router
    ..put('/v1/alerts/<installId>', (Request request, String installId) async {
      final Response? rejected = _guard(request, installId, limiter);
      if (rejected != null) return rejected;

      final String? body = await _readLimited(request);
      if (body == null) return _error(413, 'too_large');
      final AlertRegistration registration;
      try {
        // 옛 앱은 허용 밖 게시판 · 한도를 넘는 등록을 보낼 수 있다 → 거절하지 않고
        // 허용 게시판만 앞에서부터 한도만큼 쓴다(거절하면 허용 게시판 구독까지 사라진다).
        registration = AlertRegistration.fromJson(jsonDecode(body)).limited(
          allow: (AlertSubscription s) => isAlertBoard(s.site, s.board),
        );
      } on FormatException catch (e) {
        return _error(400, 'invalid', detail: e.message);
      }
      // 구독이 하나도 없으면 등록을 지운다(크롤 대상에서 빠진다).
      if (registration.subscriptions.isEmpty) {
        await store.deleteDevice(installId);
        return Response(204);
      }
      // 새 기기이거나 토큰이 바뀐 경우에만 FCM 에 확인한다(지어낸 토큰으로 자리 채우기 방지).
      if (validateToken != null &&
          await store.fcmTokenOf(installId) != registration.fcmToken &&
          await validateToken(registration.fcmToken) == TokenCheck.invalid) {
        return _error(400, 'invalid_token');
      }
      final bool ok = await store.putDevice(
        installId,
        registration,
        DateTime.now().millisecondsSinceEpoch,
      );
      return ok ? Response(204) : _error(503, 'capacity');
    })
    ..delete('/v1/alerts/<installId>', (
      Request request,
      String installId,
    ) async {
      final Response? rejected = _guard(request, installId, limiter);
      if (rejected != null) return rejected;
      await store.deleteDevice(installId);
      return Response(204);
    });
}

Response? _guard(Request request, String installId, RateLimiter limiter) {
  if (!limiter.allow(RateLimiter.clientKey(request))) {
    return _error(429, 'rate_limited');
  }
  if (!_installId.hasMatch(installId)) return _error(400, 'bad_install_id');
  return null;
}

Future<String?> _readLimited(Request request) async {
  final int? length = request.contentLength;
  if (length != null && length > _maxBodyBytes) return null;
  final List<int> bytes = [];
  await for (final List<int> chunk in request.read()) {
    bytes.addAll(chunk);
    if (bytes.length > _maxBodyBytes) return null;
  }
  return utf8.decode(bytes, allowMalformed: true);
}

Response _error(int status, String code, {String? detail}) => Response(
  status,
  body: jsonEncode({'error': code, 'detail': ?detail}),
  headers: {'content-type': 'application/json; charset=utf-8'},
);
