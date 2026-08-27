import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_drawer_widget.dart';

import 'mocl_main_view.dart';
import 'state/main_event_mixin.dart';

class const MainPage({super.key})
    extends ConsumerWidget
    with MainEvent, MainState {
  static Widget init(double width) => ProviderScope(
    overrides: MainEvent.overridesProviderScope(width),
    child: const MainPage(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopScope(
    canPop: !isSidebarExpanded(ref),
    onPopInvokedWithResult: (bool didPop, _) => handlePop(ref, didPop),
    child: const _ScaffoldWidget(),
  );
}

class const _ScaffoldWidget() extends ConsumerWidget with MainState, MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemOverlayStyle =
        Theme.of(context).appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        key: scaffoldState(ref),
        drawer: const DrawerWidget(),
        onDrawerChanged: (isOpen) =>
            isOpen ? sidebarOpen(ref) : sidebarClose(ref),
        drawerEdgeDragWidth: screenWidth(ref) / 2,
        drawerEnableOpenDragGesture: true,
        body: const MainView(),
      ),
    );
  }
}
