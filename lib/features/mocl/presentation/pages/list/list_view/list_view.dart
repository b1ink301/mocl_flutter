import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class OptimizedListView extends ConsumerWidget {
  final MainItem mainItem;

  const OptimizedListView({super.key, required this.mainItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = TextStyles.getTextStyles(context);

    final vm = ref.watch(listViewModelProvider(mainItem).notifier);
    final resultAsync =
        ref.watch(listViewModelProvider(mainItem).select((vm) => vm.items));

    return resultAsync.when(
      data: (data) => _buildListView(
        data,
        textStyles,
        vm.fetchNextPage,
        vm.handleItemTap,
      ),
      error: (e, s) =>
          SliverToBoxAdapter(child: MessageWidget(message: e.toString())),
      loading: () => const SliverToBoxAdapter(child: LoadingWidget()),
    );
  }

  Widget _buildListView(
    List<ReadableListItem> items,
    TextStyles textStyles,
    Function() fetchNextPage,
    Function(BuildContext, ReadableListItem) handleItemTap,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          if (scrollInfo.metrics.extentAfter < 800) {
            fetchNextPage();
          }
        }
        return true;
      },
      child: SliverList.builder(
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
      ),
    );
  }
}
