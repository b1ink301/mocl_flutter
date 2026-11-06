import 'package:cupertino_ui/cupertino_ui.dart';

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/state/issue_radar_state_mixin.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import '../../../../config/large_title_metrics.dart';
import '../../../../core/presentation/widgets/adaptive_popup_menu.dart';
import '../../../../core/presentation/widgets/appbar_actions_icon_theme.dart';
import '../../../../core/presentation/widgets/large_title_flexible_space.dart';
import '../../../../core/presentation/widgets/menu_lines_icon.dart';
import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../../../../core/presentation/widgets/scroll_to_top_title.dart';
import '../../../../core/util/platform_util.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';
import 'main_search_field.dart';

/// 메인 앱바. 배치가 둘이다.
///
/// - [issueFirst] false(기존): 펼침 영역에 큰 사이트 제목. 스크롤하면 스르륵
///   사라지고 툴바 제목은 비어 있다.
/// - [issueFirst] true("지금 이슈" 카드를 켠 경우): 툴바만 두고 고정한다.
///   큰 제목은 카드 아래로 내려가 카드와 함께 고정되고(메인 뷰의 고정 머리),
///   게시판 목록만 스크롤된다. 스크롤 그림자는 툴바가 아니라 고정 머리 아래에 둔다.
///
/// 두 배치 모두 맨 위에서 큰 제목의 자리 · 모양이 같아, 카드를 닫고 켤 때
/// 제목이 움직이지 않는다.
class const MainAppBar({super.key, final bool issueFirst = false})
    extends ConsumerWidget
    with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = titleTextStyleState(ref);

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
          semanticLabel: '메뉴',
          semanticsId: 'main_drawer',
        ),
      ),
      expandedHeight: issueFirst ? null : kLargeTitleExpandedHeightSingleLine,
      flexibleSpace: issueFirst
          ? null
          : LargeTitleFlexibleSpace(title: titleState(ref), style: titleStyle),
      title: _MainAppBarTitle(style: menuStyle),
      titleTextStyle: menuStyle,
      titleSpacing: 0,
      floating: !issueFirst,
      pinned: issueFirst,
      // 고정 배치에서는 툴바 바로 밑이 고정 머리라, 그림자는 머리 아래에만 둔다.
      scrolledUnderElevation: issueFirst ? 0 : null,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      actions: const <Widget>[_MainActions()],
    );
  }
}

/// 툴바 제목 자리.
///
/// 검색 중에는 입력창이 이 자리를 통째로 쓰고(닫기 버튼만 오른쪽에 남는다),
/// 편집 중에는 라벨만 띄운다. 평소에는 크럼브가 없는 화면이라 비워 둔다.
/// 검색 중이 아니면 비어 있어도 툴바를 탭해 맨 위로 올릴 수 있다([ScrollToTopTitle]).
///
/// 검색 · 편집 상태를 앱바 본체가 아니라 여기서 구독한다. 본체에서 보면
/// 검색창을 여닫을 때마다 큰 제목까지 통째로 다시 만들게 된다(_MainActions
/// 주석 참고).
class const _MainAppBarTitle({required final TextStyle style})
    extends ConsumerWidget
    with MainState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchOpenState(ref)) return const MainSearchField();
    return ScrollToTopTitle(
      child: editModeState(ref)
          ? PlainText('편집', style: style)
          : const SizedBox.shrink(),
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
                semanticLabel: '검색 닫기',
              ),
            ]
          : editMode
          ? [
              PlainIconButton(
                onPressed: () => handleToggleEdit(ref),
                icon: const PlainIcon(Icons.check),
                semanticLabel: '편집 완료',
              ),
            ]
          : [
              const _IssueRadarAction(),
              // 담은 게시판이 많아지면 스크롤보다 검색이 빠르다.
              PlainIconButton(
                onPressed: () => openSearch(ref),
                icon: const PlainIcon(Icons.search),
                semanticLabel: '게시판 검색',
              ),
              PlainIconButton(
                onPressed: () => handleAddButton(ref, context),
                icon: const PlainIcon(Icons.add),
                semanticLabel: '게시판 추가',
                semanticsId: 'main_add',
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

/// "지금 이슈" 로 가는 레이더 아이콘. 메인 위 이슈 카드가 안 보일 때만 둔다
/// (카드를 닫았거나, 이슈를 못 받았거나 없을 때). 카드를 켜 둔 채 받는 중에는
/// 숨긴다 — 보였다가 카드가 오면 사라지며 앱바 아이콘이 들썩인다.
/// 위쪽 이슈 중 안 본 게 있으면 점을 붙인다.
class const _IssueRadarAction() extends ConsumerWidget with IssueRadarState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!issueRadarAvailableState(ref)) return const SizedBox.shrink();
    final AsyncValue<IssueFeed> feed = issueFeedState(ref);
    final bool cardShown =
        issueHomeCardState(ref) &&
        (feed.value?.issues.isNotEmpty ?? feed.isLoading);
    if (cardShown) return const SizedBox.shrink();

    final bool unread = hasUnreadTopIssuesState(ref);
    return PlainIconButton(
      onPressed: () => unawaited(context.push(Routes.issues)),
      icon: Badge(
        isLabelVisible: unread,
        smallSize: 7,
        child: const PlainIcon(Icons.radar),
      ),
      semanticLabel: unread ? '지금 이슈, 새 이슈 있음' : '지금 이슈',
      semanticsId: 'main_issues',
    );
  }
}
