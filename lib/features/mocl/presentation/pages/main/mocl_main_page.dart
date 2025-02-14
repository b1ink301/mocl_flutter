import 'package:cupertino_sidebar/cupertino_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

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
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<ScaffoldState> scaffoldState =
        ref.watch(mainScaffoldStateProvider);

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
          key: scaffoldState,
          body: PlatformWidget(
            material: (_, __) => const MainView(),
            cupertino: (_, __) => const _MainCupertinoView(),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          material: (_, __) => MaterialScaffoldData(
            drawer: const DrawerWidget(),
            drawerEdgeDragWidth: ref.watch(screenWidthProvider),
            drawerEnableOpenDragGesture: true,
          ),
          cupertino: (_, __) => CupertinoPageScaffoldData(),
        ));
  }
}

class _MainCupertinoView extends ConsumerWidget {
  const _MainCupertinoView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSidebarExpanded = ref.watch(mainSidebarNotifierProvider);
    final sidebarClose = ref.read(mainSidebarNotifierProvider.notifier).close;

    changeSiteType(SiteType siteType) => ref
        .read(currentSiteTypeNotifierProvider.notifier)
        .changeSiteType(siteType);

    return Stack(
      children: [
        const CupertinoTabTransitionBuilder(
          child: MainView(),
        ),
        if (isSidebarExpanded)
          GestureDetector(
            onTap: sidebarClose,
            behavior: HitTestBehavior.opaque, // 뒤쪽 터치 이벤트 캔슬
            child: Container(
              color: Colors.black45, // 투명한 레이어
            ),
          ),
        CupertinoSidebarCollapsible(
          isExpanded: isSidebarExpanded,
          child: CupertinoSidebar(
            maxWidth: 240,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedIndex: SiteType.values
                .indexOf(ref.watch(currentSiteTypeNotifierProvider)),
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
              SidebarSection(label: PlatformText('설정'), children: [
                SidebarDestination(
                    label: PlatformText(SiteType.settings.title),
                    onTap: () {
                      context.push(Routes.settings);
                      sidebarClose();
                    }),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
