import 'package:flutter/material.dart';

class PlainIcon extends StatelessWidget {
  final IconData icon;

  /// null 이면 주변 [IconTheme]/[DefaultTextStyle] 색을 따른다.
  /// (앱바 액션은 AppBar 의 foregroundColor 로 IconTheme 이 설정되므로
  /// Paper 테마의 밝은 앱바에서 자동으로 잉크색이 된다.)
  final Color? color;
  final double size;

  const PlainIcon(this.icon, {super.key, this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final Color resolved =
        color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF181A1F);
    return RichText(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: size,
          color: resolved,
        ),
      ),
    );
  }
}
