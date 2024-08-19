import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

import '../../../models/mocl_list_item_wrapper.dart';
import '../../../routes/mocl_app_pages.dart';
import '../../../widgets/divider_widget.dart';
import 'mocl_cached_list_item.dart';
import 'mocl_text_styles.dart';

class ListView extends ConsumerStatefulWidget {
  final MainItem mainItem;

  const ListView({super.key, required this.mainItem});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewState();
}

class _ListViewState extends ConsumerState<ListView> {
  late final ListState listState;

  @override
  void initState() {
    super.initState();

    listState = ref.read(listStateProvider.notifier)..init(widget.mainItem);
  }

  @override
  void dispose() {
    listState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = TextStyles.getTextStyles(context);
    return _buildPagedList(textStyles);
  }

  Widget _buildPagedList(TextStyles textStyles) =>
      PagedSliverList<int, ListItemWrapper>.separated(
        pagingController: listState.pagingController,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<ListItemWrapper>(
          itemBuilder: (context, item, index) => CachedListItem(
            siteType: widget.mainItem.siteType,
            item: item,
            textStyles: textStyles,
            onTap: () async {
              var result = await context.push(Routes.DETAIL, extra: item.item);
              debugPrint('[PagedChildBuilderDelegate] result = $result');
            },
          ),
          newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
          firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        ),
        separatorBuilder: (context, index) => const DividerWidget(),
      );
}
