import 'dart:io';

import 'package:flutter/material.dart';

PreferredSizeWidget? buildDummyAppbar(BuildContext context) {
  final statusBarColor =
      Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor;
  return Platform.isIOS
      ? AppBar(
          toolbarHeight: 0,
          flexibleSpace: Container(color: statusBarColor),
        )
      : null;
}
