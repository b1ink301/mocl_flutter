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
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 300) {
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
          slivers: <Widget>[_ListAppBar(), _ListBody()],
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
  Widget build(BuildContext context, WidgetRef ref) {
    final (count, hasReachedMax, error) = listState(ref);

    return SliverPadding(
      padding: .only(bottom: MediaQuery.of(context).padding.bottom),
      sliver: SliverList.separated(
        // addRepaintBoundaries: false,
        // addAutomaticKeepAlives: false,
        addSemanticIndexes: false,
        itemCount: count + 1,
        itemBuilder: (context, index) => (count == index)
            ? _ListFooter(
                error: error,
                hasReachedMax: hasReachedMax,
                retry: () => handleRetry(ref),
              )
            : ProviderScope(
                key: ValueKey(index),
                overrides: ListEvent.overridesProviderScopeForRow(index),
                child: const MoclListItem(),
              ),
        separatorBuilder: (_, _) => const DividerWidget(),
      ),
    );
  }
}

class _ListFooter extends StatelessWidget {
  final String? error;
  final bool hasReachedMax;
  final VoidCallback retry;

  const _ListFooter({
    required this.error,
    required this.hasReachedMax,
    required this.retry,
  });

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _ListError(errorMessage: error!, onRetry: retry);
    } else if (hasReachedMax) {
      return const SizedBox.shrink();
    } else {
      return const Column(children: [LoadingWidget(), DividerWidget()]);
    }
  }
}

class _ListError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ListError({required this.errorMessage, required this.onRetry});

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
