import 'dart:async';
import 'dart:convert';

import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../rate_limiter.dart';
import 'alert_store.dart';

/// 앱이 만든 무작위 설치 id. 이 값이 곧 등록을 고칠 권한이라 충분히 길어야 한다.
final RegExp _installId = RegExp(r'^[A-Za-z0-9-]{16,64}$');

const int _maxBodyBytes = 64 * 1024;

void mountAlertRoutes(Router router, AlertStore store, RateLimiter limiter) {
  router
    ..put('/v1/alerts/<installId>', (Request request, String installId) async {
      final Response? rejected = _guard(request, installId, limiter);
      if (rejected != null) return rejected;

      final String? body = await _readLimited(request);
      if (body == null) return _error(413, 'too_large');
      final AlertRegistration registration;
      try {
        registration = AlertRegistration.fromJson(jsonDecode(body));
      } on FormatException catch (e) {
        return _error(400, 'invalid', detail: e.message);
      }
      // 구독이 하나도 없으면 등록을 지운다(크롤 대상에서 빠진다).
      if (registration.subscriptions.isEmpty) {
        await store.deleteDevice(installId);
        return Response(204);
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
