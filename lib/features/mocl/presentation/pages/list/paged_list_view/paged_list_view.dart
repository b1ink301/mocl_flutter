import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/paged_list_view/paged_list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

typedef ItemTapCallback = Future<void> Function(ReadableListItem item);

class PagedListView extends StatelessWidget {
  final PagedListViewModel viewModel;

  const PagedListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) =>
      _buildPagedList(TextStyles.getTextStyles(context));

  Widget _buildPagedList(TextStyles textStyles) =>
      PagedSliverList<int, ReadableListItem>.separated(
        pagingController: viewModel.pagingController,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ReadableListItem>(
          itemBuilder: (context, item, index) => CachedListItem(
            key: ValueKey(item.item.id),
            item: item.item,
            isRead: item.isRead,
            textStyles: textStyles,
            onTap: () => viewModel.handleItemTap(context, item),
          ),
          newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
          firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        ),
        separatorBuilder: (BuildContext context, int index) =>
            const DividerWidget(),
      );
}
