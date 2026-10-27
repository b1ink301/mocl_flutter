import 'dart:io';

import 'package:material_ui/material_ui.dart';

/// 드로어를 여는 메뉴 아이콘.
///
/// 폰트 아이콘에는 이 비율이 없어 직접 그린다.
/// (`Icons.menu` 는 세 줄이 모두 같은 길이, `Icons.sort` 는 100/66/33 으로
///  줄어든다. 여기선 위 두 줄이 같고 마지막 줄만 절반이다.)
///
/// 색은 [PlainIcon] 과 같은 순서로 해석해, 앱바 `foregroundColor` 가 만든
/// [IconTheme] 을 그대로 따른다.
class const MenuLinesIcon({
  super.key,
  final Color? color,
  final double size = 24,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color resolved =
        color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF181A1F);

    // Center 로 감싸는 이유: 앱바 leading 처럼 부모가 tight 제약을 주면
    // CustomPaint 의 `size` 는 무시되고 제약(≈40dp)까지 늘어나 선이 그만큼
    // 길고 굵어진다. Center 가 자식에게 loose 제약을 주어 `size` 를 지킨다.
    return Center(
      child: CustomPaint(
        size: Size.square(size),
        painter: _MenuLinesPainter(resolved),
      ),
    );
  }
}

class const _MenuLinesPainter(final Color color) extends CustomPainter {
  /// 설계 기준 캔버스(24x24). 실제 크기에 맞춰 비례 확대한다.
  /// 값은 참고 스샷을 실측해 24dp 기준으로 환산한 것.
  static const double _designSize = 24;
  static const double _left = 4;
  static const double _longWidth = 16;
  static const double _shortWidth = 8;
  static const double _gap = 6;
  static const double _stroke = 2.2;
  static final double _topPadding = Platform.isIOS ? 0 : 2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.shortestSide / _designSize;
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = _stroke * scale
      ..strokeCap = StrokeCap.round;

    final double x = _left * scale;
    final double centerY = size.height / 2;

    // (중심에서의 세로 오프셋, 선 길이)
    const List<(double, double)> lines = [
      (-_gap, _longWidth),
      (0, _longWidth),
      (_gap, _shortWidth),
    ];

    for (final (double dy, double width) in lines) {
      final double y = centerY + dy * scale + _topPadding;
      canvas.drawLine(Offset(x, y), Offset(x + width * scale, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MenuLinesPainter oldDelegate) =>
      oldDelegate.color != color;
}
