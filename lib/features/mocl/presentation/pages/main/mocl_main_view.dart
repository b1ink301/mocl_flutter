import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/view_model/main_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    final resultAsync = ref.watch(mainViewModelProvider);

    return resultAsync.maybeWhen(
      success: (data) => _buildListView(context, data, textStyle),
      failure: (message) => _buildErrorView(context, message),
      orElse: () => _buildLoadingView(),
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
    TextStyle? textStyle,
  ) =>
      SliverList.separated(
        itemCount: items.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, items[index], textStyle),
        separatorBuilder: (_, __) => const DividerWidget(),
      );

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
