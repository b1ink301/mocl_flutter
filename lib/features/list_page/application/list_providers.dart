import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/list_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/list_page/domain/usecases/get_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_providers.g.dart';

@riverpod
MainItem mainItem(Ref ref) => throw UnimplementedError('mainItem');

@riverpod
String listSmallTitle(Ref ref) =>
    ref.watch(currentSiteTypeProvider.select((siteType) => siteType.title));

@Riverpod(dependencies: [mainItem])
String listTitle(Ref ref) =>
    ref.watch(mainItemProvider.select((MainItem item) => item.text));

@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double titleHeight(Ref ref, String text) {
  final TextStyle style = ref.watch(appbarTextStyleProvider);
  final double screenWidth = ref.watch(screenWidthProvider);
  final double availableWidth = screenWidth - 16 - 12;

  return _titleHeightCache.getOrCalculate(text, style, availableWidth);
}

/// TextPainter layout 결과 캐시.
/// 스타일이나 화면 너비가 변경되면 자동 무효화됩니다.
final _titleHeightCache = _TitleHeightCache();

class _TitleHeightCache {
  final Map<String, double> _cache = {};
  TextStyle? _lastStyle;
  double? _lastWidth;

  double getOrCalculate(String text, TextStyle style, double availableWidth) {
    if (_lastStyle != style || _lastWidth != availableWidth) {
      _cache.clear();
      _lastStyle = style;
      _lastWidth = availableWidth;
    }

    return _cache.putIfAbsent(text, () {
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 3,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: 0, maxWidth: availableWidth);

      final double height = max(49.0, textPainter.height) + 27;
      textPainter.dispose();
      return height;
    });
  }
}

@Riverpod(dependencies: [mainItem])
Future<Either<Failure, List<ListItem>>> reqListData(
  Ref ref,
  MainItem mainItem,
  SortType sortType,
  int page,
  LastId lastId,
) {
  final GetListParams params = GetListParams(
    mainItem: mainItem,
    page: page,
    lastId: lastId,
    sortType: sortType,
  );
  return ref.read(getListUseCaseProvider)(params);
}

/// infinite_scroll_pagination 의 PagingController 를 Riverpod 으로 감싼다.
/// build() 는 mainItem/sortType 이 바뀔 때만 새 컨트롤러를 생성한다.
/// 이전 컨트롤러의 dispose 는 Riverpod 의 ref.onDispose 가 자동 처리.
@Riverpod(dependencies: [mainItem, reqListData, SortTypeNotifier])
class ListPagingController extends _$ListPagingController {
  @override
  PagingController<int, ListItem> build() {
    final MainItem mainItem = ref.watch(mainItemProvider);
    final SortType sortType = ref.watch(sortTypeProvider);
    final int initialPage = _initialPage();
    final bool singlePageBoard = _isSinglePageBoard(mainItem);
    late final PagingController<int, ListItem> controller;

    controller = PagingController<int, ListItem>(
      getNextPageKey: (state) {
        // 단일 페이지 게시판: 한 번 fetch 후 종료
        if (singlePageBoard && (state.keys?.isNotEmpty ?? false)) {
          return null;
        }
        // 마지막 페이지가 비어있으면 종료
        if (state.lastPageIsEmpty) return null;

        final int? lastKey = state.keys?.lastOrNull;
        return lastKey == null ? initialPage : lastKey + 1;
      },
      fetchPage: (pageKey) async {
        // LastId 가 필요한 사이트를 위해 직전 아이템에서 추출
        final ListItem? lastItem = controller.value.items?.lastOrNull;
        final LastId lastId = lastItem != null
            ? LastId(intId: lastItem.id, stringId: lastItem.url)
            : const LastId();

        final result = await ref.read(
          reqListDataProvider(mainItem, sortType, pageKey, lastId).future,
        );
        return result.fold(
          (failure) => throw _PagingFailure(failure.message),
          (items) => items,
        );
      },
    );

    ref.onDispose(controller.dispose);
    return controller;
  }

  int _initialPage() {
    final siteType = ref.read(currentSiteTypeProvider);
    return siteType == SiteType.clien ? 0 : 1;
  }

  bool _isSinglePageBoard(MainItem mainItem) =>
      mainItem.siteType == SiteType.clien && mainItem.board == 'recommend';

  void refresh() => state.refresh();

  void retry() {
    final ctrl = state;
    if (ctrl.value.error != null) {
      // 에러 클리어 후 같은 키로 재시도
      ctrl.value = ctrl.value.copyWith(error: null);
      ctrl.fetchNextPage();
    } else {
      ctrl.refresh();
    }
  }

  void loadMore() => state.fetchNextPage();

  void markAsReadById(int id) {
    final ctrl = state;
    final pages = ctrl.value.pages;
    if (pages == null) return;

    for (int p = 0; p < pages.length; p++) {
      final page = pages[p];
      final idx = page.indexWhere((e) => e.id == id);
      if (idx < 0) continue;
      if (page[idx].isRead) return;

      final newPage = List<ListItem>.from(page);
      newPage[idx] = page[idx].copyWith(isRead: true);
      final newPages = List<List<ListItem>>.from(pages);
      newPages[p] = newPage;

      ctrl.value = ctrl.value.copyWith(pages: newPages);
      return;
    }
  }
}

/// 컨트롤러가 보유한 flat items 를 Riverpod 상태로 노출.
/// detail/리스트 row 등 비-paging 영역에서 인덱스 기반 접근에 사용.
@Riverpod(dependencies: [ListPagingController])
class PagingItems extends _$PagingItems {
  @override
  List<ListItem> build() {
    final controller = ref.watch(listPagingControllerProvider);

    void listener() {
      state = _flatten(controller.value.pages);
    }

    controller.addListener(listener);
    ref.onDispose(() => controller.removeListener(listener));

    return _flatten(controller.value.pages);
  }

  static List<ListItem> _flatten(List<List<ListItem>>? pages) {
    if (pages == null) return const <ListItem>[];
    return List<ListItem>.unmodifiable([for (final p in pages) ...p]);
  }
}

@Riverpod(dependencies: [PagingItems])
ListItem? itemAtIndex(Ref ref, int index) {
  return ref.watch(
    pagingItemsProvider.select((items) {
      if (index >= 0 && index < items.length) return items[index];
      return null;
    }),
  );
}

@riverpod
class SortTypeNotifier extends _$SortTypeNotifier {
  @override
  SortType build() => SortType.recent;

  void changeSortType(SortType sortType) => state = sortType;
}

class _PagingFailure implements Exception {
  final String message;

  _PagingFailure(this.message);

  @override
  String toString() => message;
}
