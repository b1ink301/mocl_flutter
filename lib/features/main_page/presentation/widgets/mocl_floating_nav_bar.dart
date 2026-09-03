import 'package:material_ui/material_ui.dart';

/// 탭 하나의 정의(아이콘 · 선택 아이콘 · 라벨).
typedef NavItem = ({IconData icon, IconData selectedIcon, String label});

const List<NavItem> _navItems = [
  (
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    label: '내 게시판',
  ),
  (icon: Icons.bookmark_border, selectedIcon: Icons.bookmark, label: '스크랩'),
  (
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: '설정',
  ),
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
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(32),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                // 좁은 화면에서 넘칠 때만 살짝 줄인다.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _navItems.length; i++)
                        _NavBarItem(
                          item: _navItems[i],
                          isSelected: i == selectedIndex,
                          onTap: () => onSelected(i),
                        ),
                    ],
                  ),
                ),
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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? focusColor.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
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
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
