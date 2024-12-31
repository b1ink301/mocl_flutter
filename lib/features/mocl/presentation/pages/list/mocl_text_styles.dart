import 'package:flutter/material.dart';

class TextStyles {
  final TextStyle? titleTextStyle;
  final TextStyle? readTitleTextStyle;
  final TextStyle? smallTextStyle;
  final TextStyle? readSmallTextStyle;
  final TextStyle? badgeTextStyle;
  final TextStyle? readBadgeTextStyle;

  const TextStyles({
    this.titleTextStyle,
    this.readTitleTextStyle,
    this.smallTextStyle,
    this.readSmallTextStyle,
    this.badgeTextStyle,
    this.readBadgeTextStyle,
  });

  factory TextStyles.empty() => TextStyles();

  factory TextStyles.getTextStyles(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.highlightColor;
    final bodyMedium = theme.textTheme.bodyMedium;
    final bodySmall = theme.textTheme.bodySmall;
    final labelSmall = theme.textTheme.labelSmall;

    return TextStyles(
      titleTextStyle: bodyMedium,
      readTitleTextStyle: bodyMedium?.copyWith(color: color),
      smallTextStyle: bodySmall,
      readSmallTextStyle: bodySmall?.copyWith(color: color),
      badgeTextStyle: labelSmall,
      readBadgeTextStyle: labelSmall?.copyWith(color: color),
    );
  }
}
