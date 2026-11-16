import 'package:material_ui/material_ui.dart';

/// Material `IconButton` 의 의존성(Theme/IconTheme/Tooltip 등)을 제거한
/// 간소화 버튼. SliverAppBar floating 같이 ancestor InheritedWidget 이
/// 자주 교체되는 상황에서 행/액션이 불필요하게 리빌드되는 것을 막는다.
///
/// 기본적으로 Material ripple 효과는 없다. tooltip 도 미지원 — 대신 화면 낭독용
/// 이름은 [semanticLabel] 로 준다(Tooltip 과 달리 상위 Theme 에 의존하지 않는다).
class const PlainIconButton({
  super.key,
  required final Widget icon,
  final VoidCallback? onPressed,

  /// 아이콘 둘레 여백. 없으면 앱바 안([AppbarIconButtonScope])에서는 12(터치 영역 48),
  /// 그 밖에서는 8.
  final EdgeInsetsGeometry? padding,

  /// 화면 낭독(TalkBack · VoiceOver)이 읽는 버튼 이름. 없으면 이름 없는 버튼이 된다.
  final String? semanticLabel,

  /// 기기 확인 스크립트(`tool/device_check.dart`)가 찾는 id. Android 에서는
  /// UI 트리의 resource-id 로 나간다. 화면 낭독에는 영향이 없다.
  final String? semanticsId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget button = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Padding(
        padding: padding ?? AppbarIconButtonScope.paddingOf(context),
        child: icon,
      ),
    );
    if (semanticLabel == null && semanticsId == null) return button;
    return Semantics(
      container: true,
      button: true,
      label: semanticLabel,
      identifier: semanticsId,
      child: ExcludeSemantics(child: button),
    );
  }
}

/// 앱바 아이콘 버튼 자리. 안쪽 [PlainIconButton] · `PlainPopupMenuButton` 이
/// 여백을 따로 받지 않으면 M3 터치 영역(48 = 아이콘 24 + 12씩)으로 그린다.
///
/// 값이 바뀌지 않으므로 의존을 걸지 않고 읽는다(floating 앱바 리빌드와 무관).
class const AppbarIconButtonScope({super.key, required super.child})
    extends InheritedWidget {
  static const EdgeInsets appbarPadding = EdgeInsets.all(12);
  static const EdgeInsets defaultPadding = EdgeInsets.all(8);

  static EdgeInsets paddingOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppbarIconButtonScope>() == null
      ? defaultPadding
      : appbarPadding;

  @override
  bool updateShouldNotify(AppbarIconButtonScope oldWidget) => false;
}
