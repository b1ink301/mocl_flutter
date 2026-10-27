import 'package:material_ui/material_ui.dart';

class const DividerWidget({
  super.key,
  final double height = 1,
  final double thickness = 1,
  final double indent = 15,
  final double endIndent = 8,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
    height: height,
    thickness: thickness,
    indent: indent,
    endIndent: endIndent,
  );
}
