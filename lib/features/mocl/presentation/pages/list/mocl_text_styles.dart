import 'package:flutter/material.dart';

class TextStyles {
  final TextStyle? titleTextStyle;
  final TextStyle? readTitleTextStyle;
  final TextStyle? smallTextStyle;
  final TextStyle? readSmallTextStyle;
  final TextStyle? badgeTextStyle;
  final TextStyle? readBadgeTextStyle;

  TextStyles({
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

    return TextStyles(
      titleTextStyle: theme.textTheme.bodyMedium,
      readTitleTextStyle: theme.textTheme.bodyMedium?.copyWith(color: color),
      smallTextStyle: theme.textTheme.bodySmall,
      readSmallTextStyle: theme.textTheme.bodySmall?.copyWith(color: color),
      badgeTextStyle: theme.textTheme.labelSmall,
      readBadgeTextStyle: theme.textTheme.labelSmall?.copyWith(color: color),
    );
  }
}
