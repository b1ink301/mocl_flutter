import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocl_flutter/features/mocl/presentation/mocl_theme.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/mocl_global_bindings.dart';

import 'features/mocl/data/datasources/mocl_local_database.dart';
import 'features/mocl/presentation/common/mocl_custom_scroll_behavior.dart';
import 'features/mocl/presentation/routes/mocl_app_pages.dart';

void main() async {
  await GetStorage.init();
  await Get.put(LocalDatabase(), permanent: true).init();
  runApp(const MoclApp());
}

class MoclApp extends StatelessWidget {
  const MoclApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        scrollBehavior: CustomScrollBehavior(),
        theme: MoclTheme.lightTheme,
        darkTheme: MoclTheme.darkTheme,
        defaultTransition: Transition.cupertino,
        binds: GlobalBindings().dependencies(),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      );
}
