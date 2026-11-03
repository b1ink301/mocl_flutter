import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/features/list_page/presentation/list_search_delegate.dart';

import '../../../../core/domain/entities/mocl_list_item.dart';
import '../../../../core/util/mocl_logger.dart';
import '../../application/list_providers.dart';

mixin class ListEvent() {
  void handleRefresh(WidgetRef ref) =>
      ref.read(listPagingControllerProvider.notifier).refresh();

  void handleRetry(WidgetRef ref) =>
      ref.read(listPagingControllerProvider.notifier).retry();

  void handleLoadMore(WidgetRef ref) =>
      ref.read(listPagingControllerProvider.notifier).loadMore();

  /// noMoreItems 상태에서 사용자가 명시적으로 다음 페이지 로드를 요청.
  /// (활성 게시판에서 필터로 인해 페이징이 잘못 종료된 경우의 복구 수단)
  void handleForceLoadMore(WidgetRef ref) =>
      ref.read(listPagingControllerProvider.notifier).forceLoadMore();

  /// 백그라운드 → 포그라운드 복귀 시 호출. 멈춘 fetch 가 있으면 강제 재시작.
  void handleAppResumed(WidgetRef ref) =>
      ref.read(listPagingControllerProvider.notifier).kickIfStale();

  Future<void> handleShowSearch(WidgetRef ref, BuildContext context) =>
      showSearch(
        context: context,
        delegate: ListSearchDelegate(item: ref.watch(mainItemProvider)),
      );

  void handleChangeSortType(WidgetRef ref, SortType sortType) {
    ref.read(sortTypeProvider.notifier).changeSortType(sortType);
    ref.read(listPagingControllerProvider.notifier).refresh();
  }

  void bindReadListener(WidgetRef ref) {
    ref.listen<int>(readableStateProvider, (prev, next) {
      if (next <= 0 || prev == next) return;
      ref.read(listPagingControllerProvider.notifier).markAsReadById(next);
    });
  }

  /// 넓은 화면이면 목록 옆 칸에서 열고, 아니면 상세 화면을 쌓는다.
  void handleItemTap(BuildContext context, ListItem item) {
    try {
      if (ListDetailScope.tryOpen(context, item)) return;
      context.push(Routes.detail, extra: item);
    } catch (e) {
      MoclLogger.e('_handleItemTap', error: e);
    }
  }

  static List<Override> overridesProviderScope(MainItem item) => [
    mainItemProvider.overrideWithValue(item),
  ];
}
