import 'dart:async';
import 'dart:convert';

import 'package:mocl_shared/reports/site_report.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../rate_limiter.dart';
import '../server_log.dart';
import 'report_notifier.dart';
import 'report_store.dart';

const int _maxBodyBytes = 4 * 1024;

/// `POST /v1/reports` — 앱의 사이트 문제 신고(자동 · 사용자 제보).
/// 저장한 뒤 [alerter] 가 알릴지 정한다(응답을 기다리게 하지 않는다).
void mountReportRoutes(
  Router router,
  ReportStore store,
  RateLimiter limiter, {
  ReportAlerter? alerter,
  int Function() now = _now,
}) {
  router.post('/v1/reports', (Request request) async {
    if (!limiter.allow(RateLimiter.clientKey(request))) {
      return _error(429, 'rate_limited');
    }
    final String? body = await _readLimited(request);
    if (body == null) return _error(413, 'too_large');
    final SiteReport report;
    try {
      report = SiteReport.fromJson(jsonDecode(body));
    } on FormatException catch (e) {
      return _error(400, 'invalid', detail: e.message);
    }
    final int at = now();
    await store.add(report, at);
    serverLog(
      '[report] ${report.kind.name} ${report.site?.name ?? '-'} '
      '${report.reason.name} ${report.appVersion}',
    );
    if (alerter != null) unawaited(alerter.onReport(report, at));
    return Response(204);
  });
}

int _now() => DateTime.now().millisecondsSinceEpoch;

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
