import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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
  Future<ListState> build() async => ListState.initial(_initialPage());

  void initialize() => loadMore();

  Future<void> loadMore() async {
    if (state.hasValue &&
        (state.value?.isLoading == true ||
            state.value?.hasReachedMax == true)) {
      return;
    }

    // state = AsyncData<ListState>(
    //   state.value?.copyWith(isLoading: true) ??
    //       ListState.empty().copyWith(isLoading: true),
    // );

    final MainItem mainItem = ref.read(mainItemProvider);
    final SortType sortType = ref.read(sortTypeNotifierProvider);
    final Either<Failure, List<ListItem>> result = await ref.read(
      reqListDataProvider(
        mainItem,
        sortType,
        state.value?.currentPage ?? _initialPage(),
        state.value?.lastId ?? const LastId(),
      ).future,
    );

    debugPrint('[loadMore] state=${state.runtimeType}');

    result.fold(
      (Failure failure) {
        state = AsyncData(
          state.requireValue.copyWith(error: failure.message, isLoading: false),
        );
      },
      (List<ListItem> newItems) {
        final bool hasReachedMax = _checkIfReachedMax(
          mainItem,
          newItems.isEmpty,
        );

        state = AsyncData<ListState>(
          state.requireValue.copyWith(
            isLoading: false,
            items: state.requireValue.items + newItems,
            currentPage: hasReachedMax
                ? state.requireValue.currentPage
                : state.requireValue.currentPage + 1,
            lastId: LastId(
              intId: newItems.lastOrNull?.id ?? -1,
              stringId: newItems.lastOrNull?.url ?? '',
            ),
            hasReachedMax: hasReachedMax,
          ),
        );
      },
    );
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

  void retry() => loadMore();

  void refresh() {
    ref.invalidateSelf();
    initialize();
  }

  void markAsRead(int index) {
    if (state.hasValue && index < 0 ||
        index >= state.requireValue.items.length) {
      return;
    }

    final List<ListItem> updatedItems = [...state.value!.items];
    updatedItems[index] = state.requireValue.items[index].copyWith(
      isRead: true,
    );

    state = AsyncData(state.requireValue.copyWith(items: updatedItems));
  }
}

@Riverpod(dependencies: [ListStateNotifier])
ListItem? getListItem(Ref ref, int index) {
  final item = ref.watch(
    listStateNotifierProvider.select((state) {
      try {
        return state.valueOrNull?.items[index];
      } catch (e) {
        return null;
      }
    }),
  );
  return item;
}

@Riverpod(keepAlive: true)
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
