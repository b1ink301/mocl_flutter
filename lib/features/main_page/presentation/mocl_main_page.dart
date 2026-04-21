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
  ) => ProviderScope(
    overrides: MainEvent.overridesProviderScope(context, width),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light,
      child: const MainPage(),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopScope(
    canPop: true,
    onPopInvokedWithResult: (bool didPop, _) => handlePop(ref, didPop),
    child: Container(
      color: Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor,
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
