import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/src/generated/i18n/app_localizations.dart';

import 'config/routes/mocl_app_pages.dart';

class AppWidget extends HookConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = ref.watch(appTextStylesFontSizeProvider);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        warmupKoreanGlyphs(context, textStyles);
      });
      return;
    }, []);

    return MaterialApp.router(
      themeMode: ThemeMode.system,
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

/// 자주 쓰이는 한글/라틴 글리프를 미리 렌더링해 GPU glyph atlas 를 예열한다.
/// 스크롤 중 새 글자 등장 시 발생하는 `CreateGlyphAtlas` 스파이크를 줄인다.
///
/// 11k+ 음절을 한 번에 layout 하면 height 가 거대해져 메모리/시간 비용이 크므로,
/// 청크 단위로 잘라서 처리하고 매 청크 사이에 yield 한다.
Future<void> warmupKoreanGlyphs(
  BuildContext context,
  AppTextStyles textStyles,
) async {
  if (!context.mounted) return;

  // 현대 한글 음절 전체 (가~힣)
  final buf = StringBuffer();
  for (int code = 0xAC00; code <= 0xD7A3; code++) {
    buf.writeCharCode(code);
  }
  // 자주 쓰이는 라틴 + 숫자 + 기호
  buf.write(
    ' 0123456789abcdefghijklmnopqrstuvwxyz'
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ.,!?·"\'()[]{}-_/',
  );
  final text = buf.toString();

  final styles = <TextStyle>[
    // 실제 앱에서 사용하는 스타일과 동일하게
    textStyles.titleTextStyle,
    textStyles.smallTextStyle,
    textStyles.badgeTextStyle,
  ];

  const int chunkSize = 200; // 청크당 문자 수 (작을수록 한 번에 점유하는 UI 시간 짧음)
  const double maxWidth = 4096; // layout 최대 너비

  for (final style in styles) {
    for (int start = 0; start < text.length; start += chunkSize) {
      final end = (start + chunkSize) > text.length
          ? text.length
          : (start + chunkSize);
      final chunk = text.substring(start, end);

      // idle 우선순위로 예약 → 사용자 인터랙션/스크롤/애니메이션 중에는 대기.
      // 한 청크의 layout/paint 가 끝나야 다음이 시작되며, 그 사이 프레임 워크가
      // 더 중요한 작업을 처리할 수 있다.
      await SchedulerBinding.instance.scheduleTask<void>(() async {
        final tp = TextPainter(
          text: TextSpan(text: chunk, style: style),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: maxWidth);

        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);
        tp.paint(canvas, Offset.zero);
        final picture = recorder.endRecording();

        // 실제 텍스트 영역에 맞춰 rasterize 해야 glyph 가 atlas 에 업로드됨.
        // 1x1 로 하면 Impeller 가 화면 밖 draw 를 컬링해 워밍업 효과가 사라진다.
        final int w = tp.width.ceil().clamp(1, 4096);
        final int h = tp.height.ceil().clamp(1, 4096);
        final image = await picture.toImage(w, h);
        image.dispose();
        picture.dispose();
        tp.dispose();
      }, Priority.idle);
    }
  }
}
