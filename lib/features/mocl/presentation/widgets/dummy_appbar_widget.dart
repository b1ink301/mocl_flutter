import 'dart:io';

import 'package:flutter/material.dart';

class DummyAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const DummyAppBarWidget._();

  @override
  Widget build(BuildContext context) {
    final statusBarColor =
        Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor;

    return AppBar(
      toolbarHeight: 0,
      flexibleSpace: Container(color: statusBarColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);

  static PreferredSizeWidget? buildDummyAppbar() =>
      Platform.isIOS ? const DummyAppBarWidget._() : null;
}
