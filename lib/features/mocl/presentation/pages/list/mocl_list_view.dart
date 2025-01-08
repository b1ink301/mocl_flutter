import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/pagination_notifier_provider.dart';
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
          ref.read(paginationNotifierProvider.notifier).refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent * 0.9) {
                ref.read(paginationNotifierProvider.notifier).fetchNextItems();
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
    final state = ref.watch(paginationNotifierProvider);
    final notifier = ref.read(paginationNotifierProvider.notifier);

    return SuperSliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // 현재 데이터의 마지막 인덱스인 경우
          if (index == notifier.listCount) {
            return state.maybeWhen(
              failed: (error) => _buildError(
                error,
                notifier.refresh,
              ),
              orElse: () =>
                  const Column(children: [LoadingWidget(), DividerWidget()]),
            );
          }

          // 일반 리스트 아이템 표시
          final item = notifier.getItem(index);
          return CachedItemBuilder(
            key: item.key,
            builder: () => MoclListItem(item: item),
          );
        },
        childCount: notifier.listCount + 1,
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
    final notifier = ref.read(paginationNotifierProvider.notifier);
    final smallTitle = notifier.smallTitle;
    final title = notifier.title;

    return AppbarDualTextWidget(
      smallTitle: smallTitle,
      title: title,
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(
          onPressed: () => notifier.refresh(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
