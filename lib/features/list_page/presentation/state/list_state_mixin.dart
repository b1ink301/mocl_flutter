import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';

import '../../application/list_providers.dart';

mixin class ListState {
  String smallTitleState(WidgetRef ref) => ref.watch(listSmallTitleProvider);

  String titleState(WidgetRef ref) => ref.watch(listTitleProvider);

  SortType sortTypeState(WidgetRef ref) => ref.watch(sortTypeProvider);

  bool isSortType(WidgetRef ref, SortType sortType) =>
      ref.watch(sortTypeProvider.select((state) => state == sortType));

  bool isRecentState(WidgetRef ref) => isSortType(ref, SortType.recent);

  bool isRecommendState(WidgetRef ref) => isSortType(ref, SortType.recommend);

  PagingController<int, ListItem> listPageController(WidgetRef ref) =>
      ref.watch(listPagingControllerProvider);

  AppTextStyles appTextStyles(WidgetRef ref) => ref.watch(appTextStylesFontSizeProvider);

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
