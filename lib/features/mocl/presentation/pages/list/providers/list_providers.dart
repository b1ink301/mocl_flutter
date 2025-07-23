import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../routes/mocl_routes.dart';

part 'list_providers.g.dart';

@riverpod
String listSmallTitle(Ref ref) => ref.watch(
  currentSiteTypeNotifierProvider.select((siteType) => siteType.title),
);

@Riverpod(dependencies: [mainItem])
String listTitle(Ref ref) =>
    ref.watch(mainItemProvider.select((MainItem item) => item.text));

@riverpod
MainItem mainItem(Ref ref) => throw UnimplementedError('mainItem');

@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double titleHeight(Ref ref, String text) {
  final TextStyle style = ref.watch(appbarTextStyleProvider);
  final double screenWidth = ref.watch(screenWidthProvider);
  final double availableWidth = screenWidth - 16 - 12;

  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 3,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: availableWidth);

  // 최소 높이와 비교하여 더 큰 값 반환
  return max(49, textPainter.height) + 27;
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
  return ref.read(getListProvider)(params);
}

@Riverpod(dependencies: [mainItem, reqListData, SortTypeNotifier])
class ListStateNotifier extends _$ListStateNotifier {
  @override
  Future<ListState> build() async {
    final initialPage = _initialPage();
    final mainItem = ref.watch(mainItemProvider);
    final sortType = ref.watch(sortTypeNotifierProvider);
    return _fetchData(mainItem, sortType, initialPage, const LastId());
  }

  Future<ListState> _fetchData(
    MainItem mainItem,
    SortType sortType,
    int page,
    LastId lastId, {
    List<ListItem> existingItems = const [], // 추가 로딩 시 기존 아이템
  }) async {
    final result = await ref.read(
      reqListDataProvider(mainItem, sortType, page, lastId).future,
    );

    return result.fold(
      (Failure failure) {
        // 기존 아이템이 있다면 기존 상태를 유지하면서 에러만 추가
        if (existingItems.isNotEmpty) {
          return ListState(
            items: existingItems,
            currentPage: page,
            // 실패했으므로 페이지는 이전 페이지 유지 또는 현재 요청 페이지
            lastId: lastId,
            // 실패했으므로 lastId도 이전 값 유지 또는 현재 요청 lastId
            isLoading: false,
            hasReachedMax: state.value?.hasReachedMax ?? false,
            error: failure.message,
          );
        }
        // 초기 로딩 실패 시
        return ListState.initial(
          page,
        ).copyWith(error: failure.message, isLoading: false);
      },
      (List<ListItem> newItems) {
        final bool hasReachedMax = _checkIfReachedMax(
          mainItem,
          newItems.isEmpty,
        );
        final allItems = existingItems + newItems;

        return ListState(
          items: allItems,
          currentPage: hasReachedMax ? page : page + 1,
          lastId: LastId(
            intId:
                newItems.lastOrNull?.id ??
                (allItems.isNotEmpty ? allItems.last.id : -1),
            stringId:
                newItems.lastOrNull?.url ??
                (allItems.isNotEmpty ? allItems.last.url : ''),
          ),
          isLoading: false,
          hasReachedMax: hasReachedMax,
          error: null,
        );
      },
    );
  }

  Future<void> loadMore() async {
    final ListState? currentStateValue = state.value;
    if (state.isLoading ||
        currentStateValue == null ||
        currentStateValue.hasReachedMax) {
      return;
    }

    state = AsyncData(
      currentStateValue.copyWith(isLoading: true, error: null),
    ); // 에러 초기화

    final MainItem mainItem = ref.read(mainItemProvider);
    final SortType sortType = ref.read(sortTypeNotifierProvider);

    final ListState newState = await _fetchData(
      mainItem,
      sortType,
      currentStateValue.currentPage,
      currentStateValue.lastId,
      existingItems: currentStateValue.items,
    );
    state = AsyncData(newState);
  }

  int _initialPage() {
    final siteType = ref.read(currentSiteTypeNotifierProvider);
    final int page = siteType == SiteType.clien ? 0 : 1;
    return page;
  }

  bool _checkIfReachedMax(MainItem mainItem, bool isEmpty) {
    // if (isEmpty) return true;

    // if (mainItem.siteType == SiteType.reddit) return true;
    if (mainItem.siteType != SiteType.clien) return false;
    return mainItem.board == "recommend";
  }

  void retry() {
    final ListState? currentStateValue = state.value;
    if (currentStateValue != null && !state.isLoading) {
      // loadMore 실패 후 재시도 시나리오
      if (currentStateValue.error != null) {
        loadMore(); // 마지막 loadMore를 재시도
      } else {
        refresh();
      }
    } else {
      // build 실패 시 (state가 AsyncError일 때)
      refresh();
    }
  }

  void refresh() {
    state = AsyncData(ListState.initial(_initialPage()));
    ref.invalidateSelf();
  }

  void markAsRead(int index) {
    final currentStateValue = state.value;
    if (currentStateValue == null ||
        index < 0 ||
        index >= currentStateValue.items.length) {
      return;
    }

    final List<ListItem> updatedItems = [...currentStateValue.items];
    updatedItems[index] = currentStateValue.items[index].copyWith(isRead: true);

    state = AsyncData(currentStateValue.copyWith(items: updatedItems));
  }
}

@Riverpod(dependencies: [listItem, listItemIndex])
void handleItemTap(Ref ref, BuildContext context) {
  final item = ref.watch(listItemProvider);
  if (item == null) {
    return;
  }
  try {
    final index = ref.watch(listItemIndexProvider);
    GoRouter.of(context).push(Routes.detail, extra: item).then((_) {
      if (context.mounted) {
        final readId = ref.read(readableStateNotifierProvider);
        if (readId == item.id && !item.isRead) {
          ref.read(listStateNotifierProvider.notifier).markAsRead(index);
        }
      }
    });
  } catch (e) {
    debugPrint('_handleItemTap = $e');
  }
}

@Riverpod(dependencies: [ListStateNotifier])
ListItem? getListItem(Ref ref, int index) {
  final item = ref.watch(
    listStateNotifierProvider.select((state) {
      try {
        return state.value?.items[index];
      } catch (e) {
        return null;
      }
    }),
  );
  return item;
}

@riverpod
class SortTypeNotifier extends _$SortTypeNotifier {
  @override
  SortType build() => SortType.recent;

  void changeSortType(SortType sortType) => state = sortType;
}

@Riverpod(dependencies: [listItemIndex, getListItem])
ListItem? listItem(Ref ref) {
  final index = ref.watch(listItemIndexProvider);
  return ref.watch(getListItemProvider(index));
}

@riverpod
int listItemIndex(Ref ref) => throw UnimplementedError();
