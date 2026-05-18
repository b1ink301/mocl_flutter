import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

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
    this.padding = const EdgeInsets.symmetric(horizontal: 4.1, vertical: 0.6),
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    // 1. textStyle이 주입되었다면 context 조회를 생략합니다.
    final TextStyle effectiveTextStyle =
        textStyle ?? DefaultTextStyle.of(context).style;

    // 2. 테두리 색상 결정
    final Color effectiveBorderColor =
        borderColor ?? effectiveTextStyle.color ?? const Color(0xFF000000);

    // 3. Container 대신 DecoratedBox + Padding 조합으로 위젯 트리 깊이를 최소화합니다.
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: effectiveBorderColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: PlainText(text, maxLines: 1, style: effectiveTextStyle),
      ),
    );
  }
}
