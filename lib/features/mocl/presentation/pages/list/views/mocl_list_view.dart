import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

import '../../../models/mocl_list_item_wrapper.dart';
import '../controllers/mocl_list_controller.dart';
import 'mocl_cached_list_item.dart';
import 'mocl_text_styles.dart';

class ListView extends GetView<ListController> {
  const ListView({super.key});

  @override
  Widget build(BuildContext context) => _buildList(context);

  PagedSliverList _buildList(BuildContext context) {
    final textStyles = TextStyles.getTextStyles(context);

    return PagedSliverList<int, ListItemWrapper>.separated(
      pagingController: controller.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ListItemWrapper>(
        itemBuilder: (context, item, index) => KeyedSubtree(
          key: ValueKey(item.item.id),
          child: CachedListItem(
            item: item,
            textStyles: textStyles,
            onTap: () => controller.toDetail(item),
          ),
        ),
        newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
      ),
      separatorBuilder: (context, index) => const Divider(
        indent: 16,
        endIndent: 4,
      ),
    );
  }
}
