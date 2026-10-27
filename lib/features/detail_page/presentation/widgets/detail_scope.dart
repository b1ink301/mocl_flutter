import 'package:material_ui/material_ui.dart';

import '../../../../config/mocl_text_styles.dart';

class const DetailStyleScope({
  required final AppTextStyles styles,
  required final String hexColor,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static (AppTextStyles, String) of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DetailStyleScope>()!;

    return (scope.styles, scope.hexColor);
  }

  @override
  bool updateShouldNotify(DetailStyleScope oldWidget) =>
      styles != oldWidget.styles || hexColor != oldWidget.hexColor;
}
