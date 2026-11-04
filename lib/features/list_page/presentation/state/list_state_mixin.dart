import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';

import '../../../settings_page/application/settings_providers.dart';
import '../../application/list_providers.dart';
import '../../../translation/application/translation_providers.dart';

mixin class ListState() {
  String smallTitleState(WidgetRef ref) => ref.watch(listSmallTitleProvider);

  String titleState(WidgetRef ref) => ref.watch(listTitleProvider);

  SortType sortTypeState(WidgetRef ref) => ref.watch(sortTypeProvider);

  bool isSortType(WidgetRef ref, SortType sortType) =>
      ref.watch(sortTypeProvider.select((state) => state == sortType));

  bool isRecentState(WidgetRef ref) => isSortType(ref, SortType.recent);

  bool isRecommendState(WidgetRef ref) => isSortType(ref, SortType.recommend);

  PagingController<int, ListItem> listPageController(WidgetRef ref) =>
      ref.watch(listPagingControllerProvider);

  /// 페이지네이션이 없는 게시판 여부 — '더 불러오기' 버튼 노출 판단용.
  bool isSinglePageBoardState(WidgetRef ref) =>
      ref.watch(isSinglePageBoardProvider);

  /// 이 목록에 번역 버튼을 둘지(레딧 · 번역을 지원하는 기기).
  bool listTranslationSupportedState(WidgetRef ref) =>
      ref.watch(listTranslationSupportedProvider);

  /// 목록 제목을 번역해 보이는 중인지.
  bool listTranslationOnState(WidgetRef ref) =>
      ref.watch(listTranslationOnProvider);

  /// 제목 번역이 진행 중인지(앱바 번역 버튼의 진행 표시).
  bool isTranslatingTitlesState(WidgetRef ref) =>
      ref.watch(titleTranslationsProvider.select((s) => s.pending > 0));

  /// 보여 줄 제목. 번역을 켰고 번역이 끝났으면 번역문, 아니면 원문.
  String displayTitleState(WidgetRef ref, String title) =>
      ref.watch(listTranslationOnProvider)
      ? ref.watch(
              titleTranslationsProvider.select((s) => s.translated[title]),
            ) ??
            title
      : title;

  /// 설정 "말머리 보기".
  bool showCategoryState(WidgetRef ref) => ref.watch(showCategoryProvider);

  AppTextStyles appTextStyles(WidgetRef ref) =>
      ref.watch(appTextStylesFontSizeProvider);

  ListItem? itemState(WidgetRef ref, int index) {
    return ref.watch(itemAtIndexProvider(index));
  }

  TextStyle titleTextStyleState(WidgetRef ref, bool isRead) => ref.watch(
    appTextStylesFontSizeProvider.select(
      (state) => (isRead ? state.readTitleTextStyle : state.titleTextStyle),
    ),
  );

  TextStyle badgeTextStyleState(WidgetRef ref, bool isRead) => ref.watch(
    appTextStylesFontSizeProvider.select(
      (state) => (isRead ? state.readBadgeTextStyle : state.badgeTextStyle),
    ),
  );

  TextStyle smallTitleTextStyleState(WidgetRef ref, bool isRead) => ref.watch(
    appTextStylesFontSizeProvider.select(
      (state) => (isRead ? state.readSmallTextStyle : state.smallTextStyle),
    ),
  );
}
