import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

import '../../application/main_providers.dart';

mixin class MainEvent() {
  /// '편집 모드' 토글(켜질 때만 드래그 핸들·편집 버튼 노출).
  void handleToggleEdit(WidgetRef ref) =>
      ref.read(mainEditModeProvider.notifier).toggle();

  /// 게시판 선택 화면을 연다(안에서 카테고리 · 사이트를 골라 담는다).
  Future<void> handleAddButton(WidgetRef ref, BuildContext context) async =>
      context.push(Routes.setMainDlgFull);

  /// 검색창을 연다/닫는다. 닫을 때 검색어도 비워 목록이 곧바로 돌아온다.
  void openSearch(WidgetRef ref) =>
      ref.read(mainSearchOpenProvider.notifier).open();

  void closeSearch(WidgetRef ref) {
    ref.read(mainSearchQueryProvider.notifier).update('');
    ref.read(mainSearchOpenProvider.notifier).close();
  }

  void updateSearchQuery(WidgetRef ref, String query) =>
      ref.read(mainSearchQueryProvider.notifier).update(query);

  /// 카페 소구획을 접거나 펼친다.
  void toggleSubSection(WidgetRef ref, String key) =>
      ref.read(collapsedSubSectionsProvider.notifier).toggle(key);

  void selectTab(WidgetRef ref, int index) =>
      ref.read(mainTabIndexProvider.notifier).select(index);

  void changeSiteType(WidgetRef ref, SiteType siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  static List<Override> overridesProviderScope(double width) => [
    screenWidthProvider.overrideWithValue(width),
  ];

  /// 다른 탭에서 뒤로가기를 누르면 앱을 닫는 대신 첫 탭으로 돌아온다.
  /// 검색 중이라면 탭을 옮기기 전에 검색을 먼저 닫는다.
  void handlePop(WidgetRef ref, bool didPop) {
    if (didPop) {
      return;
    }
    if (ref.read(mainSearchOpenProvider)) {
      closeSearch(ref);
      return;
    }
    selectTab(ref, 0);
  }
}
