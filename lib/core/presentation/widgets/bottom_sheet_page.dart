import 'package:flutter/material.dart';

class ModalBottomSheetPage<T> extends Page<T> {
  final WidgetBuilder builder;
  final bool isScrollControlled;
  final Color? backgroundColor;

  const ModalBottomSheetPage({
    required this.builder,
    this.isScrollControlled = true,
    this.backgroundColor = Colors.transparent,
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    builder: builder,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    settings: this,
  );
}
