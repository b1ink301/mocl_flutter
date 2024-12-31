import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/presentation/common/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      theme: MoclTheme.lightTheme,
      darkTheme: MoclTheme.darkTheme,
      routerConfig: AppPages.router,
    );
}
