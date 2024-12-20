import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return BlocBuilder<MainDataBloc, MainDataState>(
      builder: (context, state) => state.map(
        initial: (_) => _buildLoadingView(),
        loading: (_) => _buildLoadingView(),
        success: (state) => state.data.isEmpty
            ? _buildEmptyView(textStyle)
            : _buildListView(context, state.data, textStyle),
        failure: (state) => _buildErrorView(context, state.message),
        requireLogin: (state) => _buildErrorView(context, state.message),
      ),
    );
  }

  Widget _buildLoadingView() => const SliverToBoxAdapter(
      child: Column(children: [LoadingWidget(), DividerWidget()]));

  Widget _buildEmptyView(TextStyle? textStyle) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            '항목이 없습니다, + 버튼을 눌려서 항목을 추가해 주세요!',
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
