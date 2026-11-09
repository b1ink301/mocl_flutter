import 'package:material_ui/material_ui.dart';

/// 알약형 탭 하나의 정의(아이콘 · 선택 아이콘 · 라벨).
typedef PillTabItem = ({IconData icon, IconData selectedIcon, String label});

/// 알약 바깥 테두리의 둥글기. 선택 표시도 같은 값을 써서 바와 같은 곡률로 보인다.
const double _kPillRadius = 32;

/// 바 테두리와 선택 표시 사이 간격(위아래 · 양옆 같게).
const double _kBarInset = 6;

/// 탭 자리(누르는 영역)의 좌우 여백. 탭은 4등분하지 않고 내용 폭만큼만 차지한다.
const double _kSlotPadding = 10;

/// 선택 표시가 탭 자리 밖으로 나가는 폭. 이웃 탭의 빈 여백과 겹쳐 그려서,
/// 선택 표시는 넉넉하게(좌우 [_kSlotPadding] + 이 값) 두고 탭 사이 간격은 줄인다.
/// 누르는 영역은 탭 자리 안이라 겹친 곳을 눌러도 이웃 탭이 눌린다.
const double _kFocusOverlap = 4;

/// 탭 내용의 최소 폭. "설정" 처럼 짧은 라벨에서 선택 표시가 동그랗게 줄지 않게.
const double _kMinContentWidth = 40;

/// 화면 아래 가운데에 떠 있는 알약형 탭바(홈 · 차단 화면).
///
/// 탭 목록을 밖에서 넘겨받는다. 본문이 바 뒤로 비치도록 Scaffold 는
/// `extendBody: true` 로 두고, 목록은 `MediaQuery.padding.bottom` 만큼 아래
/// 여백을 준다(Scaffold 가 바 높이를 그 값에 더해준다).
class const FloatingPillTabBar({
  super.key,
  required final List<PillTabItem> items,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,

  /// 아이콘에 점을 붙일 탭(새 소식 알림).
  final Set<int> dots = const <int>{},

  /// 탭마다 붙일 `Semantics(identifier:)`(기기 확인 스크립트용). 없으면 붙이지 않는다.
  final List<String>? semanticsIds,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color barColor =
        theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        // Scaffold 는 bottomNavigationBar 를 화면 높이까지 열린 제약으로 재므로
        // Center 대신 Row 로 가로만 가운데 정렬한다(세로는 내용만큼).
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(_kPillRadius),
                border: Border.all(color: theme.dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.13),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              // 잉크 효과가 알약 안쪽에서 잘리도록 Material 을 여기 둔다.
              clipBehavior: Clip.antiAlias,
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  // 선택 표시와 바 테두리 사이를 위아래 · 양옆 모두 [_kBarInset] 으로 맞춘다
                  // (둘 다 양 끝이 반원이라 간격이 같아야 곡선이 나란해 보인다).
                  // 선택 표시는 탭 자리 밖으로 [_kFocusOverlap] 만큼 나가므로 그만큼 더 띄운다.
                  padding: const EdgeInsets.symmetric(
                    horizontal: _kBarInset + _kFocusOverlap,
                    vertical: _kBarInset,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < items.length; i++)
                          _PillTabItemView(
                            item: items[i],
                            isSelected: i == selectedIndex,
                            dot: dots.contains(i),
                            semanticsId: semanticsIds?[i],
                            onTap: () => onSelected(i),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _PillTabItemView({
  required final PillTabItem item,
  required final bool isSelected,
  required final bool dot,
  required final String? semanticsId,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.colorScheme.primary;
    final Color mutedColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;
    final Color tint = isSelected ? focusColor : mutedColor;

    final BorderRadius radius = BorderRadius.circular(_kPillRadius);
    // 탭 자리는 내용만큼. 선택 표시(와 잉크)는 자리보다 양옆으로 [_kFocusOverlap] 씩
    // 크게 그린다. 자리 밖은 누르는 영역이 아니다(Stack 은 자기 크기 안만 hit test).
    final Widget tab = Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -_kFocusOverlap,
          right: -_kFocusOverlap,
          top: 0,
          bottom: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isSelected
                  ? focusColor.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: radius,
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: onTap, borderRadius: radius),
            ),
          ),
        ),
        IgnorePointer(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _kSlotPadding,
              vertical: 8,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: _kMinContentWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Badge(
                    isLabelVisible: dot,
                    smallSize: 7,
                    child: Icon(
                      isSelected ? item.selectedIcon : item.icon,
                      size: 22,
                      color: tint,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.1,
                      color: tint,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    final Widget labeled = Semantics(
      selected: isSelected,
      value: dot ? '새 소식 있음' : null,
      child: tab,
    );
    return semanticsId == null
        ? labeled
        : Semantics(identifier: semanticsId, child: labeled);
  }
}
