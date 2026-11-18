import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/site_health/data/site_report_client.dart';
import 'package:mocl_flutter/features/site_health/domain/site_health_classifier.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 사이트 파서 고장을 앱이 스스로 알린다(사용자 행동 없이).
///
/// - 무엇을: [SiteHealthClassifier] 가 고장으로 본 것만(차단 · 네트워크 · 로그인은 빼고)
/// - 어디로: Crashlytics non-fatal([MoclLogger.e]) + 서버 `/v1/reports`(`kind: auto`)
/// - 얼마나: 같은 (사이트, 게시판, 이유)는 기기당 하루 한 번. 서버는 사이트마다 1시간 5건이 모이면 ntfy 로 알린다.
///
/// 결과를 바꾸지 않고, 기다리지 않는다(목록 · 상세는 그대로 흘러간다).
final class SiteHealthReporter({
  required final SharedPreferences prefs,
  required final SiteReportClient client,
  required final Future<String> Function() appVersion,
  required final String platform,

  /// release 빌드에서만 켠다(개발 중 깨뜨린 파서가 신고되지 않게).
  required final bool enabled,
  final DateTime Function() clock = DateTime.now,
}) {
  static const String _sentKey = 'site_health_sent';

  /// 하루 한 번 표시를 남겨 두는 기간. 지난 표시는 정리한다.
  static const Duration _keep = Duration(days: 2);

  /// 목록 결과를 본다. [firstPage] 는 검색이 아닌 첫 쪽인지.
  void onList(
    SiteType site,
    String board,
    String url,
    Either<Failure, List<ListItem>> result, {
    required bool firstPage,
  }) {
    final SiteReportReason? reason = SiteHealthClassifier.list(
      result,
      firstPage: firstPage,
    );
    if (reason != null) {
      unawaited(_report(site, board, url, reason, _messageOf(result)));
    }
  }

  void onDetail(SiteType site, ListItem item, Either<Failure, Details> result) {
    final SiteReportReason? reason = SiteHealthClassifier.detail(result);
    if (reason != null) {
      unawaited(
        _report(site, item.board, item.url, reason, _messageOf(result)),
      );
    }
  }

  Future<void> _report(
    SiteType site,
    String board,
    String url,
    SiteReportReason reason,
    String? message,
  ) async {
    if (!enabled) {
      MoclLogger.w(
        () => '[siteHealth] (debug, 보내지 않음) $site/$board $reason $message',
      );
      return;
    }
    try {
      final String key = '${site.name}|$board|${reason.name}';
      if (!_markToday(key)) return;
      // 네이버카페 · 레딧은 게시판이 계정마다 달라(가입 카페 · 구독 커뮤니티) 무엇을 보는지가
      // 드러나므로 게시판 · 주소를 보내지 않는다.
      final bool shareBoard = site.hasCuratedBoardList;
      // 이슈가 사이트별로 묶이게 오류 객체에 사이트 · 이유를 담는다.
      MoclLogger.e(
        '[siteHealth] ${site.name} ${reason.name}',
        error: SiteParseError(site, reason, message),
      );
      await client.send(
        SiteReport(
          kind: SiteReportKind.auto,
          reason: reason,
          appVersion: await appVersion(),
          platform: platform,
          site: site,
          board: shareBoard ? _clipBoard(board) : null,
          url:
              shareBoard &&
                  SiteReport.isWebUrl(url) &&
                  url.length <= SiteReport.maxUrlLength
              ? url
              : null,
          message: SiteReport.clip(message),
        ),
      );
    } catch (e) {
      // 신고가 실패해도 화면에는 영향이 없어야 한다.
      MoclLogger.w(() => '[siteHealth] 신고 실패 $e');
    }
  }

  /// 오늘 처음이면 표시하고 true.
  bool _markToday(String key) {
    final DateTime now = clock();
    final String today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final Map<String, Object?> sent = _readSent();
    if (sent[key] == today) return false;
    final int cutoff = now.subtract(_keep).millisecondsSinceEpoch;
    sent
      ..removeWhere(
        (_, Object? v) =>
            v is! String ||
            (DateTime.tryParse(v)?.millisecondsSinceEpoch ?? 0) < cutoff,
      )
      ..[key] = today;
    unawaited(prefs.setString(_sentKey, jsonEncode(sent)));
    return true;
  }

  Map<String, Object?> _readSent() {
    try {
      final Object? json = jsonDecode(prefs.getString(_sentKey) ?? '{}');
      return json is Map<String, Object?> ? {...json} : {};
    } on FormatException {
      return {};
    }
  }

  static String? _clipBoard(String board) {
    final String trimmed = board.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.length <= SiteReport.maxBoardLength
        ? trimmed
        : trimmed.substring(0, SiteReport.maxBoardLength);
  }

  static String? _messageOf<T>(Either<Failure, T> result) =>
      result.fold((Failure f) => f.message, (_) => null);
}

/// Crashlytics 에 남는 파서 고장(non-fatal).
class const SiteParseError(
  final SiteType site,
  final SiteReportReason reason,
  final String? message,
) implements Exception {
  @override
  String toString() =>
      'SiteParseError(${site.name}, ${reason.name}): ${SiteReport.clip(message) ?? ''}';
}
