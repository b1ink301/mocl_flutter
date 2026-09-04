import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';

/// 그룹 헤더의 위치를 재기 위한 키 모음(그룹 ID → 키).
/// 메인 화면이 소유하고, 본문과 이 레일이 함께 들여다본다.
typedef GroupHeaderKeys = Map<String, GlobalKey>;

/// 메인 목록 오른쪽에 세로로 떠 있는 "사이트 바로가기" 레일.
///
/// 등록한 게시판이 많아지면 원하는 사이트까지 한참 스크롤해야 한다. 이 레일은
/// 그룹마다 아이콘 하나를 세워두고, 탭하면 그 그룹의 첫 줄로 곧장 이동시킨다.
/// 지금 보고 있는 그룹은 강조색 링으로 표시된다.
///
/// 편집 모드에서는 항목마다 드래그 손잡이가 오른쪽에 생겨 서로 부딪히므로
/// 레일을 감춘다. 그룹이 하나뿐일 때도 이동할 곳이 없어 감춘다.
class const QuickJumpRail({
  super.key,
  required final ScrollController controller,
  required final GroupHeaderKeys headerKeys,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<QuickJumpRail> createState() => _QuickJumpRailState();
}

class _QuickJumpRailState()
    extends ConsumerState<QuickJumpRail>
    with MainState, FavoriteState {
  /// 지금 보고 있는 그룹의 인덱스. 스크롤할 때마다 본문까지 리빌드되지 않도록
  /// setState 대신 알림값으로 레일 안쪽만 갱신한다.
  final ValueNotifier<int> _active = ValueNotifier<int>(0);

  /// 화면에 그려지는 순서대로의 그룹 ID(레일 점 순서와 같다).
  List<String> _groupIds = const <String>[];

  /// 레일 탭으로 이동하는 중. 이동 중에는 스크롤에 따른 강조 갱신을 멈춘다
  /// (지나치는 그룹마다 강조가 옮겨 다니면 어지럽다).
  bool _jumping = false;

  /// 그룹별 목표 스크롤 위치([_groupIds] 와 같은 순서).
  ///
  /// 위치를 재려면 그룹마다 뷰포트까지 거슬러 올라가야 해서, 스크롤할 때마다
  /// 전부 다시 재면 손해다. 목록 길이가 변하지 않는 한 값도 그대로이므로
  /// 캐시해 두고 [_offsetsExtent] 가 달라질 때만 다시 잰다.
  List<double>? _offsets;
  double _offsetsExtent = -1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(QuickJumpRail oldWidget) {
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
    _active.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 설정에서 끈 경우.
    if (!showQuickJumpState(ref)) return const SizedBox.shrink();

    // 편집 모드에서는 오른쪽이 드래그 손잡이 자리다.
    if (editModeState(ref)) return const SizedBox.shrink();

    final List<FavoriteSection> sections =
        favoriteSectionsState(ref).asData?.value ?? const <FavoriteSection>[];
    // 본문과 같은 규칙으로 빈 그룹은 뺀다(레일과 목록의 순서가 어긋나면 안 된다).
    final List<FavoriteSection> visible = sections
        .where((section) => section.items.isNotEmpty)
        .toList();
    final List<String> ids = [
      for (final FavoriteSection section in visible) section.group.id,
    ];
    // 그룹이 늘거나 줄면 재둔 위치는 모두 못 쓴다.
    if (!_sameIds(ids, _groupIds)) {
      _groupIds = ids;
      _offsets = null;
    }

    // 갈 곳이 하나뿐이면 레일은 자리만 차지한다.
    if (visible.length < 2) return const SizedBox.shrink();

    final MediaQueryData media = MediaQuery.of(context);

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
        child: ValueListenableBuilder<int>(
          valueListenable: _active,
          builder: (context, active, _) =>
              _RailBar(sections: visible, active: active, onTap: _jumpTo),
        ),
      ),
    );
  }

  /// 그룹 헤더를 뷰포트 맨 위에 붙이는 스크롤 오프셋.
  /// 아직 배치 전이거나 사라진 그룹이면 null.
  ///
  /// 그룹 헤더는 게으르게 만들어지는 목록 항목과 달리 항상 배치되므로,
  /// 화면 밖으로 한참 벗어난 그룹도 위치를 물어볼 수 있다.
  double? _rawOffsetOf(String groupId) {
    final BuildContext? headerContext =
        widget.headerKeys[groupId]?.currentContext;
    if (headerContext == null) return null;

    final RenderObject? header = headerContext.findRenderObject();
    if (header == null || !header.attached) return null;

    final RenderAbstractViewport? viewport = RenderAbstractViewport.maybeOf(
      header,
    );
    if (viewport == null) return null;

    try {
      return viewport.getOffsetToReveal(header, 0).offset;
    } catch (_) {
      return null;
    }
  }

  /// 그룹을 고정 앱바 바로 아래에 붙이는 스크롤 위치를 모두 구한다.
  ///
  /// 첫 그룹의 오프셋이 곧 앱바가 차지하는 높이라, 이를 기준선으로 빼면
  /// 앱바 높이를 따로 계산하지 않고도 정확한 목표 위치가 나온다.
  ///
  /// 아직 한 그룹이라도 못 재면 null 을 돌려 어중간한 표를 만들지 않는다.
  List<double>? _ensureOffsets({bool force = false}) {
    if (_groupIds.isEmpty || !widget.controller.hasClients) return null;

    // 목록이 자라거나 줄면(항목이 새로 그려지며 추정 길이가 바뀔 때 포함)
    // 재둔 위치도 밀리므로 다시 잰다.
    final double extent = widget.controller.position.maxScrollExtent;
    final List<double>? cached = _offsets;
    if (!force && cached != null && _offsetsExtent == extent) return cached;

    final double? base = _rawOffsetOf(_groupIds.first);
    if (base == null) return null;

    final List<double> offsets = <double>[];
    for (final String groupId in _groupIds) {
      final double? raw = _rawOffsetOf(groupId);
      if (raw == null) return null;
      offsets.add(raw - base);
    }

    _offsets = offsets;
    _offsetsExtent = extent;
    return offsets;
  }

  void _onScroll() {
    // 레이아웃 도중에는 리빌드를 예약할 수 없다. 프레임이 끝난 뒤 다시 잰다.
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateActive();
      });
      return;
    }
    _updateActive();
  }

  void _updateActive() {
    if (_jumping) return;

    final List<double>? offsets = _ensureOffsets();
    if (offsets == null) return;

    final double offset = widget.controller.offset;
    int index = 0;
    for (int i = 0; i < offsets.length; i++) {
      // 헤더가 앱바 밑에 막 닿은 시점부터 그 그룹을 보고 있는 것으로 친다.
      if (offsets[i] <= offset + 8) {
        index = i;
      } else {
        break;
      }
    }
    _active.value = index;
  }

  /// 레일 점을 누르면 해당 그룹의 첫 줄로 이동한다.
  ///
  /// 화면 밖 목록은 아직 그려지지 않아 위치가 '추정값'이다. 그래서 한 번
  /// 애니메이션으로 이동한 뒤, 실제로 그려진 위치를 다시 재서 어긋난 만큼
  /// 보정한다(최대 두 번).
  Future<void> _jumpTo(int index) async {
    final ScrollController controller = widget.controller;
    if (!controller.hasClients || index >= _groupIds.length) return;

    HapticFeedback.selectionClick();
    _active.value = index;
    _jumping = true;

    try {
      for (int attempt = 0; attempt < 3; attempt++) {
        // 이동하며 목록이 새로 그려져 위치가 밀리므로 매번 다시 잰다.
        final List<double>? offsets = _ensureOffsets(force: true);
        if (offsets == null || index >= offsets.length) break;

        final double clamped = offsets[index].clamp(
          0.0,
          controller.position.maxScrollExtent,
        );
        if ((controller.offset - clamped).abs() < 1) break;

        if (attempt == 0) {
          await controller.animateTo(
            clamped,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
          );
        } else {
          controller.jumpTo(clamped);
          // 새로 그려진 줄들이 반영된 뒤에 다시 재야 한다.
          await SchedulerBinding.instance.endOfFrame;
        }

        if (!mounted || !controller.hasClients) break;
      }
    } finally {
      _jumping = false;
    }

    if (mounted) _active.value = index;
  }
}

