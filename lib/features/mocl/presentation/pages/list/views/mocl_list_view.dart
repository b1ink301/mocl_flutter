import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

typedef ItemTapCallback = Future<void> Function(ReadableListItem item);

class ListView extends ConsumerWidget {
  final MainItem mainItem;
  static const double itemExtent = 73;

  const ListView({super.key, required this.mainItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = TextStyles.getTextStyles(context);
    return ref.watch(listStateProvider(item: mainItem)).when(
          data: (data) => data != null
              ? _buildContentWithLoading(context, ref, data, textStyles)
              : const LoadingWidget(),
          error: (error, stackTrace) => SliverToBoxAdapter(
            child: MessageWidget(message: error.toString()),
          ),
          loading: () => const SliverToBoxAdapter(
              key: ValueKey('loading'), child: LoadingWidget()),
        );
  }

  Widget _buildContentWithLoading(
    BuildContext context,
    WidgetRef ref,
    List<ReadableListItem> data,
    TextStyles textStyles,
  ) {
    final isLoading = ref.watch(isLoadingMoreProvider);
    return SliverList.separated(
      itemBuilder: (BuildContext context, int index) {
        if (!isLoading && data.length - 3 == index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(listStateProvider(item: mainItem).notifier)
                .loadMoreItems();
          });
        }
        if (index == data.length) {
          return isLoading ? const LoadingWidget() : const SizedBox.shrink();
        }
        return _buildCachedListItem(
          context,
          data[index],
          textStyles,
          (item) => _handleItemTap(context, ref, item),
        );
      },
      // findChildIndexCallback: (Key key) {
      //   final ValueKey<String> valueKey = key as ValueKey<String>;
      //   return data.indexWhere((item) => item.item.id.toString() == valueKey.value);
      // },
      itemCount: data.length + 1,
      separatorBuilder: (_, index) => const DividerWidget(),
    );
  }

  Widget _buildCachedListItem(
    BuildContext context,
    ReadableListItem item,
    TextStyles textStyles,
    ItemTapCallback onItemTap,
  ) =>
      RepaintBoundary(
        key: ValueKey(item.item.id.toString()),
        child: CachedListItem(
          siteType: mainItem.siteType,
          item: item.item,
          isRead: item.isRead,
          textStyles: textStyles,
          onTap: () => onItemTap(item),
        ),
      );

  Future<void> _handleItemTap(
      BuildContext context, WidgetRef ref, ReadableListItem item) async {
    await context.push(Routes.DETAIL, extra: item.item);
    var isRead = ref.watch(isReadStateProvider);
    if (isRead) {
      await _markItemAsRead(ref, item);
    }
    log('[PagedChildBuilderDelegate] isRead = $isRead');
  }

  Future<void> _markItemAsRead(WidgetRef ref, ReadableListItem item) async {
    item.markAsRead();
    var params =
        SetReadFlagParams(siteType: mainItem.siteType, boardId: item.item.id);
    await ref
        .read(setReadProvider)
        .whenOrNull(data: (setRead) => setRead.call(params));
    ref.read(isReadStateProvider.notifier).clear();
  }
}
