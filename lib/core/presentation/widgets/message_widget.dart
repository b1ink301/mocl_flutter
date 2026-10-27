import 'package:material_ui/material_ui.dart';

class const MessageWidget({
  super.key,
  required final String message,
  final double? fontSize,
  final TextStyle? textStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text(
    message,
    style: textStyle ?? TextStyle(fontSize: fontSize ?? 16),
    textAlign: TextAlign.start,
    maxLines: 3,
  );
}
