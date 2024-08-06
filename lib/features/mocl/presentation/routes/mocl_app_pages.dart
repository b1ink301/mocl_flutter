import 'package:get/get.dart';

import '../pages/detail/mocl_detail_bindings.dart';
import '../pages/detail/mocl_detail_page.dart';
import '../pages/list/mocl_list_bindings.dart';
import '../pages/list/mocl_list_page.dart';
import '../pages/main/bindings/mocl_main_bindings.dart';
import '../pages/main/views/mocl_main_page.dart';
import '../pages/mocl_global_bindings.dart';

part 'mocl_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.MAIN;
  static final routes = [
    GetPage(
      participatesInRootNavigator: true,
      preventDuplicates: true,
      name: Routes.MAIN,
      page: () => const MainPage(),
      bindings: [GlobalBindings(), MainBindings()],
    ),
    GetPage(
      name: Routes.LIST,
      page: () => const ListPage(),
      bindings: [GlobalBindings(), ListBindings()],
      popGesture: true,
      // customTransition: SwipeBackTransition(),
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => const DetailPage(),
      bindings: [GlobalBindings(), DetailBindings()],
      popGesture: true,
      // customTransition: SwipeBackTransition(),
    )
  ];
}
