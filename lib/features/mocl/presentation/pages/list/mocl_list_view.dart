import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_search_delegate.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_state.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MoclListView extends ConsumerWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => RefreshIndicator(
        onRefresh: () async {
          ref.read(listStateNotifierProvider.notifier).refresh();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent * 0.9) {
                ref.read(listStateNotifierProvider.notifier).loadMore();
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
    final ListState state = ref.watch(listStateNotifierProvider);
    final ListStateNotifier notifier =
        ref.watch(listStateNotifierProvider.notifier);

    return SuperSliverList.separated(
      layoutKeptAliveChildren: true,
      extentPrecalculationPolicy: ref.watch(extentPrecalculationPolicyProvider),
      extentEstimation: (int? index, double crossAxisExtent) => 76.0,
      itemCount: state.items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (state.items.length == index) {
          if (state.error != null) {
            return _buildError(state.error!, () => notifier.retry());
          } else if (state.hasReachedMax) {
            return const SizedBox.shrink();
          } else {
            return const Column(children: [LoadingWidget(), DividerWidget()]);
          }
        }
        final ListItem item = state.items[index];
        return MoclListItem(
          key: item.key,
          item: item,
          index: index,
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const DividerWidget(),
    );
  }

  Widget _buildError(String errorMessage, VoidCallback onRetry) => Padding(
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
      );
}

class _ListAppbar extends ConsumerWidget {
  const _ListAppbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SortType sortType = ref.watch(sortTypeNotifierProvider);

    return AppbarDualTextWidget(
      smallTitle: ref.watch(listSmallTitleProvider),
      title: ref.watch(listTitleProvider),
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context,
                delegate:
                    ListSearchDelegate(item: ref.watch(mainItemProvider)));
          },
        ),
        PopupMenuButton<SortType>(
          icon: const Icon(Icons.sort),
          onSelected: (SortType value) {
            ref.read(sortTypeNotifierProvider.notifier).changeSortType(value);
            ref.watch(listStateNotifierProvider.notifier).refresh();
          },
          itemBuilder: (BuildContext context) {
            final TextStyle? textStyle =
                Theme.of(context).textTheme.headlineSmall;
            return [
              CheckedPopupMenuItem<SortType>(
                value: SortType.recent,
                checked: sortType == SortType.recent,
                child: Text('최신순', style: textStyle),
              ),
              CheckedPopupMenuItem<SortType>(
                value: SortType.recommend,
                checked: sortType == SortType.recommend,
                child: Text('추천순', style: textStyle),
              ),
            ];
          },
        ),
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (int value) {
            switch (value) {
              case 0:
                ref.read(listStateNotifierProvider.notifier).refresh();
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            final textStyle = Theme.of(context).textTheme.headlineSmall;
            return [
              PopupMenuItem(
                value: 0,
                child: Text('새로고침', style: textStyle),
              ),
            ];
          },
        )
      ],
    );
  }
}
