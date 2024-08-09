import 'dart:io';

import 'package:get/get.dart';

import '../pages/detail/bindings/mocl_detail_bindings.dart';
import '../pages/detail/views/mocl_detail_page.dart';
import '../pages/list/bindings/mocl_list_bindings.dart';
import '../pages/list/views/mocl_list_page.dart';
import '../pages/main/bindings/mocl_main_bindings.dart';
import '../pages/main/views/mocl_main_page.dart';

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
      bindings: [MainBindings()],
    ),
    GetPage(
      name: Routes.LIST,
      page: () => const ListPage(),
      bindings: [ListBindings()],
      popGesture: !Platform.isMacOS,
      gestureWidth: (context) => context.width * 0.5,
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => const DetailPage(),
      bindings: [DetailBindings()],
      popGesture: !Platform.isMacOS,
      gestureWidth: (context) => context.width * 0.5,
    )
  ];
}
