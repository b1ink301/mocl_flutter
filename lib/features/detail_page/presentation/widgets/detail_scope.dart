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

/// 상세 화면이 실제로 받은 폭.
///
/// 화면 폭과 다를 수 있다(목록 옆 상세 칸). 스크롤과 무관한 상위 박스에서 재서
/// 내리므로, 스크롤할 때마다 앱바가 다시 그려지지 않는다.
class const DetailWidthScope({
  required final double width,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DetailWidthScope>()!.width;

  @override
  bool updateShouldNotify(DetailWidthScope oldWidget) =>
      width != oldWidget.width;
}
