import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/domain/entities/sort_type.dart';
import '../../../../../di/app_provider.dart';
import '../../routes/mocl_app_pages.dart';
import 'list_providers.dart';
import 'list_search_delegate.dart';

mixin class ListEvent {
  void handleRefresh(WidgetRef ref) =>
      ref.read(pageStateProvider.notifier).refresh();

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
      debugPrint('_handleItemTap = $e');
    }
  }
}
