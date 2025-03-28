import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/widget/list_cupertino_app_bar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/widget/list_material_app_bar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/widget/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MoclListView extends ConsumerStatefulWidget {
  const MoclListView({super.key});

  @override
  MoclListViewState createState() => MoclListViewState();
}

class MoclListViewState extends ConsumerState<MoclListView> {
  @override
  Widget build(BuildContext context) => RefreshIndicator.adaptive(
    color: Theme.of(context).indicatorColor,
    onRefresh:
        () async => ref.read(listStateNotifierProvider.notifier).refresh(),
    child: NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollEndNotification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent * 0.8) {
            ref.read(listStateNotifierProvider.notifier).loadMore();
            return true;
          }
        }
        return false;
      },
      child: const CustomScrollView(
        key: ValueKey('List-CustomScrollView'),
        physics: ClampingScrollPhysics(),
        cacheExtent: 100,
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
  Widget build(BuildContext context, WidgetRef ref) => _buildSliverList(ref);

  Widget _buildSliverList(WidgetRef ref) {
    final int listCount = ref.watch(getListCountProvider);

    return SuperSliverList.separated(
      layoutKeptAliveChildren: false,
      addAutomaticKeepAlives: false,
      extentPrecalculationPolicy: ref.watch(extentPrecalculationPolicyProvider),
      extentEstimation: (int? index, double crossAxisExtent) => 76.0,
      itemCount: listCount + 1,
      itemBuilder: (BuildContext context, int index) {
        if (listCount == index) {
          final String? error = ref.watch(getListErrorProvider);
          final bool hasReachedMax = ref.watch(hasReachedMaxProvider);
          if (error != null) {
            return _buildError(
              error,
              () => ref.read(listStateNotifierProvider.notifier).retry(),
            );
          } else if (hasReachedMax) {
            return const SizedBox.shrink();
          } else {
            return const Column(children: [LoadingWidget(), DividerWidget()]);
          }
        }
        final ListItem? item = ref.watch(getListItemProvider(index));
        if (item == null) {
          return null;
        }
        return CachedItemBuilder(
          key: item.key,
          builder: () => MoclListItem(item: item, index: index),
        );
      },
      separatorBuilder:
          (BuildContext context, int index) => const DividerWidget(),
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
        const SizedBox(height: 16),
        PlatformElevatedButton(onPressed: onRetry, child: PlatformText('재시도')),
        const SizedBox(height: 8),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    ),
  );
}
