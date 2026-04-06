import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/presentation/widgets/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

import 'config/routes/mocl_app_pages.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    themeMode: ThemeMode.system,
    theme: MoclTheme.lightTheme(context),
    darkTheme: MoclTheme.darkTheme(context),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    scrollBehavior: CustomScrollBehavior(),
    routerConfig: AppPages.router,
  );
}
