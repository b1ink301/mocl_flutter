import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/bottom_sheet_page.dart';
import 'package:mocl_flutter/features/add_main_dialog/presentation/add_list_modal_sheet_page.dart';
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
    initialLocation: AppPages.initial,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.main,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final width = MediaQuery.sizeOf(context).width;
                return MainPage.init(width);
              },
            ),
        routes: [
          GoRoute(
            path: Routes.setMainDlg,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                ModalBottomSheetPage(
                  builder: (BuildContext context) => const AddListBottomSheet(),
                ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.list,
        // 딥링크/상태 복원 등으로 extra 가 없거나 타입이 다르면 메인으로 보낸다.
        redirect: (BuildContext context, GoRouterState state) =>
            state.extra is MainItem ? null : Routes.main,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final MainItem item =
                    GoRouterState.of(context).extra as MainItem;
                final width = MediaQuery.of(context).size.width;
                return MoclListPage.init(width, item);
              },
            ),
      ),
      GoRoute(
        path: Routes.detail,
        // 상세는 ListItem extra 로 진입한다. 단, 하위 이미지 뷰어
        // (viewPhotoDlg) 로 push 될 때는 extra 가 이미지 URL(String) 이라
        // 부모 가드가 이를 막아 메인으로 튕기던 문제가 있어 String 도 통과시킨다.
        // (딥링크/상태 복원 등 extra 가 없거나 타입이 다르면 메인으로 보낸다.)
        redirect: (BuildContext context, GoRouterState state) =>
            (state.extra is ListItem || state.extra is String)
            ? null
            : Routes.main,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final ListItem item =
                    GoRouterState.of(context).extra as ListItem;
                final width = MediaQuery.of(context).size.width;
                return DetailPage.init(width, item);
              },
            ),
        routes: [
          GoRoute(
            path: Routes.viewPhotoDlg,
            redirect: (BuildContext context, GoRouterState state) =>
                state.extra is String ? null : Routes.main,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                ModalBottomSheetPage(
                  builder: (BuildContext context) {
                    final url = GoRouterState.of(context).extra as String;
                    return PhotoViewDialog(
                      imageProvider: NetworkImage(url),
                      imageUrl: url,
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
