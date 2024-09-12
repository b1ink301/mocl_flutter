import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/set_list_dialog.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dialog_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

part 'mocl_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.MAIN;

  static final router = GoRouter(
    initialLocation: initial,
    routes: <RouteBase>[
      GoRoute(
          path: Routes.MAIN,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              SwipeablePage(builder: (context) => MainPage.withBloc(context)),
          routes: [
            GoRoute(
              path: Routes.SET_MAIN_DLG,
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  CupertinoModalPopupPage(
                builder: (BuildContext context) {
                  final siteType = GoRouterState.of(context).extra as SiteType;
                  return SetListDialog.withBloc(context, siteType);
                },
              ),
            ),
          ]),
      GoRoute(
        path: Routes.LIST,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(builder: (context) {
          final item = GoRouterState.of(context).extra as MainItem;
          return ListPage.withBloc(context, item);
        }),
      ),
      GoRoute(
        path: Routes.DETAIL,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
          builder: (context) {
            final extra = GoRouterState.of(context).extra as List<dynamic>;
            final siteType = extra[0] as SiteType;
            final item = extra[1] as ReadableListItem;
            return DetailPage.withBloc(context, siteType, item);
          },
        ),
      )
    ],
  );
}
