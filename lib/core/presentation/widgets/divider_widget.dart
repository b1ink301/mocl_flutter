import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  const DividerWidget({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.indent = 15,
    this.endIndent = 8,
  });

  @override
  Widget build(BuildContext context) => Divider(
        height: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      );
}
