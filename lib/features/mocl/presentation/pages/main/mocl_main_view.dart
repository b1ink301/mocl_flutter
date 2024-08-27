import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final resultAsync = ref.watch(mainViewModelProvider.select((vm) => vm.data));

    return resultAsync.when(
      data: (result) => _buildListView(context, result, textStyle),
      error: (e, s) => _buildErrorView(context),
      loading: () => const LoadingWidget(),
    );
  }

  Widget _buildListView(
      BuildContext context, List<MainItem> items, TextStyle? textStyle) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _buildListItem(context, items[index], textStyle),
      separatorBuilder: (_, __) => const DividerWidget(),
    );
  }

  Widget _buildListItem(
      BuildContext context, MainItem item, TextStyle? textStyle) {
    return ListTile(
      key: ValueKey(item.board),
      minTileHeight: 64,
      title: Text(item.text, style: textStyle),
      onTap: () => context.push(Routes.LIST, extra: item),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        '에러가 발생했습니다',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).indicatorColor,
        ),
      ),
    );
  }
}
