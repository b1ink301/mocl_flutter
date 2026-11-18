import 'package:fpdart/fpdart.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/error/failures.dart';
import 'package:mocl_shared/reports/site_report.dart';

/// 목록 · 상세 결과가 "사이트가 바뀌어 파서가 못 읽는" 고장으로 보이는지 가른다.
///
/// 사용자 쪽 사정(네트워크 · 로그인 · 차단 · 요청 제한)이나 HTTP 상태 실패는 신고하지 않는다 —
/// 고장이 아니라 그 기기 · 망의 문제라 알림이 시끄러워진다. 검색 0건도 정상이다.
abstract final class SiteHealthClassifier() {
  /// 사이트 API 가 HTTP 실패를 담는 메시지(`'response.statusCode = 403'`).
  static const String _httpPrefix = 'response.statusCode';

  /// [firstPage] 는 목록 첫 쪽(검색 아님)인지 — 그때만 0개를 고장으로 본다.
  static SiteReportReason? list(
    Either<Failure, List<ListItem>> result, {
    required bool firstPage,
  }) => result.fold(
    (Failure f) =>
        f is GetListFailure && _isParse(f) ? SiteReportReason.listParse : null,
    (List<ListItem> items) =>
        firstPage && items.isEmpty ? SiteReportReason.emptyList : null,
  );

  static SiteReportReason? detail(Either<Failure, Details> result) =>
      result.fold(
        (Failure f) => f is GetDetailFailure && _isParse(f)
            ? SiteReportReason.detailParse
            : null,
        (_) => null,
      );

  static bool _isParse(Failure f) =>
      !f.message.trimLeft().startsWith(_httpPrefix);
}
