import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart' show BuildContext;
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart' show Routes;
import 'package:url_launcher/url_launcher.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:mocl_flutter/features/detail_page/presentation/video_player_page.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/settings_page/application/settings_providers.dart';

import '../../application/detail_providers.dart';

mixin class DetailEvent() {
  void handleRefresh(WidgetRef ref) =>
      ref.read(detailsProvider.notifier).refresh();

  void adjustFontSize(WidgetRef ref, double step) =>
      ref.read(appTextStylesFontSizeProvider.notifier).adjustFontSize(step);

  void resetFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).resetFontSize();

  Future<bool> handleOpenBrowser(WidgetRef ref) =>
      ref.read(detailUrlProvider).openBrowser();

  /// 본문 · 댓글 링크를 연다.
  ///
  /// 설정이 켜져 있고 지원 사이트의 글이면 상세 화면으로 파싱해서 열고, 아니면
  /// 지금처럼 이미지 뷰어 또는 브라우저로 연다. 상대 경로(`/service/board/..`)는
  /// 지금 사이트 주소를 기준으로 풀어서 같은 사이트 안 링크도 잡는다.
  Future<bool> handleOpenLink(
    BuildContext context,
    WidgetRef ref,
    String url,
  ) async {
    final String absolute = _absoluteUrl(ref, url);

    final VideoLink? video = VideoLinkResolver.resolve(absolute);
    if (video != null) {
      if (ref.read(playVideosInAppProvider)) {
        context.push(
          Routes.video,
          extra: VideoPlayerArgs(link: video, referer: _referer(ref)),
        );
        return true;
      }
      // 끄면 예전처럼 유튜브는 유튜브 앱으로 보낸다(파일은 아래 브라우저 경로).
      if (video is YouTubeLink) {
        return launchUrl(
          Uri.parse(video.sourceUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    }

    if (ref.read(openSiteLinksInAppProvider)) {
      final SiteLink? link = SiteLinkResolver.resolve(absolute);
      if (link != null) {
        context.push(Routes.detail, extra: link);
        return true;
      }
    }
    return absolute.openUrl(context);
  }

  String _absoluteUrl(WidgetRef ref, String url) {
    if (url.startsWith('//') || Uri.tryParse(url)?.hasScheme == true) {
      return url;
    }
    return Uri.tryParse(_referer(ref))?.resolve(url).toString() ?? url;
  }

  /// 지금 보고 있는 사이트 주소. 상대 경로 해석과 영상 파일 Referer 에 쓴다.
  String _referer(WidgetRef ref) {
    final siteType = ref.read(detailSiteTypeProvider);
    final (parser, _) = ref.read(currentParserProvider(siteType));
    return parser.baseUrl;
  }

  Future<bool> handleShareUrl(WidgetRef ref) =>
      ref.read(detailUrlProvider).shareUrl();

  void toggleBookmark(
    WidgetRef ref,
    SiteType siteType,
    int id,
    BookmarkData data,
  ) => ref.read(bookmarkButtonProvider(siteType, id).notifier).toggle(data);

  /// [siteType] 은 본문 링크로 다른 사이트 글을 열 때만 넘긴다(없으면 전역 사이트).
  static List<Override> overridesProviderScope(
    double width,
    ListItem item, {
    SiteType? siteType,
  }) => [
    listItemProvider.overrideWithValue(item),
    screenWidthProvider.overrideWithValue(width),
    if (siteType != null) detailSiteTypeProvider.overrideWithValue(siteType),
  ];
}
