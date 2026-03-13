import 'dart:io';

import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/main_page/presentation/state/main_state_mixin.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/mocl_drawer_widget.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

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
    child: PlatformScaffold(
      body: PlatformWidget(
        material: (_, _) => const MainView(),
        cupertino: (_, _) => const _MainCupertinoView(),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      material: (_, _) => MaterialScaffoldData(
        widgetKey: scaffoldState(ref),
        drawer: const DrawerWidget(),
        drawerEdgeDragWidth: screenWidth(ref),
        drawerEnableOpenDragGesture: true,
      ),
    ),
  );
}

class _MainCupertinoView extends ConsumerWidget with MainState, MainEvent {
  const _MainCupertinoView();

  void _onDestinationSelected(WidgetRef ref, BuildContext context, int index) {
    final siteType = SiteType.values
        .where((s) => s != SiteType.settings)
        .toList()[index];
    changeSiteType(ref, siteType);
    sidebarClose(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = isSidebarExpanded(ref);

    if (Platform.isIOS) {
      return Stack(
        children: [
          const CupertinoTabTransitionBuilder(child: MainView()),
          if (isExpanded)
            GestureDetector(
              onTap: () => sidebarClose(ref),
              behavior: .opaque, // 뒤쪽 터치 이벤트 캔슬
              child: Container(
                color: Colors.black38, // 투명한 레이어
              ),
            ),
          CupertinoSidebarCollapsible(
            isExpanded: isExpanded,
            child: CupertinoSidebar(
              maxWidth: 240,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedIndex: SiteType.values.indexOf(currentSiteType(ref)),
              onDestinationSelected: (index) =>
                  _onDestinationSelected(ref, context, index),
              navigationBar: SidebarNavigationBar(
                title: PlatformText(AppLocalizations.of(context)!.menu),
              ),
              children: _buildChildrenCupertinoSidebar(context),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          CupertinoSidebarCollapsible(
            isExpanded: isExpanded,
            child: CupertinoSidebar(
              maxWidth: 250,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedIndex: SiteType.values.indexOf(currentSiteType(ref)),
              onDestinationSelected: (index) =>
                  _onDestinationSelected(ref, context, index),
              navigationBar: SidebarNavigationBar(
                title: PlatformText(AppLocalizations.of(context)!.menu),
              ),
              children: _buildChildrenCupertinoSidebar(context),
            ),
          ),
          Expanded(
            child: const CupertinoTabTransitionBuilder(child: MainView()),
          ),
        ],
      );
    }
  }

  List<Widget> _buildChildrenCupertinoSidebar(BuildContext context) => [
    SidebarSection(
      label: PlatformText(AppLocalizations.of(context)!.site),
      children: SiteType.values
          .where((s) => s != SiteType.settings)
          .map((s) => SidebarDestination(label: PlatformText(s.title)))
          .toList(),
    ),
    SidebarSection(
      label: PlatformText('설정'),
      children: [
        SidebarDestination(
          label: PlatformText(SiteType.settings.title),
          onTap: () => context.push(Routes.settings),
        ),
      ],
    ),
  ];
}
