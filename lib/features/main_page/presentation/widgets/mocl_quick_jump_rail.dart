import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_event_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';

/// 목록 오른쪽에 세로로 떠 있는 "사이트 바로가기" 레일.
///
/// 홈은 한 사이트의 게시판만 보여주므로 사이트를 바꾸려면 드로어를 열어야
/// 한다. 자주 오가는 사이트는 그마저 번거로워서, 이미 게시판을 담아둔 사이트만
/// 로고 하나씩 세워 두고 탭 한 번으로 갈아타게 한다. 지금 보고 있는 사이트는
/// 강조색 링으로 표시된다.
///
/// 목록 위에 겹쳐 뜨는 만큼 게시판 이름 오른쪽 끝을 가리므로, 스크롤이 멈추고
/// 잠시 지나면 옅어졌다가 다시 스크롤하면 또렷해진다. 옅어진 상태에서도 탭은
/// 그대로 받는다(위치를 기억하고 누른 사용자가 헛손질하지 않도록).
///
/// 편집 모드에서는 항목마다 드래그 손잡이가 오른쪽에 생겨 서로 부딪히므로
/// 레일을 감춘다. 담아둔 사이트가 하나뿐일 때도 갈 곳이 없어 감춘다.
class const SiteJumpRail({
  super.key,
  required final ScrollController controller,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<SiteJumpRail> createState() => _SiteJumpRailState();
}

class _SiteJumpRailState()
    extends ConsumerState<SiteJumpRail>
    with MainState, MainEvent, FavoriteState {
  /// 스크롤이 멈춘 뒤 레일을 옅게 만들기까지 기다리는 시간.
  static const Duration _idleDelay = Duration(milliseconds: 1200);

  /// 옅어진 상태인지. 스크롤할 때마다 본문까지 리빌드되지 않도록 setState
  /// 대신 알림값으로 레일 안쪽만 갱신한다.
  final ValueNotifier<bool> _dimmed = ValueNotifier<bool>(false);
  Timer? _idleTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    // 처음엔 또렷하게 보여 레일의 존재를 알리고, 잠시 뒤 옅어진다.
    _restartIdleTimer();
  }

  @override
  void didUpdateWidget(SiteJumpRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    // removeListener 는 이미 dispose 된 대상에도 안전하다(프레임워크가 보장).
    widget.controller.removeListener(_onScroll);
    _idleTimer?.cancel();
    _dimmed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 설정에서 끈 경우.
    if (!showQuickJumpState(ref)) return const SizedBox.shrink();

    // 편집 모드에서는 오른쪽이 드래그 손잡이 자리다.
    if (editModeState(ref)) return const SizedBox.shrink();

    // 검색 중에는 사이트를 바꾸면 검색어만 남고 결과가 통째로 바뀌어 혼란스럽다.
    if (searchOpenState(ref)) return const SizedBox.shrink();

    final Map<SiteType, int> counts = favoriteCountBySiteState(ref);
    // 드로어와 같은 순서로 세운다(성격이 비슷한 사이트끼리 이웃한다).
    final List<SiteType> sites = [
      for (final SiteType siteType in kAllSitesInOrder)
        if ((counts[siteType] ?? 0) > 0) siteType,
    ];

    // 갈 곳이 하나뿐이면 레일은 자리만 차지한다.
    if (sites.length < 2) return const SizedBox.shrink();

    final MediaQueryData media = MediaQuery.of(context);
    final SiteType current = currentSiteType(ref);

    return Padding(
      padding: EdgeInsets.only(
        // 앱바(고정)와 떠 있는 탭바를 피해 그 사이에만 자리 잡는다.
        top: media.padding.top + kToolbarHeight + 8,
        // Scaffold(extendBody) 가 탭바 높이를 bottom 패딩으로 내려준다.
        bottom: media.padding.bottom + 8,
        right: 6,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: ValueListenableBuilder<bool>(
          valueListenable: _dimmed,
          builder: (context, dimmed, child) => AnimatedOpacity(
            // 아예 투명하게 만들면 보이지도 않는데 눌리는 셈이라 하한을 둔다.
            opacity: dimmed ? 0.35 : 1,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
            child: _RailBar(
              sites: sites,
              current: current,
              // 레일 전체가 옅어진 만큼 아이콘 자체 감쇠는 덜어 준다
              // (0.35 × 0.55 면 무엇인지 알아볼 수 없다).
              inactiveOpacity: dimmed ? 0.85 : 0.55,
              onTap: _jumpTo,
            ),
          ),
        ),
      ),
    );
  }

  /// 레일을 또렷하게 되돌리고, 유휴 타이머를 다시 건다.
  void _wake() {
    _dimmed.value = false;
    _restartIdleTimer();
  }

  void _restartIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(_idleDelay, () {
      if (mounted) _dimmed.value = true;
    });
  }

  void _onScroll() => _wake();

  /// 레일 점을 누르면 그 사이트로 갈아탄다. 목록이 통째로 바뀌므로
  /// 이전 사이트의 스크롤 위치는 맨 위로 되돌린다.
  void _jumpTo(SiteType siteType) {
    if (siteType == currentSiteType(ref)) return;

    HapticFeedback.selectionClick();
    _wake();
    changeSiteType(ref, siteType);

    final ScrollController controller = widget.controller;
    if (controller.hasClients && controller.offset > 0) {
      controller.jumpTo(0);
    }
  }
}

/// 알약 모양의 레일 몸통. 사이트가 많으면 레일 안에서 스크롤된다.
class const _RailBar({
  required final List<SiteType> sites,
  required final SiteType current,
  required final double inactiveOpacity,
  required final ValueChanged<SiteType> onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color barColor =
        theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor;
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: barColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        // 사이트가 많아 레일이 화면보다 길어지면 레일만 따로 스크롤한다.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final SiteType siteType in sites)
                _RailDot(
                  siteType: siteType,
                  active: siteType == current,
                  inactiveOpacity: inactiveOpacity,
                  onTap: () => onTap(siteType),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 레일 점 하나(사이트 로고). 로고가 없는 사이트는 [SiteAvatar] 가 색 배지로
/// 대신한다.
class const _RailDot({
  required final SiteType siteType,
  required final bool active,
  required final double inactiveOpacity,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Tooltip(
      message: siteType.title,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? theme.focusColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: AnimatedOpacity(
              opacity: active ? 1 : inactiveOpacity,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              child: SiteAvatar(siteType: siteType, radius: 13),
            ),
          ),
        ),
      ),
    );
  }
}
