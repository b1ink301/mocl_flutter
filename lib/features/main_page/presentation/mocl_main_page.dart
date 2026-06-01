import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_drawer_widget.dart';

import 'mocl_main_view.dart';
import 'state/main_event_mixin.dart';

class MainPage extends ConsumerWidget with MainEvent {
  const MainPage({super.key});

  static Widget init(double width) => ProviderScope(
    overrides: MainEvent.overridesProviderScope(width),
    child: const MainPage(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopScope(
    canPop: true,
    onPopInvokedWithResult: (bool didPop, _) => handlePop(ref, didPop),
    child: const _ScaffoldWidget(),
  );
}

class _ScaffoldWidget extends ConsumerWidget with MainState, MainEvent {
  const _ScaffoldWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemOverlayStyle =
        Theme.of(context).appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      sized: false,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            key: scaffoldState(ref),
            drawer: const DrawerWidget(),
            drawerEdgeDragWidth: screenWidth(ref),
            drawerEnableOpenDragGesture: true,
            body: const MainView(),
          ),
        ),
      ),
    );
  }
}
