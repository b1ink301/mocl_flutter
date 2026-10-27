import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/bottom_sheet_page.dart';
import 'package:mocl_flutter/features/add_main_dialog/presentation/add_list_modal_sheet_page.dart';
import 'package:mocl_flutter/features/bookmark/presentation/bookmarks_page.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/mute/presentation/mute_page.dart';
import 'package:mocl_flutter/features/detail_page/presentation/photo_view_dialog.dart';
import 'package:mocl_flutter/features/detail_page/presentation/video_player_page.dart';
import 'package:mocl_flutter/features/list_page/presentation/mocl_list_page.dart';
import 'package:mocl_flutter/features/login_page/presentation/login_page.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_page.dart';
import 'package:mocl_flutter/features/settings_page/presentation/pages/settings/settings_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

part 'mocl_routes.dart';

class AppPages._() {
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
        // redirect: (BuildContext context, GoRouterState state) =>
        //     state.extra is MainItem ? null : Routes.main,
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
        // (viewPhotoDlg) 로 push 될 때는 extra 가 갤러리 인자(GalleryArgs) 또는
        // 단일 이미지 URL(String) 이라, 부모 가드가 이를 막아 메인으로 튕기던
        // 문제가 있어 두 타입도 통과시킨다. (메인으로 튕기면 이미 스택에 있는
        // MainPage 가 재생성되어 mainScaffoldState 의 GlobalKey 가 중복된다.)
        // (딥링크/상태 복원 등 extra 가 없거나 타입이 다르면 메인으로 보낸다.)
        // redirect: (BuildContext context, GoRouterState state) =>
        //     (state.extra is ListItem ||
        //         state.extra is String ||
        //         state.extra is GalleryArgs)
        //     ? null
        //     : Routes.main,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) {
                final width = MediaQuery.of(context).size.width;
                final Object? extra = GoRouterState.of(context).extra;
                // 본문 링크로 들어오면 사이트가 함께 온다(다른 사이트 글일 수 있음).
                if (extra is SiteLink) {
                  return DetailPage.init(
                    width,
                    extra.item,
                    siteType: extra.siteType,
                  );
                }
                return DetailPage.init(width, extra as ListItem);
              },
            ),
        routes: [
          GoRoute(
            path: Routes.viewPhotoDlg,
            // redirect: (BuildContext context, GoRouterState state) =>
            //     (state.extra is String || state.extra is GalleryArgs)
            //     ? null
            //     : Routes.main,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                ModalBottomSheetPage(
                  builder: (BuildContext context) {
                    final extra = GoRouterState.of(context).extra;
                    // 갤러리(여러 장) 진입과 단일 URL(레거시/딥링크) 진입을 모두 지원.
                    if (extra is GalleryArgs) {
                      return PhotoViewDialog(
                        imageUrls: extra.urls,
                        initialIndex: extra.index,
                        referer: extra.referer,
                      );
                    }
                    return PhotoViewDialog(imageUrls: [extra as String]);
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
        path: Routes.bookmarks,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(
              builder: (BuildContext context) => const BookmarksPage(),
            ),
      ),
      GoRoute(
        path: Routes.mute,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            SwipeablePage(builder: (BuildContext context) => const MutePage()),
      ),
      GoRoute(
        path: Routes.video,
        // 탐색 막대를 좌우로 끄는 동작과 겹치지 않게 스와이프 뒤로가기는 쓰지 않는다.
        builder: (BuildContext context, GoRouterState state) =>
            VideoPlayerPage(args: state.extra as VideoPlayerArgs),
      ),
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
    ],
  );
}
