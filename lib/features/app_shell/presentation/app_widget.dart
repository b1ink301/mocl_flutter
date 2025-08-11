import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/common/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/features/google_drive/presentation/providers/auto_sync_provider.dart';
import 'package:mocl_flutter/features/google_drive/presentation/providers/google_drive_providers.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  void _showRestoreDialog(BuildContext context, WidgetRef ref) =>
      showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: const Text('데이터 복원'),
          content: const Text('Google Drive에 새로운 데이터가 있습니다. 복원하시겠습니까?'),
          actions: <Widget>[
            PlatformDialogAction(
              child: PlatformText('아니요'),
              onPressed: () {
                ref.read(autoSyncNotifierProvider.notifier).resetState();
                context.pop();
              },
            ),
            PlatformDialogAction(
              child: PlatformText('예'),
              onPressed: () {
                ref.read(googleDriveSyncNotifierProvider.notifier).restore();
                ref.read(autoSyncNotifierProvider.notifier).resetState();
                context.pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // ref.listen<SyncAction>(autoSyncNotifierProvider, (previous, next) {
    //   if (next == SyncAction.promptRestore) {
    //     final routerContext = router.routerDelegate.navigatorKey.currentContext;
    //     if (routerContext != null) {
    //       _showRestoreDialog(routerContext, ref);
    //     }
    //   }
    // });

    return PlatformProvider(
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: true,
        iosUseZeroPaddingForAppbarPlatformIcon: true,
      ),
      builder: (_) => PlatformTheme(
        themeMode: ThemeMode.system,
        materialLightTheme: MoclTheme.lightTheme,
        materialDarkTheme: MoclTheme.darkTheme,
        cupertinoLightTheme: MoclTheme.lightCupertinoTheme,
        cupertinoDarkTheme: MoclTheme.dartCupertinoTheme,
        matchCupertinoSystemChromeBrightness: true,
        builder: (_) => PlatformApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          scrollBehavior: CustomScrollBehavior(),
          routerConfig: router,
        ),
      ),
    );
  }
}
