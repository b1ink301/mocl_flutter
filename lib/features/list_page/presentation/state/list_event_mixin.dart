import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/list_page/presentation/list_search_delegate.dart';

import '../../../../core/util/mocl_logger.dart';
import '../../application/list_providers.dart';

mixin class ListEvent {
  void handleRefresh(WidgetRef ref) =>
      ref.read(pageStateProvider.notifier).refresh();

  void handleRetry(WidgetRef ref) =>
      ref.read(pageStateProvider.notifier).retry();

  void handleLoadMore(WidgetRef ref) =>
      ref.read(pageStateProvider.notifier).loadMore();

  Future<void> handleShowSearch(WidgetRef ref, BuildContext context) =>
      showSearch(
        context: context,
        delegate: ListSearchDelegate(item: ref.watch(mainItemProvider)),
      );

  void handleChangeSortType(WidgetRef ref, SortType sortType) {
    ref.read(sortTypeProvider.notifier).changeSortType(sortType);
    ref.read(pageStateProvider.notifier).refresh();
  }

  void bindReadListener(WidgetRef ref) {
    ref.listen<int>(readableStateProvider, (prev, next) {
      if (next <= 0 || prev == next) return;
      ref.read(pageStateProvider.notifier).markAsReadById(next);
    });
  }

  void handleItemTap(WidgetRef ref, BuildContext context) {
    final item = ref.read(listItemProvider);
    if (item == null) return;
    try {
      GoRouter.of(context).push(Routes.detail, extra: item);
    } catch (e) {
      MoclLogger.log('_handleItemTap = $e');
    }
  }

  static List<Override> overridesProviderScopeForRow(int index) => [
    listItemIndexProvider.overrideWithValue(index),
  ];

  static List<Override> overridesProviderScope(
    BuildContext context,
    MainItem item,
  ) => [
    screenWidthProvider.overrideWithValue(MediaQuery.of(context).size.width),
    mainItemProvider.overrideWithValue(item),
  ];
}
