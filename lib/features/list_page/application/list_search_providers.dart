import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/list_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/list_page/data/search_history_store.dart';
import 'package:mocl_flutter/features/list_page/domain/search_failure.dart';
import 'package:mocl_flutter/features/list_page/domain/usecases/get_search_list.dart';
import 'package:mocl_flutter/features/mute/application/mute_providers.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'list_providers.dart';

part 'list_search_providers.g.dart';

/// 이 게시판에서 글 검색을 할 수 있는지(파서가 검색 주소 · 결과를 읽을 수 있는 사이트).
@Riverpod(dependencies: [mainItem])
bool listSearchSupported(Ref ref) {
  final siteType = ref.watch(mainItemProvider.select((i) => i.siteType));
  return ref.watch(currentParserProvider(siteType)).$1.supportsSearch;
}

/// 제출한 검색어. 입력 중인 글자가 아니라 키보드 "검색" · 최근 검색어를 눌렀을 때만 바뀐다
/// (글자마다 사이트에 요청하지 않으려고). 비어 있으면 검색 전 화면.
@Riverpod(dependencies: [mainItem])
class SearchQuery() extends _$SearchQuery {
  @override
  String build() => '';

  void submit(String keyword) => state = keyword.trim();

  void clear() => state = '';
}

/// 검색 결과 페이징. 첫 쪽 번호는 사이트마다 다르다(`firstSearchPage`).
///
/// 목록과 달리 lastId 의 `id >= lastId` 필터는 쓰지 않는다 — 검색 결과가 id 순서라는
/// 보장이 없다. 대신 이미 받은 글 id 로 중복을 거르고, 새 글이 하나도 없는 쪽이 오면
/// 끝으로 본다(끝을 넘기면 마지막 쪽을 다시 주는 사이트가 있다).
@Riverpod(dependencies: [mainItem, SearchQuery])
class SearchPagingController() extends _$SearchPagingController {
  /// 새 글이 없는 쪽을 만났는지. 뮤트로 비게 된 쪽과 구분하려고 따로 둔다.
  bool _exhausted = false;

  @override
  PagingController<int, ListItem> build() {
    _exhausted = false;
    final MainItem mainItem = ref.watch(mainItemProvider);
    final String keyword = ref.watch(searchQueryProvider);
    final int firstPage = ref
        .read(currentParserProvider(mainItem.siteType))
        .$1
        .firstSearchPage;

    late final PagingController<int, ListItem> controller;
    controller = PagingController<int, ListItem>(
      getNextPageKey: (state) {
        if (keyword.isEmpty || _exhausted) return null;
        final int? lastKey = state.keys?.lastOrNull;
        return lastKey == null ? firstPage : lastKey + 1;
      },
      fetchPage: (pageKey) async {
        // 레딧은 다음 쪽을 마지막 글 id(`after`) 로 받는다. 나머지 사이트는 쓰지 않는다.
        final ListItem? lastItem = controller.value.items?.lastOrNull;
        final LastId lastId = lastItem != null
            ? LastId(stringId: lastItem.url)
            : const LastId();
        final List<MuteRule> mutes = await ref.read(muteRulesProvider.future);
        final result = await ref.read(getSearchListUseCaseProvider)(
          GetSearchListParams(
            mainItem: mainItem,
            page: pageKey,
            lastId: lastId,
            sortType: SortType.recent,
            keyword: keyword,
          ),
        );
        return result.fold((Failure f) => throw SearchFailure(f), (items) {
          final Set<int> seen = {
            for (final ListItem i in controller.value.items ?? const []) i.id,
          };
          final List<ListItem> fresh = [
            for (final ListItem i in items)
              if (seen.add(i.id)) i,
          ];
          if (fresh.isEmpty) _exhausted = true;
          return applyMuteRules(fresh, mutes);
        });
      },
    );

    ref.onDispose(controller.dispose);
    return controller;
  }

  void refresh() {
    _exhausted = false;
    state.refresh();
  }

  void retry() {
    final ctrl = state;
    if (ctrl.value.error != null && ctrl.value.hasNextPage) {
      ctrl.value = ctrl.value.copyWith(error: null);
      ctrl.fetchNextPage();
    } else {
      refresh();
    }
  }

  void markAsReadById(int id) {
    final ctrl = state;
    final pages = ctrl.value.pages;
    if (pages == null) return;
    for (int p = 0; p < pages.length; p++) {
      final int idx = pages[p].indexWhere((e) => e.id == id);
      if (idx < 0) continue;
      if (pages[p][idx].isRead) return;
      final List<ListItem> page = List<ListItem>.from(pages[p]);
      page[idx] = page[idx].copyWith(isRead: true);
      final List<List<ListItem>> next = List<List<ListItem>>.from(pages);
      next[p] = page;
      ctrl.value = ctrl.value.copyWith(pages: next);
      return;
    }
  }
}

@Riverpod(keepAlive: true)
SearchHistoryStore searchHistoryStore(Ref ref) =>
    SearchHistoryStore(ref.watch(sharedPreferencesProvider));

/// 이 게시판의 최근 검색어(최신이 앞).
@Riverpod(dependencies: [mainItem])
class SearchHistory() extends _$SearchHistory {
  SearchHistoryStore get _store => ref.read(searchHistoryStoreProvider);

  MainItem get _board => ref.read(mainItemProvider);

  @override
  List<String> build() =>
      ref.watch(searchHistoryStoreProvider).load(ref.watch(mainItemProvider));

  void add(String keyword) => state = _store.add(_board, keyword);

  void remove(String keyword) => state = _store.remove(_board, keyword);

  void clear() {
    _store.clear(_board);
    state = const [];
  }
}
