import 'package:flutter/material.dart';

import '../../../../config/mocl_text_styles.dart';

class DetailStyleScope extends InheritedWidget {
  final AppTextStyles styles;
  final String hexColor;

  const DetailStyleScope({
    required this.styles,
    required this.hexColor,
    required super.child,
    super.key,
  });

  static (AppTextStyles, String) of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DetailStyleScope>()!;

    return (scope.styles, scope.hexColor);
  }

  @override
  bool updateShouldNotify(DetailStyleScope oldWidget) =>
      styles != oldWidget.styles || hexColor != oldWidget.hexColor;
}
