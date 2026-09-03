import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

import '../../application/main_providers.dart';

mixin class MainEvent() {
  Future<void> handleLogin(WidgetRef ref, BuildContext context) async =>
      context.push<bool>(Routes.login);

  /// '편집 모드' 토글(켜질 때만 드래그 핸들·편집 버튼 노출).
  void handleToggleEdit(WidgetRef ref) =>
      ref.read(mainEditModeProvider.notifier).toggle();

  /// 현재 선택된 사이트의 게시판 선택 화면을 연다.
  Future<void> handleAddButton(WidgetRef ref, BuildContext context) async =>
      context.push(Routes.setMainDlgFull);

  /// 드로어에서 사이트를 고르면 그 사이트로 전환한 뒤 곧바로
  /// 게시판 선택 화면을 띄운다(드로어 = 게시판을 찾아 추가하는 통로).
  Future<void> openAddBoards(
    WidgetRef ref,
    BuildContext context,
    SiteType siteType,
  ) async {
    changeSiteType(ref, siteType);
    await context.push(Routes.setMainDlgFull);
  }

  void handleSideBarToggle(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).toggle();

  void sidebarOpen(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).open();

  void sidebarClose(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).close();

  void changeSiteType(WidgetRef ref, SiteType siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  static List<Override> overridesProviderScope(double width) => [
    screenWidthProvider.overrideWithValue(width),
  ];

  void handlePop(WidgetRef ref, bool didPop) {
    if (didPop) {
      return;
    }
    final scaffoldState = ref.read(mainScaffoldStateProvider).currentState;

    if (scaffoldState?.isDrawerOpen == true) {
      scaffoldState?.closeDrawer();
    }
  }
}
