import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_state_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/list_app_bar.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/mocl_list_item.dart';

class MoclListView extends ConsumerWidget with ListEvent {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bindReadListener(ref);
    return RefreshIndicator.adaptive(
      color: Theme.of(context).focusColor,
      onRefresh: () async => handleRefresh(ref),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification &&
              notification.metrics.extentAfter < 600) {
            EasyThrottle.throttle(
              'list-fetch-throttle',
              const Duration(milliseconds: 1000),
              () => handleLoadMore(ref),
            );
            return true;
          }
          return false;
        },
        child: const CustomScrollView(
          cacheExtent: 1000,
          slivers: <Widget>[_ListAppBar(), _ListBody(), _ListFooter()],
        ),
      ),
    );
  }
}

class _ListAppBar extends StatelessWidget {
  const _ListAppBar();

  @override
  Widget build(BuildContext context) => const ListAppBar();
}

class _ListBody extends ConsumerWidget with ListState, ListEvent {
  const _ListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverList.separated(
    itemCount: listState(ref),
    itemBuilder: (_, index) =>
        ItemIndex(index: index, child: const MoclListItem()),
    separatorBuilder: (_, _) => const DividerWidget(),
  );
}

class _ListFooter extends ConsumerWidget with ListState, ListEvent {
  const _ListFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (hasReachedMax, error) = listFooterState(ref); // 에러와 최대 도달 여부만 구독

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: _ListFooterBody(
          error: error,
          hasReachedMax: hasReachedMax,
          retry: () => handleRetry(ref),
        ),
      ),
    );
  }
}

class _ListFooterBody extends StatelessWidget {
  final String? error;
  final bool hasReachedMax;
  final VoidCallback retry;

  const _ListFooterBody({
    required this.error,
    required this.hasReachedMax,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _ListFooterError(errorMessage: error!, onRetry: retry);
    } else if (hasReachedMax) {
      return const SizedBox.shrink();
    } else {
      return const Column(
        children: [DividerWidget(), LoadingWidget(), DividerWidget()],
      );
    }
  }
}

class _ListFooterError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ListFooterError({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) => Padding(
    padding: .all(16),
    child: Column(
      mainAxisAlignment: .center,
      children: [
        Text(errorMessage, maxLines: 4, overflow: .ellipsis),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: const Text('재시도')),
        const SizedBox(height: 8),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    ),
  );
}

class ItemIndex extends InheritedWidget {
  final int index;

  const ItemIndex({required this.index, required super.child, super.key});

  static int of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ItemIndex>()!.index;

  @override
  bool updateShouldNotify(ItemIndex oldWidget) => index != oldWidget.index;
}
