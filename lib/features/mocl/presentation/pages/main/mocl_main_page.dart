import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Widget init(BuildContext context) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: const MainPage(),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
        drawerEnableOpenDragGesture: true,
        drawer: const DrawerWidget(),
        appBar: DummyAppBarWidget.buildDummyAppbar(),
        body: const SafeArea(
          left: false,
          right: false,
          child: MainView(),
        ),
      );
}
