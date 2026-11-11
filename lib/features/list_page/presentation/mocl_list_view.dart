import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/ads/presentation/list_ad_slots.dart';
import 'package:mocl_flutter/features/ads/presentation/state/ads_state_mixin.dart';
import 'package:mocl_flutter/features/ads/presentation/widgets/list_ad_separator.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/failure_view.dart';
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
    with ListEvent, ListState, AdsState {
  /// 끝에서 이만큼 남았을 때 다음 쪽을 받는다.
  static const int _prefetchThreshold = 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 리스트 아이템 읽음 처리 리스너 등록
    bindReadListener(ref);
    bindTitleTranslation(ref);

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
    final focusColor = Theme.of(context).colorScheme.primary;
    final bottom = MediaQuery.of(context).padding.bottom;
    final adSlots = useListAdSlots(listAdPlacementState(ref));

    // 에러 인디케이터 빌더 (중복 제거)
    Widget buildErrorIndicator(Object? error) => FailureView(
      error: error,
      descriptionStyle: styles.smallTextStyle,
      titleStyle: styles.titleTextStyle,
      onRetry: () => handleRetry(ref),
    );

    return ListStyleScope(
      styles: styles,
      showCategory: showCategoryState(ref),
      child: RefreshIndicator.adaptive(
        color: focusColor,
        onRefresh: () async => handleRefresh(ref),
        child: ListAdScope(
          slots: adSlots,
          child: PagingListener<int, ListItem>(
            controller: controller,
            builder: (context, state, fetchNextPage) => CustomScrollView(
              shrinkWrap: false,
              slivers: <Widget>[
                const ListAppBar(),
                // 넓은 화면에서는 글 목록을 읽기 좋은 폭으로 가운데 모은다.
                SliverReadableWidth(
                  sliver: PagedSliverList<int, ListItem>.separated(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate<ListItem>(
                      // 기본(3)이면 빠르게 넘길 때 응답(150~250ms)보다 먼저 끝에
                      // 닿아 스크롤이 멈췄다가, 붙는 순간 빈 화면만큼의 행을 한
                      // 프레임에 그린다. 반 쪽쯤 앞에서 미리 받는다.
                      invisibleItemsThreshold: _prefetchThreshold,
                      itemBuilder: (context, item, index) => ListItemScope(
                        item: item,
                        child: const MoclListItem(),
                      ),
                      firstPageProgressIndicatorBuilder: (_) =>
                          const _FirstPageLoading(),
                      newPageProgressIndicatorBuilder: (_) =>
                          const _NewPageLoading(),
                      firstPageErrorIndicatorBuilder: (_) =>
                          buildErrorIndicator(state.error),
                      newPageErrorIndicatorBuilder: (_) =>
                          buildErrorIndicator(state.error),
                      noItemsFoundIndicatorBuilder: (_) =>
                          const _NoItemsFound(),
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
                    // 글 사이사이에 목록 행 모양의 네이티브 광고를 넣는다.
                    separatorBuilder: (_, index) =>
                        ListAdSeparator(index: index, styles: styles),
                  ),
                ),
              ],
            ),
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
