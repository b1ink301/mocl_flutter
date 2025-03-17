import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/features/mocl/presentation/common/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PlatformProvider(
        settings: PlatformSettingsData(
          iosUsesMaterialWidgets: true,
          iosUseZeroPaddingForAppbarPlatformIcon: true,
        ),
        builder: (context) => PlatformTheme(
          themeMode: ThemeMode.system,
          materialLightTheme: MoclTheme.lightTheme,
          materialDarkTheme: MoclTheme.darkTheme,
          cupertinoLightTheme: MoclTheme.lightCupertinoTheme,
          cupertinoDarkTheme: MoclTheme.dartCupertinoTheme,
          matchCupertinoSystemChromeBrightness: true,
          builder: (context) => PlatformApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            scrollBehavior: CustomScrollBehavior(),
            routerConfig: ref.watch(appRouterProvider),
          ),
        ),
      );
}
