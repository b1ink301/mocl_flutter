import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

typedef ItemTapCallback = void Function(BuildContext, ReadableListItem);

class PagedListView extends StatelessWidget {
  final TextStyles _textStyles;
  final ItemTapCallback _onTap;
  final PagingController<int, ReadableListItem> _pagingController;

  const PagedListView({
    super.key,
    required PagingController<int, ReadableListItem> pagingController,
    required TextStyles textStyles,
    required ItemTapCallback onTap,
  })  : _pagingController = pagingController,
        _textStyles = textStyles,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) =>
      PagedSliverList<int, ReadableListItem>.separated(
        pagingController: _pagingController,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ReadableListItem>(
          itemBuilder: (context, item, index) =>
              _buildCachedItem(context, item),
          newPageProgressIndicatorBuilder: (_) => const LoadingWidget(),
          firstPageProgressIndicatorBuilder: (_) => const LoadingWidget(),
        ),
        separatorBuilder: (_, idx) => const DividerWidget(),
      );

  Widget _buildCachedItem(
    BuildContext context,
    ReadableListItem item,
  ) =>
      _CachedItemBuilder(
        key: ValueKey(item.item.id),
        builder: () => CachedListItem(
          item: item.item,
          isRead: item.isRead,
          textStyles: _textStyles,
          onTap: () => _onTap(context, item),
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
