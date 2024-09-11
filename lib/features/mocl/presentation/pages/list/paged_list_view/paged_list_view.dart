import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/paged_list_view/bloc/paged_list_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

typedef ItemTapCallback = void Function(BuildContext, ReadableListItem);

class PagedListView extends StatelessWidget {
  const PagedListView({
    super.key,
  });

  Widget _buildLoadingWithDivider() {
    return const Column(
      children: [
        LoadingWidget(),
        DividerWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => PagedSliverList<int, ReadableListItem>(
        pagingController: context.read<PagedListCubit>().pagingController,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ReadableListItem>(
          itemBuilder: (context, item, index) =>
              _buildCachedItem(context, item),
          newPageProgressIndicatorBuilder: (_) => _buildLoadingWithDivider(),
          firstPageProgressIndicatorBuilder: (_) => _buildLoadingWithDivider(),
        ),
        prototypeItem: CachedListItem.empty(),
      );

  Widget _buildCachedItem(
    BuildContext context,
    ReadableListItem item,
  ) =>
      CachedItemBuilder(
        key: ValueKey(item.item.id),
        builder: () => _buildCachedListItem(context, item),
      );

  Widget _buildCachedListItem(
    BuildContext context,
    ReadableListItem item,
  ) {
    final bloc = context.read<PagedListCubit>();
    return CachedListItem(
      key: ValueKey(item.item.id),
      item: item.item,
      isRead: item.isRead,
      textStyles: bloc.textStyles,
      onTap: () => bloc.onTap(context, item),
    );
  }
}
