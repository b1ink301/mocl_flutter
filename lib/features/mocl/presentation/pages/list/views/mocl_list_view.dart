import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

typedef ItemTapCallback = Future<void> Function(ReadableListItem item);

class ListView extends StatelessWidget {
  final ListViewModel viewModel;

  const ListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final textStyles = TextStyles.getTextStyles(context);
    return _buildPagedList(textStyles);
  }

  Widget _buildPagedList(TextStyles textStyles) =>
      PagedSliverList<int, ReadableListItem>.separated(
        pagingController: viewModel.pagingController,
        addAutomaticKeepAlives: false,
        addSemanticIndexes: false,
        addRepaintBoundaries: false,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ReadableListItem>(
          itemBuilder: (context, item, index) {
            return RepaintBoundary(
              key: ValueKey(item.item.id.toString()),
              child: CachedListItem(
                siteType: viewModel.mainItem.siteType,
                item: item.item,
                isRead: item.isRead,
                textStyles: textStyles,
                onTap: () => viewModel.handleItemTap(context, item),
              ),
            );
          },
          newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
          firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        ),
        separatorBuilder: (context, index) => const DividerWidget(),
      );
}
