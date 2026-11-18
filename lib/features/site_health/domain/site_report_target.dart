import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';

/// 무엇에 대한 제보인지(시트가 "함께 보내는 정보" 로 보여 주고 그대로 보낸다).
/// 모두 비면 사이트와 상관없는 의견이다.
class const SiteReportTarget({
  final SiteType? site,
  final String? board,
  final String? boardTitle,
  final String? url,
}) {
  /// 서버 계약에 맞게 줄이고 거른다(빈 값 · http(s) 아닌 주소 · 너무 긴 값은 뺀다).
  factory of({SiteType? site, String? board, String? boardTitle, String? url}) {
    final String? b = board?.trim();
    final String? u = url?.trim();
    return SiteReportTarget(
      site: site,
      board: b == null || b.isEmpty || b.length > SiteReport.maxBoardLength
          ? null
          : b,
      boardTitle: boardTitle?.trim().isEmpty ?? true
          ? null
          : boardTitle!.trim(),
      url:
          u == null ||
              u.length > SiteReport.maxUrlLength ||
              !SiteReport.isWebUrl(u)
          ? null
          : u,
    );
  }

  /// 사이트와 상관없는 의견.
  static const SiteReportTarget general = SiteReportTarget();
}
