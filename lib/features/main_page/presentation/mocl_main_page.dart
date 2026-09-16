import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/bookmark/presentation/bookmarks_page.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_floating_nav_bar.dart';
import 'package:mocl_flutter/features/settings_page/presentation/pages/settings/settings_page.dart';

import 'mocl_main_view.dart';
import 'state/main_event_mixin.dart';

/// 앱의 홈 셸.
///
/// 가로축(드로어)으로 **사이트**를, 세로축(하단 탭)으로 **화면**을 고른다.
/// 홈은 지금 고른 사이트에 담아둔 게시판만 보여주므로, 사이트 전환은 드로어가
/// 맡고 스크랩 · 설정은 한 번의 탭으로 오간다.
class const MainPage({super.key})
    extends ConsumerWidget
    with MainEvent, MainState {
  static Widget init(double width) => ProviderScope(
    overrides: MainEvent.overridesProviderScope(width),
    child: const MainPage(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int tabIndex = tabIndexState(ref);
    return PopScope(
      // 드로어 · 검색 · 다른 탭 중 열려 있는 것을 먼저 닫고, 다 닫혀 있을 때만
      // 뒤로가기가 앱을 나간다.
      canPop: tabIndex == 0 && !searchOpenState(ref) && !isSidebarExpanded(ref),
      onPopInvokedWithResult: (bool didPop, _) => handlePop(ref, didPop),
      child: const _ScaffoldWidget(),
    );
  }
}

class const _ScaffoldWidget() extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemOverlayStyle =
        Theme.of(context).appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.light;
    final int tabIndex = tabIndexState(ref);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        key: scaffoldState(ref),
        drawer: const DrawerWidget(),
        onDrawerChanged: (isOpen) =>
            isOpen ? sidebarOpen(ref) : sidebarClose(ref),
        drawerEdgeDragWidth: screenWidth(ref) / 2,
        // 사이트 전환은 첫 탭(게시판 목록)에서만 뜻이 있다. 스크랩 · 설정에서
        // 왼쪽을 쓸어 드로어가 열리면 그 화면의 제스처와 부딪힌다.
        drawerEnableOpenDragGesture: tabIndex == 0,
        // 탭바가 목록 위에 떠 있도록 본문을 바 뒤까지 확장한다.
        extendBody: true,
        // IndexedStack 이라 탭을 오가도 스크롤 위치와 상태가 유지된다.
        body: IndexedStack(
          index: tabIndex,
          children: const <Widget>[MainView(), BookmarksPage(), SettingsPage()],
        ),
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: tabIndex,
          onSelected: (index) => selectTab(ref, index),
        ),
      ),
    );
  }
}
