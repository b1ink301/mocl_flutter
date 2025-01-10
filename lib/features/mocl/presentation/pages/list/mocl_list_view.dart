import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_info.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MoclListView extends ConsumerWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => RefreshIndicator(
        onRefresh: () async {
          ref.read(paginationStateNotifierProvider.notifier).refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent * 0.9) {
                ref.read(pageNumberNotifierProvider.notifier).nextPage();
              }
            }
            return false;
          },
          child: const CustomScrollView(
            slivers: <Widget>[
              _ListAppbar(),
              _ListBody(),
            ],
          ),
        ),
      );
}

class _ListBody extends ConsumerWidget {
  const _ListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PaginationState> state =
        ref.watch(paginationStateNotifierProvider);
    final List<ListItem> items = ref.watch(itemListNotifierProvider);
    final int listCount = items.length;

    return SuperSliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == listCount) {
            return state.maybeWhen(
              error: (Object error, StackTrace stack) => _buildError(
                error.toString(),
                () => ref
                    .read(paginationStateNotifierProvider.notifier)
                    .refresh(),
              ),
              orElse: () =>
                  const Column(children: [LoadingWidget(), DividerWidget()]),
            );
          }

          final ListItem item = items[index];
          return CachedItemBuilder(
            key: item.key,
            builder: () => ProviderScope(overrides: [
              listItemInfoProvider
                  .overrideWithValue(item.toListItemInfo(context, index))
            ], child: const MoclListItem()),
          );
        },
        childCount: listCount + 1,
      ),
    );
  }

  Widget _buildError(String errorMessage, VoidCallback onRetry) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(errorMessage),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('재시도'),
                ),
              ],
            ),
          ),
          const DividerWidget(),
        ],
      );
}

class _ListAppbar extends ConsumerWidget {
  const _ListAppbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String smallTitle = ref.watch(listSmallTitleProvider);
    final String title = ref.watch(listTitleProvider);

    return AppbarDualTextWidget(
      smallTitle: smallTitle,
      title: title,
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(
          onPressed: () =>
              ref.read(paginationStateNotifierProvider.notifier).refresh(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
