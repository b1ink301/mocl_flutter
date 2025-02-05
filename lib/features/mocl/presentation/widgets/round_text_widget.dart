import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class RoundTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;

  const RoundTextWidget({
    super.key,
    required this.text,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) => _buildRoundText(context);

  Widget _buildRoundText(
    BuildContext context,
  ) {
    final effectiveTextStyle = textStyle ?? DefaultTextStyle.of(context).style;
    final effectiveBorderColor = borderColor ?? effectiveTextStyle.color ?? const Color(0xFF000000);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: effectiveBorderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: PlatformText(
        text,
        maxLines: 1,
        style: effectiveTextStyle,
      ),
    );
  }
}
