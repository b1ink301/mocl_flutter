import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_drawer_widget.dart';

import 'mocl_main_view.dart';
import 'state/main_event_mixin.dart';

class MainPage extends ConsumerWidget with MainState, MainEvent {
  const MainPage({super.key});

  static Widget init(
    BuildContext context,
    double width,
    double statusBarHeight,
  ) => ProviderScope(
    overrides: MainEvent.overridesProviderScope(context, width),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle!,
      child: Stack(
        children: [
          const Positioned.fill(child: MainPage()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: statusBarHeight,
              color: const Color(0x22000000),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopScope(
    canPop: true,
    onPopInvokedWithResult: (bool didPop, _) => handlePop(ref, didPop),
    child: Scaffold(
      key: scaffoldState(ref),
      drawer: const DrawerWidget(),
      drawerEdgeDragWidth: screenWidth(ref),
      drawerEnableOpenDragGesture: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const MainView(),
    ),
  );
}
