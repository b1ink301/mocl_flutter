import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/di/app_provider.dart';

import '../../../../../core/domain/entities/mocl_list_item.dart';
import '../../../../../core/domain/entities/sort_type.dart';
import 'list_providers.dart';

mixin class ListState {
  String smallTitleState(WidgetRef ref) => ref.watch(listSmallTitleProvider);

  String titleState(WidgetRef ref) => ref.watch(listSmallTitleProvider);

  SortType sortTypeState(WidgetRef ref) => ref.watch(sortTypeProvider);

  bool isSortType(WidgetRef ref, SortType sortType) =>
      ref.watch(sortTypeProvider.select((state) => state == sortType));

  bool isRecentState(WidgetRef ref) => isSortType(ref, SortType.recent);

  bool isRecommendState(WidgetRef ref) => isSortType(ref, SortType.recommend);

  bool hasInfoState(WidgetRef ref) => ref.watch(
    listItemProvider.select((item) => item?.info.isNotEmpty ?? false),
  );

  ListItem? listItemState(WidgetRef ref) => ref.watch(listItemProvider);

  (String, bool) titleViewState(WidgetRef ref) => ref.watch(
    listItemProvider.select(
      (item) => (item?.title ?? "", item?.isRead ?? false),
    ),
  );

  TextStyle titleTextStyleState(WidgetRef ref, bool isRead) => ref.watch(
    appTextStylesFontSizeProvider.select(
      (state) => (isRead ? state.readTitleTextStyle : state.titleTextStyle),
    ),
  );

  (String, bool) replyViewState(WidgetRef ref) => ref.watch(
    listItemProvider.select(
      (item) => (item?.reply ?? "", item?.isRead ?? false),
    ),
  );

  String nickImageState(WidgetRef ref) => ref.watch(
    listItemProvider.select((item) => item?.userInfo.nickImage ?? ""),
  );

  (String, bool) infoViewState(WidgetRef ref) => ref.watch(
    listItemProvider.select(
      (item) => (item?.info ?? "", item?.isRead ?? false),
    ),
  );

  TextStyle smallTitleTextStyleState(WidgetRef ref, bool isRead) => ref.watch(
    appTextStylesFontSizeProvider.select(
          (state) => (isRead ? state.readTitleTextStyle : state.titleTextStyle),
    ),
  );
}
