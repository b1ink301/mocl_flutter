import 'dart:io';

import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  static Widget init(BuildContext context, double width) => ProviderScope(
    overrides: [screenWidthProvider.overrideWithValue(width)],
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle!,
      child: const MainPage(),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldState = ref.watch(
      mainScaffoldStateProvider,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) {
          return;
        }
        if (scaffoldState.currentState?.isDrawerOpen == true) {
          scaffoldState.currentState?.closeDrawer();
        } else {
          SystemNavigator.pop();
        }
      },
      child: PlatformScaffold(
        body: PlatformWidget(
          material: (_, _) => const MainView(),
          cupertino: (_, _) => const _MainCupertinoView(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        material: (_, _) => MaterialScaffoldData(
          widgetKey: scaffoldState,
          drawer: const DrawerWidget(),
          drawerEdgeDragWidth: ref.watch(screenWidthProvider),
          drawerEnableOpenDragGesture: true,
        ),
        // cupertino: (_, _) => CupertinoPageScaffoldData(),
      ),
    );
  }
}

class _MainCupertinoView extends ConsumerWidget {
  const _MainCupertinoView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSidebarExpanded = ref.watch(mainSidebarNotifierProvider);
    final sidebarClose = ref.read(mainSidebarNotifierProvider.notifier).close;

    changeSiteType(siteType) => ref
        .read(currentSiteTypeNotifierProvider.notifier)
        .changeSiteType(siteType);

    if (Platform.isIOS) {
      return Stack(
        children: [
          const CupertinoTabTransitionBuilder(child: MainView()),
          if (isSidebarExpanded)
            GestureDetector(
              onTap: sidebarClose,
              behavior: HitTestBehavior.opaque, // 뒤쪽 터치 이벤트 캔슬
              child: Container(
                color: Colors.black38, // 투명한 레이어
              ),
            ),
          CupertinoSidebarCollapsible(
            isExpanded: isSidebarExpanded,
            child: CupertinoSidebar(
              maxWidth: 240,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedIndex: SiteType.values.indexOf(
                ref.watch(currentSiteTypeNotifierProvider),
              ),
              onDestinationSelected: (index) {
                final siteType = SiteType.values
                    .where((s) => s != SiteType.settings)
                    .toList()[index];
                changeSiteType(siteType);
                sidebarClose();
              },
              navigationBar: SidebarNavigationBar(
                title: PlatformText(AppLocalizations.of(context)!.menu),
              ),
              children: [
                SidebarSection(
                  label: PlatformText(AppLocalizations.of(context)!.site),
                  children: SiteType.values
                      .where((s) => s != SiteType.settings)
                      .map(
                        (s) => SidebarDestination(label: PlatformText(s.title)),
                      )
                      .toList(),
                ),
                SidebarSection(
                  label: PlatformText('설정'),
                  children: [
                    SidebarDestination(
                      label: PlatformText(SiteType.settings.title),
                      onTap: () {
                        context.push(Routes.settings);
                        sidebarClose();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          CupertinoSidebarCollapsible(
            isExpanded: isSidebarExpanded,
            child: CupertinoSidebar(
              maxWidth: 250,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedIndex: SiteType.values.indexOf(
                ref.watch(currentSiteTypeNotifierProvider),
              ),
              onDestinationSelected: (index) {
                final siteType = SiteType.values
                    .where((s) => s != SiteType.settings)
                    .toList()[index];
                changeSiteType(siteType);
              },
              navigationBar: SidebarNavigationBar(
                title: PlatformText(AppLocalizations.of(context)!.menu),
              ),
              children: [
                SidebarSection(
                  label: PlatformText(AppLocalizations.of(context)!.site),
                  children: SiteType.values
                      .where((s) => s != SiteType.settings)
                      .map(
                        (s) => SidebarDestination(label: PlatformText(s.title)),
                      )
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
              ],
            ),
          ),
          Expanded(
            child: const CupertinoTabTransitionBuilder(child: MainView()),
          ),
        ],
      );
    }
  }
}
