import 'dart:async';

import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:url_launcher/url_launcher.dart';

/// 알림 글 주소를 연다. 앱이 아는 사이트 글이면 [pushDetail] 로 상세를, 아니면 브라우저를 연다.
void openKeywordAlertUrl(
  String? url, {
  required Future<void> Function(SiteLink link) pushDetail,
}) {
  if (url == null || url.isEmpty) return;
  final SiteLink? link = SiteLinkResolver.resolve(url);
  if (link != null) {
    unawaited(pushDetail(link));
  } else {
    unawaited(launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication));
  }
}
