import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar_widget.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  static Widget init(BuildContext context) => ProviderScope(
        overrides: [
          screenWidthProvider
              .overrideWithValue(MediaQuery.of(context).size.width)
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle!,
          child: const MainPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        drawerEdgeDragWidth: ref.watch(screenWidthProvider),
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
