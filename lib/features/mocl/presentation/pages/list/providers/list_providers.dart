import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

part 'list_providers.freezed.dart';

part 'list_providers.g.dart';

part 'pagination_state.dart';

@riverpod
String listSmallTitle(Ref ref) => ref.watch(
    currentSiteTypeNotifierProvider.select((siteType) => siteType.title));

@Riverpod(dependencies: [mainItem])
String listTitle(Ref ref) =>
    ref.watch(mainItemProvider.select((MainItem item) => item.text));

@Riverpod(dependencies: [
  mainItem,
  PageNumberNotifier,
  ItemListNotifier,
  _LastIdNotifier,
  // titleHeight,
])
class PaginationStateNotifier extends _$PaginationStateNotifier {
  @override
  Future<PaginationState> build() async => await _fetchData();

  Future<PaginationState> _fetchData() async {
    state = const AsyncValue.data(PaginationState.loading());

    final MainItem mainItem = ref.watch(mainItemProvider);
    final int page = ref.watch(pageNumberNotifierProvider);
    final int lastId = ref.read(_lastIdNotifierProvider);
    final PageNumberNotifier pageNumberNotifier =
        ref.read(pageNumberNotifierProvider.notifier);

    try {
      final GetListParams params =
          GetListParams(mainItem: mainItem, page: page, lastId: lastId);
      final Either<Failure, List<ListItem>> result =
          await ref.read(getListProvider)(params);
      final List<ListItem> data = result.getOrElse((f) => throw f);

      if (data.isNotEmpty) {
        ref.read(_lastIdNotifierProvider.notifier).update(data.last.id);
        ref.read(itemListNotifierProvider.notifier).addItems(data);
      }

      final bool isReachedMax = pageNumberNotifier.isReachedMax();
      return isReachedMax
          ? const PaginationState.reachedMax()
          : const PaginationState.loaded();
    } catch (e) {
      pageNumberNotifier.errorState();
      final String error = e is Failure ? e.message : e.toString();
      return PaginationState.failed(error);
    }
  }

  void invalidate() => state = const AsyncData(PaginationState.loaded());

  void retry() {
    ref.read(pageNumberNotifierProvider.notifier).clearErrorState();
    ref.invalidateSelf();
  }

  void refresh() {
    retry();
    ref.invalidate(pageNumberNotifierProvider);
    ref.invalidate(itemListNotifierProvider);
    ref.invalidate(_lastIdNotifierProvider);
  }
}

@riverpod
class ItemListNotifier extends _$ItemListNotifier {
  @override
  List<ListItem> build() => [];

  void addItems(List<ListItem> items) => state = [...state, ...items];

  void markAsReadItem(int index, ListItem item) {
    if (index < 0 || index >= state.length) return;
    state[index] = item.copyWith(isRead: true);
  }
}

@Riverpod(dependencies: [mainItem, CurrentSiteTypeNotifier])
class PageNumberNotifier extends _$PageNumberNotifier {
  bool _hasErrorState = false;

  @override
  int build() {
    final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
    return siteType == SiteType.clien ? 0 : 1;
  }

  bool isReachedMax() {
    if (_hasErrorState) {
      return true;
    }

    final (siteType, board) = ref
        .read(mainItemProvider.select((item) => (item.siteType, item.board)));
    if (siteType != SiteType.clien ||
        (siteType == SiteType.clien && board != "recommend")) {
      return false;
    }

    return true;
  }

  void errorState() => _hasErrorState = true;

  void clearErrorState() => _hasErrorState = false;

  void nextPage() {
    if (!isReachedMax()) {
      state++;
    }
  }

  void reset() {
    _hasErrorState = false;
    ref.invalidateSelf();
  }
}

@riverpod
MainItem mainItem(Ref ref) => throw UnimplementedError('mainItem');

@riverpod
class _LastIdNotifier extends _$LastIdNotifier {
  @override
  int build() => -1;

  void reset() => ref.invalidateSelf();

  void update(int newId) => state = newId;
}

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
