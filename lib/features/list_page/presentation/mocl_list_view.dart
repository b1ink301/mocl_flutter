import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_state_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/list_app_bar.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/mocl_list_item.dart';

import 'widgets/list_scope.dart';

class MoclListView extends ConsumerWidget with ListEvent, ListState {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 리스트 아이템 읽음 처리 리스너 등록
    bindReadListener(ref);

    final controller = listPageController(ref);

    // 에러 인디케이터 빌더 (중복 제거)
    Widget buildErrorIndicator(dynamic error) => _ListError(
      errorMessage: error?.toString() ?? '오류가 발생했습니다',
      onRetry: () => handleRetry(ref),
    );

    return RefreshIndicator.adaptive(
      color: Theme.of(context).focusColor,
      onRefresh: () async => handleRefresh(ref),
      child: PagingListener<int, ListItem>(
        controller: controller,
        builder: (context, state, fetchNextPage) {
          final styles = appTextStyles(ref);
          return ListStyleScope(
            styles: styles,
            child: CustomScrollView(
              slivers: <Widget>[
                const ListAppBar(),
                PagedSliverList<int, ListItem>.separated(
                  // addRepaintBoundaries: false,
                  // addAutomaticKeepAlives: false,
                  // addSemanticIndexes: false,
                  state: state,
                  fetchNextPage: fetchNextPage,
                  builderDelegate: PagedChildBuilderDelegate<ListItem>(
                    itemBuilder: (context, item, index) =>
                        ListItemScope(item: item, child: const MoclListItem()),
                    firstPageProgressIndicatorBuilder: (_) =>
                        const _FirstPageLoading(),
                    newPageProgressIndicatorBuilder: (_) =>
                        const _NewPageLoading(),
                    firstPageErrorIndicatorBuilder: (_) =>
                        buildErrorIndicator(state.error),
                    newPageErrorIndicatorBuilder: (_) =>
                        buildErrorIndicator(state.error),
                    noItemsFoundIndicatorBuilder: (_) => const _NoItemsFound(),
                    noMoreItemsIndicatorBuilder: (context) =>
                        SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ),
                  separatorBuilder: (_, _) => const DividerWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FirstPageLoading extends StatelessWidget {
  const _FirstPageLoading();

  @override
  Widget build(BuildContext context) {
    final textStyle = ListStyleScope.of(context).smallTextStyle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        const LoadingWidget(),
        Text(
          '로딩 중...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ],
    );
  }
}

class _NewPageLoading extends StatelessWidget {
  const _NewPageLoading();

  @override
  Widget build(BuildContext context) => const Column(
    children: [DividerWidget(), LoadingWidget(), DividerWidget()],
  );
}

class _NoItemsFound extends StatelessWidget {
  const _NoItemsFound();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(32),
    child: Center(child: Text('항목이 없습니다')),
  );
}

class _ListError extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ListError({required this.errorMessage, required this.onRetry});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage, maxLines: 4, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: const Text('재시도')),
        const SizedBox(height: 8),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    ),
  );
}
