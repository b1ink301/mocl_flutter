import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view/list_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../pages/detail/mocl_detail_page.dart';
import '../pages/main/mocl_main_page.dart';
import '../pages/main/set_list_dialog.dart';
import '../widgets/dialog_page.dart';

part 'mocl_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.MAIN;

  static final router = GoRouter(
    initialLocation: initial,
    routes: <RouteBase>[
      GoRoute(
          path: Routes.MAIN,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return SwipeablePage(builder: (context) => const MainPage());
          },
          routes: [
            GoRoute(
              path: Routes.SET_MAIN_DLG,
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  CupertinoModalPopupPage(
                builder: (BuildContext context) => const SetListDialog(),
              ),
            ),
          ]),
      GoRoute(
        path: Routes.LIST,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(builder: (context) => const ListPage()),
      ),
      GoRoute(
        path: Routes.DETAIL,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(builder: (context) => const DetailPage()),
      )
    ],
  );
}
