import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';

class const CupertinoModalPopupPage<T>({
  required final WidgetBuilder builder,
  final Offset? anchorPoint,
  final Color? barrierColor = kCupertinoModalBarrierColor,
  final bool barrierDismissible = true,
  final String barrierLabel = "Dismiss",
  final bool semanticsDismissible = true,
  final ImageFilter? filter,
  super.key,
}) extends Page<T> {
  @override
  Route<T> createRoute(BuildContext context) => CupertinoModalPopupRoute<T>(
    builder: builder,
    barrierDismissible: barrierDismissible,
    anchorPoint: anchorPoint,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    filter: filter,
    semanticsDismissible: semanticsDismissible,
    settings: this,
  );
}
