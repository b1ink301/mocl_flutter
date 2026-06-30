import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

import 'config/routes/mocl_app_pages.dart';
import 'core/util/glyph_warmup_manager.dart';

class AppWidget extends HookConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = ref.watch(appTextStylesFontSizeProvider);
    final themeMode = ref.watch(themeModeProvider);

    useEffect(() {
      // 위젯이 처음 붙을 때 실행
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        GlyphWarmupManager.instance.init(textStyles);
      });

      // 위젯이 제거될 때 실행 (dispose 역할)
      return () => GlyphWarmupManager.instance.dispose();
    }, [textStyles]);

    return MaterialApp.router(
      themeMode: themeMode,
      theme: MoclTheme.lightTheme,
      darkTheme: MoclTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      scrollBehavior: CustomScrollBehavior(),
      routerConfig: AppPages.router,
      builder: (context, child) {
        final data = MediaQuery.of(context);
        final Brightness brightness = Theme.of(context).brightness;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(currentBrightnessProvider.notifier).update(brightness);
        });
        return MediaQuery(
          data: data.copyWith(
            // 여기서 textScaler를 조절하면 앱 전체의 기본 폰트 크기가 바뀝니다.
            // 시스템 설정은 무시하고 고정하고 싶을 때 주로 사용합니다.
            // textScaler: const TextScaler.linear(1.0),
            textScaler: data.textScaler.clamp(
              minScaleFactor: 0.5,
              maxScaleFactor: 3,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
