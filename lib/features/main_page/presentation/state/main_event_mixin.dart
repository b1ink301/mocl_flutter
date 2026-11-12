import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/issue_radar/application/issue_radar_providers.dart';
import 'package:mocl_flutter/features/library/application/library_providers.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import '../../application/main_providers.dart';
import '../mocl_main_page.dart' show MainTab;

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

  /// 탭을 바꾼다. 보관함 검색은 탭을 떠나면 닫는다.
  void selectTab(WidgetRef ref, int index) {
    if (ref.read(librarySearchProvider) != null) {
      ref.read(librarySearchProvider.notifier).close();
    }
    ref.read(mainTabIndexProvider.notifier).select(index);
  }

  /// 탭을 순번이 아니라 종류로 고른다(앱 바로가기 등 홈 밖에서 들어올 때).
  /// 이 빌드에 없는 탭(서버 없는 빌드의 이슈)이면 false.
  bool selectMainTab(WidgetRef ref, MainTab tab) {
    final int index = MainTab.visible(
      issues: ref.read(issueRadarAvailableProvider),
    ).indexOf(tab);
    if (index < 0) return false;
    if (ref.read(mainSearchOpenProvider)) closeSearch(ref);
    selectTab(ref, index);
    return true;
  }

  void changeSiteType(WidgetRef ref, SiteType siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  /// 뒤로가기는 '가장 최근에 연 것'부터 닫는다:
  /// 검색(게시판 · 보관함) → 다른 탭이면 첫 탭. 모두 닫혀 있으면 앱을 나간다.
  /// (사이트 드로어는 Scaffold 가 뒤로가기를 먼저 받아 닫는다.)
  void handlePop(WidgetRef ref, bool didPop) {
    if (didPop) {
      return;
    }
    if (ref.read(mainSearchOpenProvider)) {
      closeSearch(ref);
      return;
    }
    if (ref.read(librarySearchProvider) != null) {
      ref.read(librarySearchProvider.notifier).close();
      return;
    }
    selectTab(ref, 0);
  }
}
