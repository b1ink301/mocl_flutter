import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';

import '../../../../config/mocl_text_styles.dart';
import '../../../../core/application/app_provider.dart';
import '../../../html_parser/application/datasource_provider.dart';
import '../../../settings_page/application/settings_providers.dart';
import '../../application/detail_providers.dart';
import '../../application/use_case_provider.dart';
import '../../../translation/application/translation_providers.dart';

mixin class DetailState() {
  AppTextStyles appTextStyles(WidgetRef ref) =>
      ref.watch(appTextStylesFontSizeProvider);

  /// 상세 글. 번역본을 보고 있으면 번역본(댓글은 번역된 만큼)을 준다.
  AsyncValue<Details> detailState(WidgetRef ref) {
    final AsyncValue<Details> original = ref.watch(detailsProvider);
    final DetailTranslation translation = ref.watch(detailTranslationProvider);
    final Details? translated = translation.isShowing
        ? translation.details
        : null;
    return translated != null && original.hasValue
        ? AsyncData(translated)
        : original;
  }

  /// 상세 번역 상태(앱바 번역 버튼).
  DetailTranslation translationState(WidgetRef ref) =>
      ref.watch(detailTranslationProvider);

  /// 이 상세에 번역 버튼을 둘지(레딧 · 번역을 지원하는 기기).
  bool supportsTranslationState(WidgetRef ref) => ref.watch(
    siteTranslationSupportedProvider(ref.watch(detailSiteTypeProvider)),
  );

  /// 본문/댓글 이미지 로드 시 보낼 Referer = 현재 사이트의 baseUrl.
  /// (디시 등 일부 CDN 은 Referer 가 사이트 도메인이어야 이미지를 준다.)
  /// presentation 위젯이 application provider 를 직접 참조하지 않도록 여기서 노출.
  String imageRefererState(WidgetRef ref) {
    final siteType = ref.watch(detailSiteTypeProvider);
    final (parser, _) = ref.watch(currentParserProvider(siteType));
    return parser.baseUrl;
  }

  String titleState(WidgetRef ref) => ref.watch(detailTitleStateProvider);

  /// 제목 위 말머리 태그. 설정 "말머리 보기" 가 꺼져 있으면 빈 문자열.
  String categoryState(WidgetRef ref) => ref.watch(showCategoryProvider)
      ? ref.watch(detailCategoryStateProvider)
      : '';

  String smallTitleState(WidgetRef ref) => ref.watch(detailSmallTitleProvider);

  double appbarHeight(WidgetRef ref, String title, double width) =>
      ref.watch(detailAppbarHeightProvider(title, width));

  /// 현재 상세 게시물(ProviderScope 로 주입된 listItemProvider).
  ListItem listItemState(WidgetRef ref) => ref.watch(listItemProvider);

  SiteType currentSiteTypeState(WidgetRef ref) =>
      ref.watch(detailSiteTypeProvider);

  /// 이 상세의 사이트가 앱에서 댓글 쓰기를 지원하는지.
  bool supportsCommentWriteState(WidgetRef ref) => ref.watch(
    supportsCommentWriteProvider(ref.watch(detailSiteTypeProvider)),
  );

  /// 현재 게시물의 스크랩(북마크) 여부. 북마크 버튼이 사용한다.
  bool isBookmarkedState(WidgetRef ref, SiteType siteType, int id) =>
      ref.watch(bookmarkButtonProvider(siteType, id)).asData?.value ?? false;
}
