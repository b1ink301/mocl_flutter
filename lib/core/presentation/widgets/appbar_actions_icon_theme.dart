import 'package:flutter/material.dart';

/// 앱바 액션 영역용 고정 IconTheme 래퍼.
///
/// floating 앱바는 부분 노출 중 toolbarOpacity 를 IconThemeData 에 심어
/// 매 프레임 IconTheme 이 변한다(app_bar.dart 의 copyWith(opacity: ...)).
/// IconTheme.of 를 구독하는 PlainIcon 이 스크롤 내내 리빌드되는 것을 막기 위해
/// 액션들을 고정 IconTheme 으로 감싼다. 색은 앱바 foregroundColor 를 따르므로
/// 테마 전환 시에는 정상적으로 갱신된다.
class AppbarActionsIconTheme extends StatelessWidget {
  final List<Widget> children;

  const AppbarActionsIconTheme({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return IconTheme(
      data: IconThemeData(
        size: 24,
        color: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}
