import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_stateless_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view/list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class OptimizedListView extends StatelessWidget {
  final ListViewModel viewModel;

  const OptimizedListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final textStyles = TextStyles.getTextStyles(context);

    return viewModel.items.when(
      data: (data) => _buildListView(data, textStyles),
      error: (e, s) => MessageWidget(message: e.toString()),
      loading: () => const LoadingWidget(),
    );
  }
  
  Widget _buildListView(List<ReadableListItem> items, TextStyles textStyles) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          if (scrollInfo.metrics.extentAfter < 800) {
            viewModel.fetchNextPage();
          }
        }
        return true;
      },
      child: SliverList.builder(
        itemCount: items.length, // +1 for loading indicator
        itemBuilder: (context, index) {
          // if (index == viewModel.items.length) {
          //   return viewModel.isLoading
          //       ? const LoadingWidget()
          //       : const SizedBox.shrink();
          // }
          final item = items[index];
          return CachedListItem(
            key: ValueKey(item.item.id),
            item: item.item,
            isRead: item.isRead,
            textStyles: textStyles,
            onTap: () => viewModel.handleItemTap(context, item),
          );
        },
      ),
    );
  }
}
