import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';

import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

import '../../application/list_providers.dart';
import '../../../settings_page/application/settings_providers.dart';
import '../../../translation/application/translation_providers.dart';

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

  /// 이 게시판 안 글 검색 화면을 연다.
  Future<void> handleShowSearch(WidgetRef ref, BuildContext context) =>
      context.push<void>(Routes.search, extra: ref.read(mainItemProvider));

  void handleChangeSortType(WidgetRef ref, SortType sortType) {
    ref.read(sortTypeProvider.notifier).changeSortType(sortType);
    ref.read(listPagingControllerProvider.notifier).refresh();
  }

  void bindReadListener(WidgetRef ref) {
    ref.listen<({int id, int seq})>(readableStateProvider, (prev, next) {
      if (next.id <= 0 || prev == next) return;
      ref.read(listPagingControllerProvider.notifier).markAsReadById(next.id);
    });
  }

  /// 쪽이 늘 때마다 새 제목을 번역한다(번역을 켰을 때만 제목이 들어온다).
  void bindTitleTranslation(WidgetRef ref) {
    ref.listen<List<String>>(listTitlesToTranslateProvider, (_, titles) {
      if (titles.isEmpty) return;
      ref.read(titleTranslationsProvider.notifier).translate(titles).catchError(
        (Object e) {
          MoclLogger.w(() => '[translate] 목록 제목 번역 실패: $e');
        },
      );
    });
  }

  /// 설정 "번역해서 보기"를 켜고 끈다. 켜면 지금 목록 제목을 바로 번역하고,
  /// 실패하면 false(설정은 켜 둔 채, 다음 쪽에서 다시 시도한다).
  Future<bool> toggleListTranslation(WidgetRef ref) async {
    ref.read(autoTranslateProvider.notifier).toggle();
    if (!ref.read(listTranslationOnProvider)) return true;
    try {
      await ref
          .read(titleTranslationsProvider.notifier)
          .translate(ref.read(listTitlesToTranslateProvider));
      return true;
    } catch (e) {
      MoclLogger.w(() => '[translate] 목록 제목 번역 실패: $e');
      return false;
    }
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
