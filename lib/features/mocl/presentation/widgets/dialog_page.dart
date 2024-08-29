import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CupertinoModalPopupPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String barrierLabel;
  final bool semanticsDismissible;
  final WidgetBuilder builder;
  final ImageFilter? filter;

  const CupertinoModalPopupPage(
      {required this.builder,
        this.anchorPoint,
        this.barrierColor = kCupertinoModalBarrierColor,
        this.barrierDismissible = true,
        this.barrierLabel = "Dismiss",
        this.semanticsDismissible = true,
        this.filter,
        super.key});

  @override
  Route<T> createRoute(BuildContext context) => CupertinoModalPopupRoute<T>(
      builder: builder,
      barrierDismissible: barrierDismissible,
      anchorPoint: anchorPoint,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      filter: filter,
      semanticsDismissible: semanticsDismissible,
      settings: this);
}