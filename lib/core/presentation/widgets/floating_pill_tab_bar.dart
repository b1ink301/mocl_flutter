import 'package:material_ui/material_ui.dart';

/// 알약형 탭 하나의 정의(아이콘 · 선택 아이콘 · 라벨).
typedef PillTabItem = ({IconData icon, IconData selectedIcon, String label});

/// 알약 바깥 테두리의 둥글기. 선택 표시도 같은 값을 써서 바와 같은 곡률로 보인다.
const double _kPillRadius = 32;

/// 화면 아래 가운데에 떠 있는 알약형 탭바(홈의 [FloatingNavBar] 와 같은 모양).
///
/// 홈 전용인 [FloatingNavBar] 와 달리 탭 목록을 밖에서 넘겨받으므로, 하위 화면
/// 에서도 같은 감각의 탭 전환을 쓸 수 있다. 본문이 바 뒤로 비치도록 Scaffold 는
/// `extendBody: true` 로 두고, 목록은 `MediaQuery.padding.bottom` 만큼 아래
/// 여백을 준다(Scaffold 가 바 높이를 그 값에 더해준다).
class const FloatingPillTabBar({
  super.key,
  required final List<PillTabItem> items,
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
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    // 라벨 길이가 달라도 탭 너비가 같도록, IntrinsicWidth 로
                    // '가장 넓은 탭 × 개수' 를 잡고 Expanded 로 나눠 갖는다.
                    child: IntrinsicWidth(
                      child: Row(
                        children: [
                          for (int i = 0; i < items.length; i++)
                            Expanded(
                              child: _PillTabItemView(
                                item: items[i],
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
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.focusColor;
    final Color mutedColor =
        theme.textTheme.bodySmall?.color ?? theme.hintColor;
    final Color tint = isSelected ? focusColor : mutedColor;

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
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(_kPillRadius),
            child: Padding(
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
