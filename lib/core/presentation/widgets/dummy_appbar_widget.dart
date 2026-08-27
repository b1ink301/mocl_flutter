import 'dart:io';

import 'package:material_ui/material_ui.dart';

class const DummyAppBarWidget._()
    extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // final statusBarColor =
    //     Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor;

    return AppBar(
      toolbarHeight: 0,
      scrolledUnderElevation: 0,
      // flexibleSpace: Container(color: statusBarColor),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(0);

  static PreferredSizeWidget? buildDummyAppbar() =>
      Platform.isIOS ? const DummyAppBarWidget._() : null;
}
