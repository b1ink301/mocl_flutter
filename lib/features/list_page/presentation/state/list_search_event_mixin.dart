import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';

import '../../application/list_providers.dart';
import '../../application/list_search_providers.dart';

mixin class ListSearchEvent() {
  /// 검색어를 제출한다(최근 검색어에도 넣는다). 빈 검색어는 무시.
  void handleSubmitSearch(WidgetRef ref, String keyword) {
    final String word = keyword.trim();
    if (word.isEmpty) return;
    ref.read(searchHistoryProvider.notifier).add(word);
    final SearchQuery query = ref.read(searchQueryProvider.notifier);
    // 같은 검색어를 다시 제출하면 처음부터 다시 받는다.
    if (ref.read(searchQueryProvider) == word) {
      ref.read(searchPagingControllerProvider.notifier).refresh();
    } else {
      query.submit(word);
    }
  }

  /// 검색 전 화면(최근 검색어)으로 돌아간다.
  void handleClearSearch(WidgetRef ref) =>
      ref.read(searchQueryProvider.notifier).clear();

  void handleSearchRefresh(WidgetRef ref) =>
      ref.read(searchPagingControllerProvider.notifier).refresh();

  void handleSearchRetry(WidgetRef ref) =>
      ref.read(searchPagingControllerProvider.notifier).retry();

  void handleRemoveHistory(WidgetRef ref, String keyword) =>
      ref.read(searchHistoryProvider.notifier).remove(keyword);

  void handleClearHistory(WidgetRef ref) =>
      ref.read(searchHistoryProvider.notifier).clear();

  /// 검색 결과에서 연 글을 읽음으로 표시한다(상세가 읽은 글 id 를 알려 준다).
  void bindSearchReadListener(WidgetRef ref) {
    ref.listen<({int id, int seq})>(readableStateProvider, (prev, next) {
      if (next.id <= 0 || prev == next) return;
      ref.read(searchPagingControllerProvider.notifier).markAsReadById(next.id);
    });
  }

  static List<Override> overridesProviderScope(MainItem item) => [
    mainItemProvider.overrideWithValue(item),
  ];
}
