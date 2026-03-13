import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/presentation/widgets/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

import 'config/routes/mocl_app_pages.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => PlatformProvider(
    settings: PlatformSettingsData(
      iosUsesMaterialWidgets: true,
      iosUseZeroPaddingForAppbarPlatformIcon: true,
    ),
    builder: (context) => PlatformTheme(
      themeMode: ThemeMode.system,
      materialLightTheme: MoclTheme.lightTheme(context),
      materialDarkTheme: MoclTheme.darkTheme(context),
      cupertinoLightTheme: MoclTheme.lightCupertinoTheme(context),
      cupertinoDarkTheme: MoclTheme.dartCupertinoTheme(context),
      matchCupertinoSystemChromeBrightness: true,
      builder: (_) => PlatformApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        scrollBehavior: CustomScrollBehavior(),
        routerConfig: AppPages.router,
      ),
    ),
  );
}
