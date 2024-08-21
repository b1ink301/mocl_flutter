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

class ListView extends ConsumerStatefulWidget {
  final MainItem mainItem;

  const ListView({super.key, required this.mainItem});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewState();
}

class _ListViewState extends ConsumerState<ListView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listStateProvider.notifier).init(widget.mainItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = TextStyles.getTextStyles(context);
    return _buildPagedList(textStyles);
  }

  Widget _buildPagedList(TextStyles textStyles) =>
      ref.watch(listStateProvider).when(
            data: (data) => SliverList.separated(
              // addAutomaticKeepAlives: false,
              // addSemanticIndexes: false,
              // addRepaintBoundaries: false,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                return KeyedSubtree(
                  key: ValueKey(item.item.id.toString()),
                  child: _buildCachedListItem(context, item, textStyles),
                );
              },
              separatorBuilder: (context, index) => const DividerWidget(),
            ),
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: MessageWidget(message: error.toString()),
            ),
            loading: () => const SliverToBoxAdapter(key: ValueKey('loading'), child: LoadingWidget()),
          );

  CachedListItem _buildCachedListItem(
    BuildContext context,
    ReadableListItem item,
    TextStyles textStyles,
  ) =>
      CachedListItem(
        siteType: widget.mainItem.siteType,
        item: item.item,
        isRead: item.isRead,
        textStyles: textStyles,
        onTap: () async {
          await context.push(Routes.DETAIL, extra: item.item);

          var isRead = ref.watch(isReadStateProvider);
          if (isRead) {
            item.markAsRead();
            var params = SetReadFlagParams(
              siteType: widget.mainItem.siteType,
              boardId: item.item.id,
            );
            ref.read(setReadProvider).whenOrNull(
                  data: (setRead) => setRead.call(params),
                );
            ref.watch(isReadStateProvider.notifier).clear();
          }
          log('[PagedChildBuilderDelegate] isRead = $isRead');
        },
      );
}
