import 'package:material_ui/material_ui.dart';

/// 화면 아래에 떠 있는 알약형 탭바.
///
/// 목록이 바 뒤로 흘러가며 비치도록 Scaffold 는 `extendBody: true` 로 쓴다.
/// (그러면 Scaffold 가 본문 MediaQuery 의 bottom padding 을 이 바 높이만큼
///  잡아주므로, 각 탭은 기존의 `padding.bottom` 처리만으로 가려짐 없이 그려진다)
class const FloatingNavBar({
  super.key,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,
}) extends StatelessWidget {
  static const double _radius = 28;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color barColor =
        theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(_radius),
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
          clipBehavior: Clip.antiAlias,
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            backgroundColor: Colors.transparent,
            elevation: 0,
            height: 62,
            // 선택된 탭만 라벨을 보여줘 알약 안이 답답해지지 않게 한다.
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: '내 게시판',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.bookmark),
                label: '스크랩',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: '설정',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
