import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider.dart';

class const PlainDividerWidget({
  super.key,
  final double height = 1,
  final double thickness = 1,
  final double indent = 15,
  final double endIndent = 8,
}) extends StatelessWidget {
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
