import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/photo_view_dialog.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/login/login_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/add_list_dialog.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/settings_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dialog_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

part 'mocl_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.main;

  static final router = GoRouter(
    initialLocation: initial,
    routes: <RouteBase>[
      GoRoute(
          path: Routes.main,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              SwipeablePage(builder: (context) => MainPage.withBloc(context)),
          routes: [
            GoRoute(
                path: Routes.setMainDlg,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    CupertinoModalPopupPage(
                      builder: (BuildContext context) {
                        final siteType =
                            GoRouterState.of(context).extra as SiteType;
                        return AddListDialog.withBloc(context, siteType);
                      },
                    )),
          ]),
      GoRoute(
        path: Routes.list,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(builder: (context) {
          final item = GoRouterState.of(context).extra as MainItem;
          return MoclListPage.withBloc(context, item);
        }),
      ),
      GoRoute(
          path: Routes.detail,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              SwipeablePage(
                builder: (context) {
                  final extra =
                      GoRouterState.of(context).extra as List<dynamic>;
                  final siteType = extra[0] as SiteType;
                  final item = extra[1] as ReadableListItem;
                  return DetailPage.withBloc(context, siteType, item);
                },
              ),
          routes: [
            GoRoute(
                path: Routes.viewPhotoDlg,
                pageBuilder: (BuildContext context, GoRouterState state) =>
                    CupertinoModalPopupPage(
                      builder: (BuildContext context) {
                        final url = GoRouterState.of(context).extra as String;
                        return PhotoViewDialog(
                          imageProvider: NetworkImage(url),
                          filterQuality: FilterQuality.high,
                        );
                      },
                    )),
          ]),
      GoRoute(
        path: Routes.settings,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(builder: (context) => SettingsPage.withBloc(context)),
      ),
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      )
    ],
  );
}
