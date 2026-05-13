import 'package:flutter/material.dart';

/// Material `IconButton` 의 의존성(Theme/IconTheme/Tooltip 등)을 제거한
/// 간소화 버튼. SliverAppBar floating 같이 ancestor InheritedWidget 이
/// 자주 교체되는 상황에서 행/액션이 불필요하게 리빌드되는 것을 막는다.
///
/// 기본적으로 Material ripple 효과는 없다. tooltip 도 미지원.
class PlainIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;

  const PlainIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onPressed,
    child: Padding(padding: padding, child: icon),
  );
}
