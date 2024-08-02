import 'package:flutter/material.dart';

class RoundTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const RoundTextWidget({super.key, required this.text, this.textStyle});

  @override
  Widget build(BuildContext context) => _buildRoundText(context);

  Widget _buildRoundText(
    BuildContext context,
  ) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        border:
            Border.all(color: textStyle?.color ?? const Color(0xFF000000)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
