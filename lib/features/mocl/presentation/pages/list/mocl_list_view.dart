import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_state.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/widget/list_cupertino_app_bar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/widget/list_material_app_bar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/widget/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MoclListView extends ConsumerWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      RefreshIndicator.adaptive(
        color: Theme.of(context).indicatorColor,
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
          child: CustomScrollView(
            slivers: <Widget>[
              const _ListAppBar(),
              const _ListBody(),
            ],
          ),
        ),
      );
}

class _ListAppBar extends StatelessWidget {
  const _ListAppBar();

  @override
  Widget build(BuildContext context) => PlatformWidget(
        material: (_, __) => const ListMaterialAppBar(),
        cupertino: (_, __) => const ListCupertinoAppBar(),
      );
}

class _ListBody extends ConsumerWidget {
  const _ListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ListState state = ref.watch(listStateNotifierProvider);

    return SuperSliverList.separated(
      layoutKeptAliveChildren: true,
      extentPrecalculationPolicy: ref.watch(extentPrecalculationPolicyProvider),
      extentEstimation: (int? index, double crossAxisExtent) => 76.0,
      itemCount: state.items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (state.items.length == index) {
          if (state.error != null) {
            return _buildError(
              state.error!,
              () => ref.read(listStateNotifierProvider.notifier).retry(),
            );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlatformText(
              errorMessage,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            PlatformElevatedButton(
              onPressed: onRetry,
              child: PlatformText('재시도'),
            ),
            const SizedBox(height: 16),
            const DividerWidget(indent: 0, endIndent: 0),
          ],
        ),
      );
}
