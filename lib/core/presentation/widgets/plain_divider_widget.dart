import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider.dart';

class PlainDividerWidget extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  const PlainDividerWidget({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.indent = 15,
    this.endIndent = 8,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).dividerColor;
    return PlainDivider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
