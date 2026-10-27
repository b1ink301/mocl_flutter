import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_drawer_widget.dart';

import 'mocl_main_view.dart';
import 'state/main_event_mixin.dart';

/// 앱의 홈 셸.
///
/// 드로어로 **사이트**를 고르고, 본문은 그 사이트에 담아둔 게시판만 보여준다.
/// 스크랩 · 설정은 드로어 헤더의 아이콘으로 각자의 화면을 밀어 올린다.
class const MainPage({super.key})
    extends ConsumerWidget
    with MainEvent, MainState {
  static Widget init(double width) => ProviderScope(
    overrides: MainEvent.overridesProviderScope(width),
    child: const MainPage(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      // 검색창과 드로어 중 열려 있는 것을 먼저 닫고, 다 닫혀 있을 때만
      // 뒤로가기가 앱을 나간다.
      canPop: !searchOpenState(ref) && !isSidebarExpanded(ref),
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        key: scaffoldState(ref),
        drawer: const DrawerWidget(),
        onDrawerChanged: (isOpen) =>
            isOpen ? sidebarOpen(ref) : sidebarClose(ref),
        drawerEdgeDragWidth: screenWidth(ref) / 2,
        drawerEnableOpenDragGesture: true,
        body: const MainView(),
      ),
    );
  }
}
