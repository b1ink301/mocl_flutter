import 'package:material_ui/material_ui.dart';

/// 앱바용 고정 IconTheme.
///
/// floating 앱바는 부분 노출 중 toolbarOpacity 를 IconThemeData 에 심어
/// 매 프레임 IconTheme 이 변한다(app_bar.dart 의 copyWith(opacity: ...)).
/// IconTheme.of 를 구독하는 PlainIcon 이 스크롤 내내 리빌드되는 것을 막기 위해
/// 앱바 아이콘을 고정 IconTheme 으로 감싼다. 색은 앱바 foregroundColor 를
/// 따르므로 테마 전환 시에는 정상적으로 갱신된다.
class const AppbarFixedIconTheme({super.key, required final Widget child})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IconTheme(
      data: IconThemeData(
        size: 24,
        color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
      ),
      child: child,
    );
  }
}

/// 액션 영역용 [AppbarFixedIconTheme]. 여러 버튼을 한 줄로 묶는다.
class const AppbarActionsIconTheme({
  super.key,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppbarFixedIconTheme(
    child: Row(mainAxisSize: MainAxisSize.min, children: children),
  );
}
