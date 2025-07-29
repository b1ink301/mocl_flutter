import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';

import 'common/mocl_custom_scroll_behavior.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    scrollBehavior: const CustomScrollBehavior(),
    theme: MoclTheme.lightTheme,
    darkTheme: MoclTheme.darkTheme,
    routerConfig: AppPages.router,
  );
}