/// 알약 모양의 레일 몸통. 그룹이 많으면 레일 안에서 스크롤된다.
class const _RailBar({
  required final List<FavoriteSection> sections,
  required final int active,
  required final ValueChanged<int> onTap,
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
        // 그룹이 많아 레일이 화면보다 길어지면 레일만 따로 스크롤한다.
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < sections.length; i++)
                _RailDot(
                  section: sections[i],
                  active: i == active,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 레일 점 하나. 그룹을 대표하는 사이트 아이콘을 쓰고,
/// 아이콘이 없으면 그룹 이름 앞 글자로 대신한다.
class const _RailDot({
  required final FavoriteSection section,
  required final bool active,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FavoriteData? lead = _representativeOf(section);

    return Tooltip(
      message: section.group.name,
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
            child: Opacity(
              opacity: active ? 1 : 0.55,
              child: lead == null
                  ? const SizedBox(width: 26, height: 26)
                  : SiteAvatar(
                      siteType: lead.siteType,
                      iconUrl: lead.icon,
                      radius: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 그룹 구성이 그대로인지(순서까지 같은지) 확인한다.
bool _sameIds(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// 그룹을 대표하는 게시판. 그림이 있는 게시판을 먼저 고르고, 하나도 없으면
/// 첫 게시판을 쓴다(그 사이트의 색 배지가 그룹 표시가 된다).
FavoriteData? _representativeOf(FavoriteSection section) {
  if (section.items.isEmpty) return null;
  for (final FavoriteData favorite in section.items) {
    if (favorite.icon.isNotEmpty) return favorite;
  }
  return section.items.first;
}
