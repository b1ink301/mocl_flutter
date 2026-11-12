import 'package:mocl_flutter/features/list_page/domain/list_density.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_accent_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_back_button.dart';
import 'package:mocl_flutter/core/presentation/widgets/failure_view.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/list_page/domain/search_failure.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_search_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_search_state_mixin.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';

import 'widgets/list_scope.dart';
import 'widgets/mocl_list_item.dart';
import 'widgets/search_field.dart';
import 'widgets/search_history_view.dart';

/// 게시판 안 글 검색 화면.
///
/// 검색 전에는 이 게시판의 최근 검색어를, 제출하면 결과를 쪽마다 이어 받아 보여 준다.
/// 결과 행은 게시판 목록과 같은 [MoclListItem] 이고 제목의 검색어를 강조한다.
/// 넓은 화면에서는 목록처럼 옆 칸에 글을 연다.
class const ListSearchPage({super.key}) extends StatelessWidget {
  /// "사이트 색" 모드면 그 게시판 사이트의 강조색으로 덮는다.
  static Widget init(MainItem item) => SiteAccentTheme(
    site: item.siteType,
    child: ProviderScope(
      overrides: ListSearchEvent.overridesProviderScope(item),
      child: const ListSearchPage(),
    ),
  );

  @override
  Widget build(BuildContext context) => ListDetailLayout<ListItem>(
    list: const _SearchScaffold(),
    detailBuilder: (_, item) => DetailPage.init(item),
    pushDetail: (context, item) =>
        context.push<void>(Routes.detail, extra: item),
    keyOf: (item) => item.id,
    detailRoutePath: Routes.detail,
  );
}

class const _SearchScaffold()
    extends HookConsumerWidget
    with ListSearchState, ListSearchEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bindSearchReadListener(ref);

    final ThemeData theme = Theme.of(context);
    // 배지는 이 화면의 강조색(설정 · 사이트 색)을 따른다.
    final AppTextStyles styles = searchTextStyles(ref)
        .withAccent(theme.colorScheme.primary);
    final MainItem board = searchBoardState(ref);
    final String query = searchQueryState(ref);
    final TextEditingController controller = useTextEditingController();
    final FocusNode focusNode = useFocusNode();

    // 처음 열면 바로 입력할 수 있게 한다(전환 애니메이션과 겹치지 않게 첫 프레임 뒤).
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (focusNode.canRequestFocus) focusNode.requestFocus();
      });
      return null;
    }, const []);

    void submit(String keyword) {
      final String word = keyword.trim();
      if (word.isEmpty) return;
      if (controller.text != word) {
        controller.value = TextEditingValue(
          text: word,
          selection: TextSelection.collapsed(offset: word.length),
        );
      }
      focusNode.unfocus();
      handleSubmitSearch(ref, word);
    }

    final String boardTitle = board.text.isNotEmpty
        ? board.text
        : searchSiteTitleState(ref);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const AppbarBackButton(),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SearchField(
              controller: controller,
              focusNode: focusNode,
              hintText: '$boardTitle에서 검색',
              textStyle: styles.titleTextStyle,
              onSubmitted: submit,
              onCleared: () => handleClearSearch(ref),
            ),
          ),
        ),
        body: query.isEmpty
            ? SearchHistoryView(
                boardTitle: boardTitle,
                history: searchHistoryState(ref),
                onSelected: submit,
                onRemoved: (word) => handleRemoveHistory(ref, word),
                onClearAll: () => handleClearHistory(ref),
                titleStyle: styles.titleTextStyle,
                smallStyle: styles.smallTextStyle,
              )
            : _SearchResults(query: query, board: board),
      ),
    );
  }
}

class const _SearchResults({
  required final String query,
  required final MainItem board,
}) extends ConsumerWidget with ListSearchState, ListSearchEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTextStyles styles = searchTextStyles(ref);
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final PagingController<int, ListItem> controller = searchPageController(
      ref,
    );

    Widget failure(Object? error) {
      final Object? cause = error is SearchFailure ? error.failure : error;
      final bool needsLogin = cause is NotLoginFailure;
      return FailureView(
        error: cause,
        titleStyle: styles.titleTextStyle,
        descriptionStyle: styles.smallTextStyle,
        onRetry: () => handleSearchRetry(ref),
        secondaryLabel: needsLogin ? '로그인' : null,
        onSecondary: needsLogin
            ? () async {
                await context.push<void>(Routes.login, extra: board.siteType);
                handleSearchRefresh(ref);
              }
            : null,
      );
    }

    return ListStyleScope(
      styles: styles,
      showCategory: searchShowCategoryState(ref),
      compact: searchCompactListState(ref)
          ? compactSpacingFor(MediaQuery.sizeOf(context).height)
          : null,
      child: SearchHighlightScope(
        query: query,
        child: RefreshIndicator.adaptive(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: () async => handleSearchRefresh(ref),
          child: PagingListener<int, ListItem>(
            controller: controller,
            builder: (context, state, fetchNextPage) => CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverReadableWidth(
                  sliver: PagedSliverList<int, ListItem>.separated(
                    state: state,
                    fetchNextPage: fetchNextPage,
                    builderDelegate: PagedChildBuilderDelegate<ListItem>(
                      itemBuilder: (context, item, index) => ListItemScope(
                        item: item,
                        child: const MoclListItem(),
                      ),
                      firstPageProgressIndicatorBuilder: (_) => const Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: LoadingWidget(),
                      ),
                      newPageProgressIndicatorBuilder: (_) =>
                          const LoadingWidget(),
                      firstPageErrorIndicatorBuilder: (_) => Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: failure(state.error),
                      ),
                      newPageErrorIndicatorBuilder: (_) => failure(state.error),
                      noItemsFoundIndicatorBuilder: (_) => Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: MessageView(
                          icon: Icons.search_off_rounded,
                          title: "'$query' 검색 결과가 없어요",
                          description: '다른 말로 검색해 보세요.',
                          titleStyle: styles.titleTextStyle,
                          descriptionStyle: styles.smallTextStyle,
                        ),
                      ),
                      noMoreItemsIndicatorBuilder: (_) =>
                          const SizedBox(height: 8),
                    ),
                    separatorBuilder: (_, _) => const PlainDividerWidget(),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: bottom + 8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
