import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';

import '../server_log.dart';

/// 알림 한 건.
class const OpsAlert({
  required final String title,
  required final String body,
  final bool urgent = false,
  final String? click,
});

/// 운영자에게 알림을 보낸다(ntfy). 실패해도 던지지 않는다.
abstract class OpsNotifier() {
  Future<void> send(OpsAlert alert);
}

/// 보내지 않고 로그만 남긴다(`NTFY_TOPIC` 이 없을 때).
class LogOpsNotifier() implements OpsNotifier {
  @override
  Future<void> send(OpsAlert alert) async =>
      serverLog('[ops] (ntfy 없음) ${alert.title}: ${alert.body}');
}

/// ntfy.sh 로 보낸다. 헤더에 한글을 넣지 않으려고 JSON 으로 발행한다.
/// 토픽 이름이 곧 비밀이라 로그에 남기지 않는다.
class NtfyNotifier(
  final String _topic, {
  final String baseUrl = 'https://ntfy.sh',
  final http.Client? client,
}) implements OpsNotifier {
  late final http.Client _client = client ?? http.Client();

  @override
  Future<void> send(OpsAlert alert) async {
    try {
      final http.Response response = await _client
          .post(
            Uri.parse(baseUrl),
            headers: {'content-type': 'application/json'},
            body: jsonEncode({
              'topic': _topic,
              'title': alert.title,
              'message': alert.body,
              'priority': alert.urgent ? 4 : 3,
              'click': ?alert.click,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode >= 300) {
        serverLog('[ops] ntfy 실패 HTTP ${response.statusCode}', error: true);
      }
    } catch (e) {
      serverLog('[ops] ntfy 실패 $e', error: true);
    }
  }

  void close() => _client.close();
}

/// 신고를 받아 언제 알릴지 정한다(알림 폭탄 방지).
///
/// - 사용자 제보: 사이트마다 [userGap] 에 한 번. 그 사이 온 건 다음 알림(또는 [flush])에 "외 N건" 으로.
/// - 자동 신고: (사이트, 이유)마다 [autoWindow] 안에 [autoThreshold] 건 넘으면 한 번,
///   그 뒤 [autoCooldown] 동안 다시 알리지 않는다. 앱이 기기당 하루 한 번만 보내므로
///   건수 ≈ 겪은 기기 수다.
class ReportAlerter({
  required final OpsNotifier notifier,
  final Duration userGap = const Duration(minutes: 10),
  final int autoThreshold = 5,
  final Duration autoWindow = const Duration(hours: 1),
  final Duration autoCooldown = const Duration(hours: 6),
}) {
  final Map<String, int> _userSentAt = {};
  final Map<String, List<SiteReport>> _userPending = {};
  final Map<String, List<int>> _autoHits = {};
  final Map<String, int> _autoSentAt = {};

  Future<void> onReport(SiteReport report, int now) async {
    switch (report.kind) {
      case SiteReportKind.user:
        await _onUser(report, now);
      case SiteReportKind.auto:
        await _onAuto(report, now);
    }
  }

  /// 묶어 둔 제보 중 [userGap] 이 지난 사이트를 보낸다(서버가 1분마다 부른다).
  Future<void> flush(int now) async {
    for (final String key in _userPending.keys.toList()) {
      final int last = _userSentAt[key] ?? 0;
      if (now - last < userGap.inMilliseconds) continue;
      final List<SiteReport> pending = _userPending.remove(key)!;
      if (pending.isEmpty) continue;
      _userSentAt[key] = now;
      await notifier.send(_userAlert(pending.last, pending.length - 1));
    }
  }

  Future<void> _onUser(SiteReport report, int now) async {
    final String key = report.site?.name ?? '_';
    final int? last = _userSentAt[key];
    if (last != null && now - last < userGap.inMilliseconds) {
      (_userPending[key] ??= []).add(report);
      return;
    }
    final List<SiteReport> pending = _userPending.remove(key) ?? const [];
    _userSentAt[key] = now;
    await notifier.send(_userAlert(report, pending.length));
  }

  Future<void> _onAuto(SiteReport report, int now) async {
    final String key = '${report.site?.name}:${report.reason.name}';
    final List<int> hits = (_autoHits[key] ??= [])
      ..add(now)
      ..removeWhere((int t) => now - t > autoWindow.inMilliseconds);
    if (hits.length < autoThreshold) return;
    final int? last = _autoSentAt[key];
    if (last != null && now - last < autoCooldown.inMilliseconds) return;
    _autoSentAt[key] = now;
    await notifier.send(
      OpsAlert(
        title: 'Mocl ${_siteTitle(report.site)} 고장 의심',
        body:
            '${report.reason.label} · 최근 ${autoWindow.inMinutes}분 ${hits.length}건'
            '${report.board != null ? '\n게시판 ${report.board}' : ''}'
            '${report.message != null ? '\n${report.message}' : ''}'
            '\n앱 ${report.appVersion}',
        urgent: true,
        click: report.url,
      ),
    );
  }

  OpsAlert _userAlert(SiteReport report, int more) => OpsAlert(
    title: 'Mocl 제보 · ${_siteTitle(report.site)}',
    body:
        '${report.reason.label}${more > 0 ? ' (외 $more건)' : ''}'
        '${report.message != null ? '\n"${report.message}"' : ''}'
        '${report.url != null ? '\n${report.url}' : ''}'
        '\n앱 ${report.appVersion} · ${report.platform}',
    click: report.url,
  );

  static String _siteTitle(SiteType? site) => site?.title ?? '일반 의견';
}
