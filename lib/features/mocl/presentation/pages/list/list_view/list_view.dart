import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class OptimizedListView extends StatelessWidget {
  final MainItem mainItem;

  const OptimizedListView({super.key, required this.mainItem});

  @override
  Widget build(BuildContext context) {
    final textStyles = TextStyles.getTextStyles(context);

    // final vm = ref.watch(listViewModelProvider(mainItem).notifier);
    // final result = ref.watch(listViewModelProvider(mainItem));

    final Result result = ResultLoading();
    // log('OptimizedListView result=$result');

    if (result is ResultSuccess<List<ReadableListItem>>) {
      return _buildListView(
        result.data,
        textStyles,
        (a, b) {},
      );
    } else if (result is ResultLoading) {
      return const SliverToBoxAdapter(child: LoadingWidget());
    } else if (result is ResultFailure) {
      return SliverToBoxAdapter(
          child: MessageWidget(message: result.toString()));
    } else {
      return const SliverToBoxAdapter(
          child: MessageWidget(message: 'Unknown Error!'));
    }
  }

  Widget _buildListView(
    List<ReadableListItem> items,
    TextStyles textStyles,
    Function(BuildContext, ReadableListItem) handleItemTap,
  ) {
    return SliverList.builder(
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const LoadingWidget();
        }
        final item = items[index];
        return CachedListItem(
          key: ValueKey(item.item.id),
          item: item.item,
          isRead: item.isRead,
          textStyles: textStyles,
          onTap: () => handleItemTap(context, item),
        );
      },
    );
  }
}
