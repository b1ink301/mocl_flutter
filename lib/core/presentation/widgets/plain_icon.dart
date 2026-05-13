import 'package:flutter/material.dart';

class PlainIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const PlainIcon(
    this.icon, {
    super.key,
    this.color = Colors.white,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) => RichText(
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        fontSize: size,
        color: color,
      ),
    ),
  );
}
