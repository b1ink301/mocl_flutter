import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/dialog_page.dart';
import 'package:mocl_flutter/features/add_main_dialog/presentation/add_list_dialog.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/detail_page/presentation/photo_view_dialog.dart';
import 'package:mocl_flutter/features/list_page/presentation/mocl_list_page.dart';
import 'package:mocl_flutter/features/login_page/presentation/login_page.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_page.dart';
import 'package:mocl_flutter/features/settings_page/presentation/pages/settings/settings_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

part 'mocl_routes.dart';

class AppPages {
  AppPages._();

  static const String initial = Routes.main;

  static final GoRouter router = GoRouter(
    initialLocation: Routes.main,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.main,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final width = MediaQuery.of(context).size.width;
                final double statusBarHeight = MediaQuery.of(
                  context,
                ).padding.top;
                return MainPage.init(context, width, statusBarHeight);
              },
            ),
        routes: [
          GoRoute(
            path: Routes.setMainDlg,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                CupertinoModalPopupPage(
                  builder: (BuildContext context) =>
                      AddListDialog.init(context),
                ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.list,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final MainItem item =
                    GoRouterState.of(context).extra as MainItem;
                final double statusBarHeight = MediaQuery.of(
                  context,
                ).padding.top;
                return MoclListPage.init(context, item, statusBarHeight);
              },
            ),
      ),
      GoRoute(
        path: Routes.detail,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final ListItem item =
                    GoRouterState.of(context).extra as ListItem;
                final double statusBarHeight = MediaQuery.of(
                  context,
                ).padding.top;
                return DetailPage.init(context, item, statusBarHeight);
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
                ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.settings,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) => SettingsPage.init(context),
            ),
      ),
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
    ],
  );
}
