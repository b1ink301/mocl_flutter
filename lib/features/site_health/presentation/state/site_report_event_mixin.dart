import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/site_health/application/site_health_providers.dart';
import 'package:mocl_flutter/features/site_health/domain/site_report_target.dart';
import 'package:mocl_shared/reports/site_report.dart';

mixin class SiteReportEvent() {
  /// "문제 알리기" 를 보일지(서버 주소가 있는 빌드만).
  bool readSiteReportsAvailable(WidgetRef ref) =>
      ref.read(siteReportsAvailableProvider);

  /// 사용자 제보를 보낸다. 보냈으면 true.
  Future<bool> sendSiteReport(
    WidgetRef ref,
    SiteReportTarget target,
    SiteReportReason reason,
    String memo,
  ) async {
    final String trimmed = memo.trim();
    return ref
        .read(siteReportClientProvider)
        .send(
          SiteReport(
            kind: SiteReportKind.user,
            reason: reason,
            appVersion: await reportAppVersion(),
            platform: reportPlatform,
            site: target.site,
            board: target.board,
            url: target.url,
            message: trimmed.isEmpty
                ? null
                : trimmed.length <= SiteReport.maxMemoLength
                ? trimmed
                : trimmed.substring(0, SiteReport.maxMemoLength),
          ),
        );
  }
}
