import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
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

  void handleItemTap(WidgetRef ref, BuildContext context) {
    final item = ref.read(listItemProvider);
    if (item == null) {
      return;
    }
    try {
      final index = ref.read(listItemIndexProvider);
      GoRouter.of(context).push(Routes.detail, extra: item).then((_) {
        if (context.mounted) {
          final readId = ref.read(readableStateProvider);
          if (readId == item.id && !item.isRead) {
            ref.read(pageStateProvider.notifier).markAsRead(index);
          }
        }
      });
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
    appTextStylesProvider.overrideWithValue(AppTextStyles.of(context)),
    appbarTextStyleProvider.overrideWithValue(
      !kIsWeb && Platform.isIOS
          ? CupertinoTheme.of(
              context,
            ).textTheme.navLargeTitleTextStyle.copyWith(height: 1.3)
          : AppTextStyles.of(
              context,
            ).titleTextStyle.copyWith(color: Colors.white),
    ),
    mainItemProvider.overrideWithValue(item),
  ];
}
