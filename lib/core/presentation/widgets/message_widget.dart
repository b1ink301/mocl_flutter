import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final double? fontSize;
  final TextStyle? textStyle;

  const MessageWidget({
    super.key,
    required this.message,
    this.fontSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) => PlatformText(
        message,
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 16,
            ),
        textAlign: TextAlign.start,
        maxLines: 3,
      );
}
