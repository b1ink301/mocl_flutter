import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => RefreshIndicator(
        onRefresh: () async =>
            ref.read(mainItemsNotifierProvider.notifier).refresh(),
        child: const CustomScrollView(
          slivers: <Widget>[
            _MainAppBar(),
            _MainBody(),
          ],
        ),
      );
}

class _MainBody extends ConsumerWidget {
  const _MainBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      mainItemsNotifierProvider
          .select((AsyncValue<List<MainItem>> value) => value),
      (AsyncValue? previous, AsyncValue? next) {
        if (next is AsyncError && next.error is NotLoginFailure) {
          context.push<bool>(Routes.login).then((bool? result) {
            if (context.mounted && result == true) {
              ref.read(mainItemsNotifierProvider.notifier).refresh();
            }
          });
        }
      },
    );

    return ref.watch(mainItemsNotifierProvider).when(
          data: (List<MainItem> data) => _buildListView(context, data),
          error: (Object error, StackTrace stack) => _buildErrorView(
              context, error is Failure ? error.message : error.toString()),
          loading: () => _buildLoadingView(),
        );
  }

  Widget _buildLoadingView() => const SliverToBoxAdapter(
      child: Column(children: [LoadingWidget(), DividerWidget()]));

  Widget _buildEmptyView(TextStyle? textStyle) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            '항목이 없습니다.\n+ 버튼을 눌려서 항목을 추가해 주세요!',
            style: textStyle,
          ),
        ),
      );

  Widget _buildListView(
    BuildContext context,
    List<MainItem> items,
  ) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return items.isEmpty
        ? _buildEmptyView(textStyle)
        : SliverList.separated(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildListItem(context, items[index], textStyle),
            separatorBuilder: (_, __) => const DividerWidget(),
          );
  }

  Widget _buildListItem(
    BuildContext context,
    MainItem item,
    TextStyle? textStyle,
  ) =>
      ListTile(
        key: ValueKey(item.board),
        minTileHeight: 68,
        leading: item.icon.isEmpty ? null : _buildIconView(item.icon),
        title: Text(item.text, style: textStyle),
        onTap: () => context.push(Routes.list, extra: item),
      );

  Widget _buildErrorView(
    BuildContext context,
    String message,
  ) =>
      SliverPadding(
        padding: const EdgeInsets.all(12.0),
        sliver: SliverToBoxAdapter(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).indicatorColor,
            ),
          ),
        ),
      );

  Widget _buildIconView(String url) => CircleAvatar(
      radius: 24, backgroundImage: CachedNetworkImageProvider(url));
}

class _MainAppBar extends ConsumerWidget {
  const _MainAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color? backgroundColor =
        Theme.of(context).appBarTheme.backgroundColor;
    final String title = ref.watch(mainTitleProvider);
    final bool hasIconButton = ref.read(showAddButtonProvider);

    return SliverAppBar(
      title: MessageWidget(
        message: title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      flexibleSpace: Container(color: backgroundColor),
      backgroundColor: backgroundColor,
      titleSpacing: 0,
      floating: true,
      pinned: false,
      centerTitle: false,
      toolbarHeight: 64,
      actions: !hasIconButton
          ? null
          : [
              IconButton(
                onPressed: () => ref.read(handleAddButtonProvider(context)),
                icon: const Icon(Icons.add),
              )
            ],
    );
  }
}
