import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import '../../../settings_page/application/settings_providers.dart';
import '../../application/list_providers.dart';
import '../../application/list_search_providers.dart';

mixin class ListSearchState() {
  /// 검색하는 게시판.
  MainItem searchBoardState(WidgetRef ref) => ref.watch(mainItemProvider);

  /// 제출한 검색어(비면 검색 전).
  String searchQueryState(WidgetRef ref) => ref.watch(searchQueryProvider);

  PagingController<int, ListItem> searchPageController(WidgetRef ref) =>
      ref.watch(searchPagingControllerProvider);

  List<String> searchHistoryState(WidgetRef ref) =>
      ref.watch(searchHistoryProvider);

  /// 사이트 이름(예: "클리앙"). 큰 화면 · 힌트 문구에 쓴다.
  String searchSiteTitleState(WidgetRef ref) =>
      ref.watch(mainItemProvider.select((i) => i.siteType.title));

  AppTextStyles searchTextStyles(WidgetRef ref) =>
      ref.watch(appTextStylesFontSizeProvider);

  bool searchShowCategoryState(WidgetRef ref) =>
      ref.watch(showCategoryProvider);
}
