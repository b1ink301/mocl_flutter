import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

typedef ItemTapCallback = Future<void> Function(ReadableListItem item);

class ListView extends StatelessWidget {
  final ListViewModel viewModel;

  const ListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) =>
      _buildPagedList(TextStyles.getTextStyles(context));

  Widget _buildPagedList(TextStyles textStyles) =>
      PagedSliverList<int, ReadableListItem>(
        pagingController: viewModel.pagingController,
        prototypeItem: CachedListItem(
          item: ListItem.empty(),
          isRead: ValueNotifier(false),
          onTap: () {},
          textStyles: textStyles,
        ),
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ReadableListItem>(
          itemBuilder: (context, item, index) =>
              _buildCachedItem(item, textStyles, context),
          newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
          firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        ),
      );

  Widget _buildCachedItem(
    ReadableListItem item,
    TextStyles textStyles,
    BuildContext context,
  ) =>
      _CachedItemBuilder(
        key: ValueKey(item.item.id),
        builder: () => CachedListItem(
          item: item.item,
          isRead: item.isRead,
          textStyles: textStyles,
          onTap: () => viewModel.handleItemTap(context, item),
        ),
      );
}

class _CachedItemBuilder extends StatefulWidget {
  final Widget Function() builder;

  const _CachedItemBuilder({super.key, required this.builder});

  @override
  _CachedItemBuilderState createState() => _CachedItemBuilderState();
}

class _CachedItemBuilderState extends State<_CachedItemBuilder> {
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedWidget = widget.builder();
  }

  @override
  Widget build(BuildContext context) => _cachedWidget;
}
