import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:url_launcher/url_launcher.dart';

/// 이슈 글을 연다. 지원 사이트 글이면 앱 상세, 아니면 브라우저.
void openIssuePost(BuildContext context, String url) {
  final SiteLink? link = SiteLinkResolver.resolve(url);
  if (link != null) {
    unawaited(context.push(Routes.detail, extra: link));
  } else {
    unawaited(launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication));
  }
}
