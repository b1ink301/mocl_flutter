import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/widget/list_cupertino_app_bar.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/widget/list_material_app_bar.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/widget/mocl_list_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';

class MoclListView extends ConsumerWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      RefreshIndicator.adaptive(
        color: Theme.of(context).focusColor,
        onRefresh: () async =>
            ref.read(listStateNotifierProvider.notifier).refresh(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.extentAfter < 100) {
              EasyThrottle.throttle(
                'list-fetch-throttle',
                const Duration(milliseconds: 1500),
                ref.read(listStateNotifierProvider.notifier).loadMore,
              );
              return true;
            }
            return false;
          },
          child: const CustomScrollView(
            physics: ClampingScrollPhysics(),
            cacheExtent: 1000,
            slivers: <Widget>[_ListAppBar(), _ListBody()],
          ),
        ),
      );
}

class _ListAppBar extends StatelessWidget {
  const _ListAppBar();

  @override
  Widget build(BuildContext context) => PlatformWidget(
    material: (_, _) => const ListMaterialAppBar(),
    cupertino: (_, _) => const ListCupertinoAppBar(),
  );
}

class _ListBody extends ConsumerWidget {
  const _ListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (count, hasReachedMax, error) = ref.watch(
      listStateNotifierProvider.select(
        (value) => value.when(
          data: (state) =>
              (state.items.length, state.hasReachedMax, state.error),
          loading: () => (0, false, null),
          error: (err, stack) => (0, false, err.toString()),
        ),
      ),
    );

    debugPrint(
      '[_ListBody] count=$count, hasReachedMax=$hasReachedMax, error=$error',
    );

    return SliverList.separated(
      // addRepaintBoundaries: false,
      addSemanticIndexes: false,
      addAutomaticKeepAlives: false,
      itemCount: count + 1,
      itemBuilder: (_, index) {
        if (count == index) {
          return _buildFooter(
            error,
            hasReachedMax,
            ref.read(listStateNotifierProvider.notifier).retry,
          );
        } else {
          return ProviderScope(
            overrides: [listItemIndexProvider.overrideWithValue(index)],
            child: const MoclListItem(),
          );
        }
      },
      separatorBuilder: (_, _) => const DividerWidget(),
    );
  }

  Widget _buildFooter(String? error, bool hasReachedMax, VoidCallback retry) {
    if (error != null) {
      return _buildError(error, retry);
    } else if (hasReachedMax) {
      return const SizedBox.shrink();
    } else {
      return const Column(children: [LoadingWidget(), DividerWidget()]);
    }
  }

  Widget _buildError(String errorMessage, VoidCallback onRetry) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlatformText(
          errorMessage,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 16),
        PlatformElevatedButton(onPressed: onRetry, child: PlatformText('재시도')),
        const SizedBox(height: 8),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    ),
  );
}
