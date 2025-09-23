import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';

import '../../application/list_providers.dart';

mixin class ListState {
  (int, bool, String?) listState(WidgetRef ref) => ref.watch(
    pageStateProvider.select(
      (value) => value.when(
        data: (state) => (state.items.length, state.hasReachedMax, state.error),
        loading: () => (0, false, null),
        error: (err, stack) => (0, false, err.toString()),
      ),
    ),
  );

  String smallTitleState(WidgetRef ref) => ref.watch(listSmallTitleProvider);

  String titleState(WidgetRef ref) => ref.watch(listTitleProvider);

  SortType sortTypeState(WidgetRef ref) => ref.watch(sortTypeProvider);

  bool isSortType(WidgetRef ref, SortType sortType) =>
      ref.watch(sortTypeProvider.select((state) => state == sortType));

  bool isRecentState(WidgetRef ref) => isSortType(ref, SortType.recent);

  bool isRecommendState(WidgetRef ref) => isSortType(ref, SortType.recommend);

  bool hasInfoState(WidgetRef ref) => ref.watch(
    listItemProvider.select((item) => item?.info.isNotEmpty ?? false),
  );

  ListItem? listItemState(WidgetRef ref) => ref.watch(listItemProvider);

  (String, TextStyle) titleViewState(WidgetRef ref) {
    final (title, isRead) = ref.watch(
      listItemProvider.select(
        (item) => (item?.title ?? "", item?.isRead ?? false),
      ),
    );
    final textStyle = titleTextStyleState(ref, isRead);
    return (title, textStyle);
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

  (String, TextStyle) replyViewState(WidgetRef ref, BuildContext context) {
    final (reply, isRead) = ref.watch(
      listItemProvider.select(
        (item) => (item?.reply ?? "", (item?.isRead ?? false)),
      ),
    );
    final textStyle = badgeTextStyleState(ref, isRead);
    return (reply, textStyle);
  }

  String nickImageState(WidgetRef ref) => ref.watch(
    listItemProvider.select((item) => item?.userInfo.nickImage ?? ""),
  );

  (String, TextStyle) infoViewState(WidgetRef ref) {
    final (info, isRead) = ref.watch(
      listItemProvider.select(
        (item) => (item?.info ?? "", item?.isRead ?? false),
      ),
    );
    final textStyle = smallTitleTextStyleState(ref, isRead);
    return (info, textStyle);
  }

  TextStyle smallTitleTextStyleState(WidgetRef ref, bool isRead) => ref.watch(
    appTextStylesFontSizeProvider.select(
      (state) => (isRead ? state.readSmallTextStyle : state.smallTextStyle),
    ),
  );
}

