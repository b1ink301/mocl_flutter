import 'package:material_ui/material_ui.dart';

/// 탭 하나의 정의(아이콘 · 선택 아이콘 · 라벨).
typedef NavItem = ({IconData icon, IconData selectedIcon, String label});

/// 알약 바깥 테두리의 둥글기. 선택 표시도 같은 값을 써서 바와 같은 곡률로
/// 보이게 한다(높이의 절반을 넘으면 자동으로 완전한 알약 모양이 된다).
const double _kPillRadius = 32;

const List<NavItem> _navItems = [
  (
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    label: '내 게시판',
  ),
  (icon: Icons.bookmark_border, selectedIcon: Icons.bookmark, label: '스크랩'),
  (icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: '설정'),
];

/// 화면 아래 가운데에 떠 있는 알약형 탭바(삼성 OneUI 스타일).
///
/// Material 의 NavigationBar 는 항상 가로를 꽉 채우므로 쓰지 않고, 탭 내용만큼만
/// 너비를 갖는 Row 로 직접 그린다. 선택된 탭은 아이콘 뒤에 알약 인디케이터가
/// 깔리고 라벨이 강조된다.
///
/// 목록이 바 뒤로 흘러가며 비치도록 Scaffold 는 `extendBody: true` 로 쓴다.
/// (그러면 Scaffold 가 본문 MediaQuery 의 bottom padding 을 이 바 높이만큼
///  잡아주므로, 각 탭은 기존의 `padding.bottom` 처리만으로 가려짐 없이 그려진다)
class const FloatingNavBar({
  super.key,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
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
        // Scaffold 는 bottomNavigationBar 를 화면 높이까지 열린 제약으로 재므로,
        // Center 를 쓰면 세로로도 늘어나 바가 화면 한가운데로 떠버린다.
        // Row 는 세로로 내용만큼만 차지하면서 가로 가운데 정렬을 해준다.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Pill(
              barColor: barColor,
              isDark: isDark,
              selectedIndex: selectedIndex,
              onSelected: onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class const _Pill({
  required final Color barColor,
  required final bool isDark,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(_kPillRadius),
        border: Border.all(color: theme.dividerColor),
        // 떠 있는 느낌은 그림자로만 준다(라이트/다크 모두 은은하게).
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.13),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      // 잉크 효과가 알약 배경 위에 그려지고 모서리에 맞춰 잘리도록,
      // 바깥 Scaffold 의 Material 대신 알약 안쪽에 Material 을 둔다.
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          // 좁은 화면에서 넘칠 때만 살짝 줄인다.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            // 라벨 길이가 제각각이라('내 게시판' vs '설정') 그대로 두면 탭마다
            // 너비와 선택 표시 크기가 달라진다. IntrinsicWidth 가 Row 의 너비를
            // '가장 넓은 탭 × 개수' 로 잡아주고, 그 안에서 Expanded 가 똑같이
            // 나눠 가지므로 모든 탭이 가장 긴 라벨에 맞춰 같은 너비가 된다.
            child: IntrinsicWidth(
              child: Row(
                children: [
                  for (int i = 0; i < _navItems.length; i++)
                    Expanded(
                      child: _NavBarItem(
                        item: _navItems[i],
                        isSelected: i == selectedIndex,
                        onTap: () => onSelected(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _NavBarItem({
  required final NavItem item,
  required final bool isSelected,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.focusColor;
    final Color mutedColor =
        theme.textTheme.bodySmall?.color ?? theme.hintColor;
    final Color tint = isSelected ? focusColor : mutedColor;

    // 선택 표시가 아이콘과 라벨을 함께 감싼다(아이콘만 강조하면 라벨이
    // 알약 밖으로 떨어져 나온 것처럼 보인다).
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected
              ? focusColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(_kPillRadius),
        ),
        // 잉크 효과가 선택 배경 위에 그려지고 모서리에 맞춰 잘리도록,
        // 배경 안쪽에 Material 을 하나 더 둔다.
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(_kPillRadius),
            child: Padding(
              // 좌우 여백이 곧 탭 사이 간격이 된다(가장 넓은 탭에 맞춰 폭이
              // 정해지므로, 이 값을 줄이면 세 탭이 함께 좁아진다).
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    size: 22,
                    color: tint,
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
      ),
    );
  }
}
