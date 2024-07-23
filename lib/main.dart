import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocl_flutter/features/mocl/presentation/mocl_theme.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_bindings.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_bindings.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/mocl_routes.dart';

import 'features/mocl/presentation/mocl_swipe_back_transition.dart';
import 'features/mocl/presentation/pages/home/mocl_home_bindings.dart';
import 'features/mocl/presentation/pages/home/mocl_home_page.dart';
import 'features/mocl/presentation/pages/list/mocl_list_bindings.dart';
import 'features/mocl/presentation/pages/list/mocl_list_page.dart';
import 'features/mocl/presentation/pages/main/mocl_main_page.dart';
import 'features/mocl/presentation/pages/mocl_global_bindings.dart';

void main() async {
  await GetStorage.init();
  runApp(const MoclApp());
}

class MoclApp extends StatelessWidget {
  const MoclApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        theme: MoclTheme.lightTheme,
        darkTheme: MoclTheme.darkTheme,
        defaultTransition: Transition.cupertino,
        initialRoute: Routes.MAIN,
        initialBinding: GlobalBindings(),
        getPages: [
          GetPage(
            name: Routes.HOME,
            page: () => const HomePage(),
            binding: HomeBindings(),
          ),
          GetPage(
            name: Routes.MAIN,
            page: () => const MainPage(),
            binding: MainBindings(),
          ),
          GetPage(
            name: Routes.LIST,
            page: () => const ListPage(),
            binding: ListBindings(),
            popGesture: true,
            customTransition: SwipeBackTransition(),
          ),
          GetPage(
            name: Routes.DETAIL,
            page: () => const DetailPage(),
            binding: DetailBindings(),
            popGesture: true,
            customTransition: SwipeBackTransition(),
          )
        ],
      );
}
