import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

part 'list_providers.g.dart';

@riverpod
String listSmallTitle(Ref ref) => ref.watch(
    currentSiteTypeNotifierProvider.select((siteType) => siteType.title));

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

class _CustomExtentPrecalculationPolicy extends ExtentPrecalculationPolicy {
  @override
  bool shouldPrecalculateExtents(ExtentPrecalculationContext context) => true;
}

@riverpod
ExtentPrecalculationPolicy extentPrecalculationPolicy(Ref ref) =>
    _CustomExtentPrecalculationPolicy();

@Riverpod(dependencies: [mainItem])
Future<Either<Failure, List<ListItem>>> reqListData(
    Ref ref, int page, int lastId) async {
  final MainItem mainItem = ref.watch(mainItemProvider);
  final SortType sortType = ref.watch(sortTypeNotifierProvider);

  final GetListParams params = GetListParams(
      mainItem: mainItem, page: page, lastId: lastId, sortType: sortType);

  return await ref.read(getListProvider)(params);
}

@riverpod
int _initialPage(Ref ref) {
  final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
  final int page = siteType == SiteType.clien ? 0 : 1;
  return page;
}

@Riverpod(dependencies: [mainItem, reqListData, SortTypeNotifier, _initialPage])
class ListStateNotifier extends _$ListStateNotifier {
  @override
  ListState build() {
    _initialize();
    return ListState.initial(ref.watch(_initialPageProvider));
  }

  // TODO: AsyncValue 로 변경해도.. 맘에 안든다.. 개선 필요함.
  void _initialize() => Future.microtask(() => loadMore());

  Future<void> loadMore() async {
    if (state.isLoading || state.hasReachedMax) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final Either<Failure, List<ListItem>> result = await ref
          .read(reqListDataProvider(state.currentPage, state.lastId).future);

      result.fold(
        (Failure failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (List<ListItem> newItems) {
          final bool hasReachedMax = _checkIfReachedMax(newItems.isEmpty);

          state = state.copyWith(
            items: [...state.items, ...newItems],
            isLoading: false,
            currentPage:
                hasReachedMax ? state.currentPage : state.currentPage + 1,
            lastId: newItems.isEmpty ? state.lastId : newItems.last.id,
            hasReachedMax: _checkIfReachedMax(newItems.isEmpty),
          );
        },
      );
    } catch (e) {
      final String error = e is Failure ? e.message : e.toString();
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  bool _checkIfReachedMax(bool isEmpty) {
    final MainItem mainItem = ref.read(mainItemProvider);
    // if (isEmpty) return true;
    if (mainItem.siteType != SiteType.clien) return false;
    return mainItem.board == "recommend";
  }

  void retry() => loadMore();

  void refresh() => ref.invalidateSelf();

  void markAsRead(int index) {
    if (index < 0 || index >= state.items.length) return;

    final List<ListItem> updatedItems = [...state.items];
    updatedItems[index] = state.items[index].copyWith(isRead: true);

    state = state.copyWith(items: updatedItems);
  }
}

@riverpod
class SortTypeNotifier extends _$SortTypeNotifier {
  @override
  SortType build() => SortType.recent;

  void changeSortType(SortType sortType) => state = sortType;
}
