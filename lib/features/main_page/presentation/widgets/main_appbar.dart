import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/application/app_provider.dart';
import '../../../../core/presentation/widgets/adaptive_popup_menu.dart';
import '../../../../core/presentation/widgets/appbar_actions_icon_theme.dart';
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
    final textStyle = ref
        .watch(appbarTextStyleProvider);
    final bool editMode = editModeState(ref);
    final bool searchOpen = searchOpenState(ref);
    final primaryColor = Theme.of(context).primaryColor;

    final menuStyle = textStyle.copyWith(color: primaryColor, fontWeight: FontWeight.w400, );
    final titleStyle = textStyle.copyWith(fontSize: 30, height: 1.15);

    return SliverAppBar(
      leading: AppbarFixedIconTheme(
        child: PlainIconButton(
          onPressed: () => openDrawer(ref),
          icon: const MenuLinesIcon(),
        ),
      ),
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16, bottom: 4, end: 4),
            child: PlainText(titleState(ref), style: titleStyle),
          ),
        ),
      ),
      // 검색 중에는 입력창이 제목 자리를 통째로 쓴다(닫기 버튼만 오른쪽에 남는다).
      title: editMode ? PlainText('편집', style: menuStyle) : null,
      titleTextStyle: menuStyle,
      titleSpacing: -8,
      floating: true,
      pinned: false,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      // floating 앱바의 toolbarOpacity 로 인한 PlainIcon 리빌드 차단.
      // (AppbarActionsIconTheme 주석 참고)
      actions: <Widget>[
        AppbarActionsIconTheme(
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
                  // 담은 게시판이 많아지면 스크롤보다 검색이 빠르다.
                  // PlainIconButton(
                  //   onPressed: () => openSearch(ref),
                  //   icon: const PlainIcon(Icons.search),
                  // ),
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
        ),
      ],
    );
  }
}
