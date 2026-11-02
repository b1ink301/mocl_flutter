import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

/// Material 3 창 크기 구분(폭 기준, 단위 dp).
///
/// 폰 · 폴드 접힘은 [compact], 폴드 펼침 세로 · 작은 태블릿 세로는 [medium],
/// 태블릿 가로 · 폴드 펼침 가로 · iPad 는 [expanded] 이상이다.
enum WindowSize() {
  compact,
  medium,
  expanded,
  large;

  static const double mediumMin = 600;
  static const double expandedMin = 840;
  static const double largeMin = 1200;

  static WindowSize fromWidth(double width) => width >= largeMin
      ? large
      : width >= expandedMin
      ? expanded
      : width >= mediumMin
      ? medium
      : compact;

  /// 목록과 상세를 나란히 놓을 만큼 넓은지.
  bool get isSplit => index >= expanded.index;
}

/// 본문 최대 폭. 넓은 화면에서 한 줄이 너무 길어지지 않게 가운데로 모은다.
abstract final class ReadableWidth._() {
  /// 글 본문 · 댓글.
  static const double detail = 720;

  /// 목록 · 설정처럼 행이 나열되는 화면.
  static const double list = 840;

  /// 바텀시트.
  static const double sheet = 640;

  /// [available] 폭에서 [maxWidth] 를 가운데 두려면 양옆에 얼마씩 비워야 하는지.
  static double inset(double available, double maxWidth) =>
      math.max(0, (available - maxWidth) / 2);
}

extension WindowSizeContext on BuildContext {
  /// 창 크기 구분. 폭이 바뀔 때만 다시 그려진다.
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}

/// 자식 sliver 를 [maxWidth] 안에 가운데로 둔다(남는 폭은 양옆 여백).
///
/// 폭이 [maxWidth] 이하인 폰에서는 여백 없이 그대로 그린다.
class const SliverReadableWidth({
  required final Widget sliver,
  final double maxWidth = ReadableWidth.list,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final double inset = ReadableWidth.inset(
        constraints.crossAxisExtent,
        maxWidth,
      );
      if (inset == 0) return sliver;
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: inset),
        sliver: sliver,
      );
    },
  );
}

/// box 위젯용 [SliverReadableWidth].
class const BoxReadableWidth({
  required final Widget child,
  final double maxWidth = ReadableWidth.list,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    widthFactor: 1,
    heightFactor: 1,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
