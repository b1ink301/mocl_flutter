import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/application/accent_provider.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

import 'config/routes/mocl_app_pages.dart';
import 'core/util/glyph_warmup_manager.dart';
import 'features/app_entry/presentation/widgets/app_entry_gate.dart';
import 'features/app_update/presentation/widgets/app_update_gate.dart';
import 'features/keyword_alerts/presentation/widgets/keyword_alert_gate.dart';
import 'features/media_player/presentation/media_player_host.dart';

class const AppWidget({super.key}) extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = ref.watch(appTextStylesFontSizeProvider);
    final themeMode = ref.watch(themeModeProvider);
    // 강조색(설정 "강조색"). 사이트 색 모드면 드로어에서 고른 사이트 색이다.
    final accent = ref.watch(appAccentProvider);
    // 사이트 색 모드에선 드로어로 사이트를 바꿀 때마다 테마가 바뀐다. 기본 보간(200ms)이면
    // 그동안 홈의 탭 넷이 매 프레임 다시 그려져(에뮬레이터 실측 build p90 3 → 10ms) 드로어
    // 닫힘이 끊긴다. 이 모드에서만 보간 없이 한 번에 바꾼다.
    final bool siteAccent = ref.watch(
      accentSettingProvider.select((s) => s.mode == AccentMode.site),
    );

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
      theme: MoclTheme.light(accent),
      darkTheme: MoclTheme.dark(accent),
      themeAnimationStyle: siteAccent ? AnimationStyle.noAnimation : null,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
          child: AppUpdateGate(
            navigatorKey: AppPages.router.routerDelegate.navigatorKey,
            child: KeywordAlertGate(
              router: AppPages.router,
              // 공유로 받은 링크 · 앱 바로가기.
              child: AppEntryGate(
                router: AppPages.router,
                // 동영상 플레이어는 라우터 위 한 층(게시판을 오가도 재생이 이어진다).
                child: MediaPlayerHost(
                  navigatorKey: AppPages.router.routerDelegate.navigatorKey,
                  child: child!,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
