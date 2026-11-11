import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/floating_pill_tab_bar.dart';
import 'package:mocl_flutter/features/library/presentation/library_page.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/issue_radar_page.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/state/issue_radar_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/settings_page/presentation/pages/settings/settings_page.dart';

import 'mocl_main_view.dart';
import 'widgets/site_drawer.dart';
import 'state/main_event_mixin.dart';

/// 홈 하단 탭. 서버가 없는 빌드(이슈 레이더 없음)에서는 [issues] 를 뺀다.
enum MainTab({
  required final PillTabItem item,

  /// 기기 확인 스크립트(tool/device_check.dart)가 누르는 id.
  required final String semanticsId,
}) {
  boards(
    item: (
      icon: Icons.view_list_outlined,
      selectedIcon: Icons.view_list,
      label: '게시판',
    ),
    semanticsId: 'tab_boards',
  ),
  issues(
    item: (
      icon: Icons.radar_outlined,
      selectedIcon: Icons.radar,
      label: '지금 이슈',
    ),
    semanticsId: 'tab_issues',
  ),

  /// 스크랩 · 최근 본 글(`LibraryPage`). id 는 옛 이름 그대로 둔다.
  bookmarks(
    item: (
      icon: Icons.collections_bookmark_outlined,
      selectedIcon: Icons.collections_bookmark,
      label: '보관함',
    ),
    semanticsId: 'tab_bookmarks',
  ),
  settings(
    item: (
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: '설정',
    ),
    semanticsId: 'tab_settings',
  );

  Widget get body => switch (this) {
    MainTab.boards => const MainView(),
    MainTab.issues => const IssueRadarPage(),
    MainTab.bookmarks => const LibraryPage(),
    MainTab.settings => const SettingsPage(),
  };
}

/// 앱의 홈 셸.
///
/// 하단 알약형 탭으로 **게시판 · 지금 이슈 · 보관함 · 설정**을 오간다. 게시판 탭은
/// 고른 사이트에 담아둔 게시판만 보여주고(사이트는 왼쪽 드로어에서 바꾼다 — 큰 제목을
/// 누르거나 게시판 탭 본문을 오른쪽으로 끈다), 이슈는 사이트와 무관하게 여러 커뮤니티를
/// 가로지르므로 따로 탭을 둔다. 드로어에는 사이트만 둔다 — 스크랩 · 설정까지 넣으면
/// 탭과 이동 경로가 두 갈래가 된다.
class const MainPage({super.key})
    extends ConsumerWidget
    with MainEvent, MainState, IssueRadarState {
  static Widget init() => const ProviderScope(child: MainPage());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ScaffoldWidget(
      tabs: <MainTab>[
        MainTab.boards,
        // 서버 주소는 빌드 때 정해져 실행 중에 바뀌지 않는다(탭이 들썩이지 않음).
        if (issueRadarAvailableState(ref)) MainTab.issues,
        MainTab.bookmarks,
        MainTab.settings,
      ],
    );
  }
}

class const _ScaffoldWidget({required final List<MainTab> tabs})
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ScaffoldWidget> createState() => _ScaffoldWidgetState();
}

class _ScaffoldWidgetState()
    extends ConsumerState<_ScaffoldWidget>
    with MainState, MainEvent, IssueRadarState {
  /// 탭마다 따로 둔 스크롤 컨트롤러.
  ///
  /// 탭들은 [IndexedStack] 으로 함께 살아 있어서, 라우트의 [PrimaryScrollController]
  /// 하나를 같이 쓰면 컨트롤러 하나에 스크롤뷰가 여럿 붙는다. 탭마다 따로 주고,
  /// 지금 탭의 것을 Scaffold 위에도 둬서 iOS 상태바 탭이 보고 있는 탭을 올리게 한다.
  final Map<MainTab, ScrollController> _controllers =
      <MainTab, ScrollController>{
        for (final MainTab tab in MainTab.values) tab: ScrollController(),
      };

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 사이트 드로어가 열려 있는지. 뒤로가기가 검색 · 탭보다 드로어를 먼저 닫게 한다.
  bool _drawerOpen = false;

  @override
  void dispose() {
    for (final ScrollController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSelected(int index) {
    if (index == tabIndexState(ref)) {
      // 보고 있는 탭을 다시 누르면 맨 위로.
      final ScrollController controller = _controllers[widget.tabs[index]]!;
      if (controller.positions.any((p) => p.pixels > p.minScrollExtent)) {
        controller.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
      return;
    }
    selectTab(ref, index);
  }

  @override
  Widget build(BuildContext context) {
    final systemOverlayStyle =
        Theme.of(context).appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.light;
    final List<MainTab> tabs = widget.tabs;
    final int tabIndex = tabIndexState(ref).clamp(0, tabs.length - 1);
    final MainTab current = tabs[tabIndex];

    return PopScope(
      // 드로어 · 검색 · 다른 탭 중 열려 있는 것을 먼저 닫고, 다 닫혀 있을 때만
      // 뒤로가기가 앱을 나간다. 드로어가 열려 있으면 막지 않는다 — Scaffold 가
      // 라우트의 로컬 기록으로 받아 드로어만 닫는다(canPop 이 false 면 그 기록까지
      // 막혀 검색이 먼저 닫힌다).
      canPop: _drawerOpen || (tabIndex == 0 && !searchOpenState(ref)),
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        if (_drawerOpen) {
          _scaffoldKey.currentState?.closeDrawer();
          return;
        }
        handlePop(ref, didPop);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemOverlayStyle,
        child: PrimaryScrollController(
          controller: _controllers[current]!,
          child: Scaffold(
            key: _scaffoldKey,
            // 탭바가 목록 위에 떠 있도록 본문을 바 뒤까지 확장한다. Scaffold 가
            // 본문 MediaQuery 의 padding.bottom 에 바 높이를 더해 준다.
            extendBody: true,
            drawer: const SiteDrawer(),
            onDrawerChanged: (bool isOpen) =>
                setState(() => _drawerOpen = isOpen),
            // 옛 드로어처럼 화면 왼쪽 절반 어디서 끌어도 손가락을 따라 열린다.
            // 게시판 탭에서만, 편집 · 검색 중이 아닐 때만(드래그 · 입력과 겹치지 않게).
            drawerEdgeDragWidth: MediaQuery.sizeOf(context).width / 2,
            drawerEnableOpenDragGesture:
                current == MainTab.boards &&
                !editModeState(ref) &&
                !searchOpenState(ref),
            // IndexedStack 이라 탭을 오가도 스크롤 위치와 상태가 유지된다.
            body: IndexedStack(
              index: tabIndex,
              children: <Widget>[
                for (final MainTab tab in tabs)
                  PrimaryScrollController(
                    controller: _controllers[tab]!,
                    child: tab.body,
                  ),
              ],
            ),
            bottomNavigationBar: FloatingPillTabBar(
              items: <PillTabItem>[for (final MainTab tab in tabs) tab.item],
              semanticsIds: <String>[
                for (final MainTab tab in tabs) tab.semanticsId,
              ],
              selectedIndex: tabIndex,
              dots: <int>{
                if (tabs.contains(MainTab.issues) &&
                    current != MainTab.issues &&
                    hasUnreadTopIssuesState(ref))
                  tabs.indexOf(MainTab.issues),
              },
              onSelected: _onSelected,
            ),
          ),
        ),
      ),
    );
  }
}
