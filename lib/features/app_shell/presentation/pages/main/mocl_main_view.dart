import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/loading_widget.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    return BlocBuilder<MainDataBloc, MainDataState>(
      builder: (BuildContext context, MainDataState state) => switch (state) {
        StateSuccess() => state.data.isEmpty
            ? _buildEmptyView(textStyle)
            : _buildListView(context, state.data, textStyle),
        StateFailure() => _buildErrorView(context, state.message),
        StateRequireLogin() => _buildErrorView(context, state.message),
        _ => _buildLoadingView()
      },
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
        itemBuilder: (BuildContext context, int index) =>
            _buildListItem(context, items[index], textStyle),
        separatorBuilder: (_, _) => const DividerWidget(),
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
              color: Theme.of(context).focusColor,
            ),
          ),
        ),
      );

  Widget _buildIconView(String url) => CircleAvatar(
      radius: 24, backgroundImage: CachedNetworkImageProvider(url));
}
