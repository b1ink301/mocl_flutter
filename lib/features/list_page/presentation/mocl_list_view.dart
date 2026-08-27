import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_state_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/list_app_bar.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/mocl_list_item.dart';

import '../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../core/presentation/widgets/plain_text.dart';
import 'widgets/list_scope.dart';

class const MoclListView({super.key})
    extends HookConsumerWidget
    with ListEvent, ListState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 리스트 아이템 읽음 처리 리스너 등록
    bindReadListener(ref);

    // 백그라운드 → 포그라운드 복귀 시 멈춘 fetch 강제 재시작.
    // (Doze 등으로 in-flight 요청이 영영 resolve 되지 않아 isLoading 이
    //  영구 true 가 되는 케이스 복구)
    useOnAppLifecycleStateChange((previous, current) {
      if (current == AppLifecycleState.resumed) {
        handleAppResumed(ref);
      }
    });

    final controller = listPageController(ref);
    final singlePageBoard = isSinglePageBoardState(ref);
    final styles = appTextStyles(ref);
    final focusColor = Theme.of(context).focusColor;
    final bottom = MediaQuery.of(context).padding.bottom;

    // 에러 인디케이터 빌더 (중복 제거)
    Widget buildErrorIndicator(dynamic error) => _ListError(
      errorMessage: '로딩 중 오류가 발생했습니다',
      onRetry: () => handleRetry(ref),
      textStyle: styles.smallTextStyle,
    );

    return ListStyleScope(
      styles: styles,
      child: RefreshIndicator.adaptive(
        color: focusColor,
        onRefresh: () async => handleRefresh(ref),
        child: PagingListener<int, ListItem>(
          controller: controller,
          builder: (context, state, fetchNextPage) => CustomScrollView(
            shrinkWrap: false,
            slivers: <Widget>[
              const ListAppBar(),
              PagedSliverList<int, ListItem>.separated(
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
                  // 뮤트/중복 필터로 페이징이 잘못 종료된 경우를 위한 복구 수단.
                  // 단일 페이지 게시판은 실제로 끝이므로 버튼을 노출하지 않는다.
                  noMoreItemsIndicatorBuilder: (context) => singlePageBoard
                      ? SizedBox(height: bottom)
                      : _NoMoreItems(
                          bottomPadding: bottom,
                          onLoadMore: () => handleForceLoadMore(ref),
                          textStyle: styles.smallTextStyle,
                        ),
                ),
                separatorBuilder: (_, _) => const PlainDividerWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _FirstPageLoading() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final smallTextStyle = ListStyleScope.of(context).smallTextStyle;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        const LoadingWidget(),
        PlainText(
          '로딩 중...',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: smallTextStyle,
        ),
      ],
    );
  }
}

class const _NewPageLoading() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Column(
    children: [PlainDividerWidget(), LoadingWidget(), PlainDividerWidget()],
  );
}

class const _NoItemsFound() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final smallTextStyle = ListStyleScope.of(context).smallTextStyle;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(child: PlainText('항목이 없습니다', style: smallTextStyle)),
    );
  }
}

class const _NoMoreItems({
  required final double bottomPadding,
  required final VoidCallback onLoadMore,
  required final TextStyle textStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: 8, bottom: bottomPadding + 8),
    child: Center(
      child: TextButton(
        onPressed: onLoadMore,
        child: PlainText('더 불러오기', style: textStyle),
      ),
    ),
  );
}

class const _ListError({
  required final String errorMessage,
  required final VoidCallback onRetry,
  required final TextStyle textStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlainText(
          errorMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          child: PlainText('재시도', style: textStyle),
        ),
      ],
    ),
  );
}
