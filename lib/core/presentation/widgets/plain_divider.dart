import 'package:material_ui/material_ui.dart';

/// Theme/DividerTheme 의존성을 제거한 단순 구분선.
///
/// Material `Divider` 는 `DividerTheme.of(context)` 와 `Theme.of(context)` 를
/// watch 하므로 ancestor InheritedWidget 이 교체되면 리빌드된다.
/// PlainDivider 는 모든 값을 props 로 받아 inherited 의존 0.
class const PlainDivider({
  super.key,

  /// 전체 차지 높이 (라인 + 위아래 여백).
  final double height = 1,

  /// 실제 그려지는 라인 두께.
  final double thickness = 1,

  /// 좌측 여백.
  final double indent = 15,

  /// 우측 여백.
  final double endIndent = 8,

  /// 라인 색상.
  final Color color = const Color(0xFFE0E0E0),
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: Center(
      child: Container(
        height: thickness,
        margin: EdgeInsets.only(left: indent, right: endIndent),
        color: color,
      ),
    ),
  );
}
