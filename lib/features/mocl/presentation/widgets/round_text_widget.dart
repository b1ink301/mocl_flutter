import 'package:flutter/material.dart';

class RoundTextWidget extends StatelessWidget {
  final String text;

  const RoundTextWidget({super.key, required this.text});

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
            Border.all(color: Theme.of(context).textTheme.labelSmall!.color!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
