import 'package:flutter/material.dart';

import 'mocl_text_styles.dart';

class TextStylesProvider extends InheritedWidget {
  final TextStyles textStyles;

  const TextStylesProvider({
    super.key,
    required this.textStyles,
    required super.child,
  });

  static TextStylesProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TextStylesProvider>()!;

  @override
  bool updateShouldNotify(TextStylesProvider oldWidget) =>
      textStyles != oldWidget.textStyles;
}
