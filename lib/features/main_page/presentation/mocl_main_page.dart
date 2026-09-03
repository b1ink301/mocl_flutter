import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/bookmark/presentation/bookmarks_page.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_floating_nav_bar.dart';
import 'package:mocl_flutter/features/settings_page/presentation/pages/settings/settings_page.dart';

import 'mocl_main_view.dart';
import 'state/main_event_mixin.dart';

/// 앱의 홈 셸. 하단 탭으로 '내 게시판 · 스크랩 · 설정' 을 오간다.
///
/// 예전엔 드로어가 사이트 전환과 스크랩/설정 진입을 겸했지만, 사이트 선택이
/// 게시판 추가 화면 안으로 들어가면서 드로어는 역할을 잃었다. 대신 자주 쓰는
/// 세 화면을 한 번의 탭으로 오갈 수 있게 하단 탭으로 바꿨다.
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
      // 다른 탭에 있으면 뒤로가기로 앱을 닫지 않고 첫 탭으로 돌아온다.
      canPop: tabIndex == 0,
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
        // 탭바가 목록 위에 떠 있도록 본문을 바 뒤까지 확장한다.
        extendBody: true,
        // IndexedStack 이라 탭을 오가도 스크롤 위치와 상태가 유지된다.
        body: IndexedStack(
          index: tabIndex,
          children: const <Widget>[
            MainView(),
            BookmarksPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: FloatingNavBar(
          selectedIndex: tabIndex,
          onSelected: (index) => selectTab(ref, index),
        ),
      ),
    );
  }
}
