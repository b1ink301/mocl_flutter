import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../config/large_title_metrics.dart';
import '../../../../core/presentation/widgets/adaptive_popup_menu.dart';
import '../../../../core/presentation/widgets/appbar_actions_icon_theme.dart';
import '../../../../core/presentation/widgets/large_title_flexible_space.dart';
import '../../../../core/presentation/widgets/menu_lines_icon.dart';
import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../../../../core/util/platform_util.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

class const MainAppBar({super.key})
    extends ConsumerWidget
    with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = titleTextStyleState(ref);
    final bool editMode = editModeState(ref);

    // 편집 라벨도 목록 · 상세의 크럼브와 같은 스타일을 쓴다. 툴바 왼쪽에
    // 작게 놓이는 같은 성격의 글자라, 셋이 따로 놀면 화면을 옮길 때마다
    // 같은 자리의 글자 크기 · 색이 바뀌어 보인다.
    final menuStyle = appbarCrumbStyle(smallTextStyleState(ref));
    final titleStyle = largeTitleStyle(textStyle);

    return SliverAppBar(
      leading: AppbarFixedIconTheme(
        child: PlainIconButton(
          onPressed: () => openDrawer(ref),
          icon: const MenuLinesIcon(),
        ),
      ),
      expandedHeight: kLargeTitleExpandedHeightSingleLine,
      flexibleSpace: LargeTitleFlexibleSpace(
        title: titleState(ref),
        style: titleStyle,
      ),
      // 편집 모드에서만 툴바에 라벨을 띄운다. 평소에는 크럼브가 없는 화면이라
      // 툴바 제목 자리를 비워 둔다.
      title: editMode ? PlainText('편집', style: menuStyle) : null,
      titleTextStyle: menuStyle,
      titleSpacing: 0,
      floating: true,
      pinned: false,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      actions: const <Widget>[_MainActions()],
    );
  }
}

/// 앱바 액션.
///
/// 검색 · 편집 상태를 여기서만 구독한다. 앱바 본체에 두면 검색창을 여닫을
/// 때마다 큰 제목까지 통째로 다시 만들게 된다.
class const _MainActions() extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool searchOpen = searchOpenState(ref);
    final bool editMode = editModeState(ref);

    // floating 앱바의 toolbarOpacity 로 인한 PlainIcon 리빌드 차단.
    // (AppbarActionsIconTheme 주석 참고)
    return AppbarActionsIconTheme(
      children: searchOpen
          // 검색 중에는 닫기만 남긴다(입력창이 앱바를 다 쓴다).
          ? [
              PlainIconButton(
                onPressed: () => closeSearch(ref),
                icon: const PlainIcon(Icons.close),
              ),
            ]
          : editMode
          ? [
              PlainIconButton(
                onPressed: () => handleToggleEdit(ref),
                icon: const PlainIcon(Icons.check),
              ),
            ]
          : [
              PlainIconButton(
                onPressed: () => handleAddButton(ref, context),
                icon: const PlainIcon(Icons.add),
              ),
              // 순서 변경 · 삭제는 평소엔 숨겨 두고 편집 모드에서만 연다.
              AdaptivePopupMenu(
                options: [
                  AdaptiveMenuOption(
                    label: '순서 변경/삭제',
                    onTap: () => handleToggleEdit(ref),
                  ),
                ],
                icon: PlainIcon(
                  isCupertino()
                      ? CupertinoIcons.ellipsis
                      : Icons.more_vert_rounded,
                ),
              ),
            ],
    );
  }
}
