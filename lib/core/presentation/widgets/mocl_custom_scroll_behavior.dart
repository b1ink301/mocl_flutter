import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

class const CustomScrollBehavior() extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
