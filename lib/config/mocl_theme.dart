import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:mocl_flutter/config/accent_palette.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

/// "Paper" 디자인 테마.
///
/// 웜 뉴트럴(종이) 배경 + 단일 강조색(기본 코랄, 설정 "강조색" 으로 바꿈) + 밝은 앱바(잉크 텍스트).
/// 경계는 굵은 선이 아니라 헤어라인(1px)과 여백으로 표현한다.
///
/// Material 3 컴포넌트는 색을 [ColorScheme] 역할에서 읽으므로, Paper 토큰을
/// 스킴 역할에 그대로 박아 기본 시드(보라)가 새어 나오지 않게 한다.
/// 강조는 [ColorScheme.primary], 보조 텍스트는 [ColorScheme.onSurfaceVariant].
class MoclTheme() {
  /// 기본(코랄) 테마.
  static final ThemeData lightTheme = light(AccentPalette.coral);
  static final ThemeData darkTheme = dark(AccentPalette.coral);

  static final Map<AccentColors, ThemeData> _lightCache = {};
  static final Map<AccentColors, ThemeData> _darkCache = {};

  /// [accent] 로 강조색만 바꾼 라이트 테마. 배경 · 글자 · 구분선은 그대로다.
  /// 같은 색이면 같은 인스턴스를 돌려준다(사이트를 오갈 때 다시 만들지 않는다).
  static ThemeData light(AccentColors accent) => _lightCache[accent] ??= _build(
    brightness: Brightness.light,
    colorScheme:
        ColorScheme.fromSeed(
          // 시드도 강조색으로 — secondary · tertiary 등 다른 역할에 코랄이 남지 않게.
          seedColor: accent.light,
          brightness: Brightness.light,
        ).copyWith(
          primary: accent.light,
          onPrimary: Colors.white,
          primaryContainer: accent.lightWeak,
          onPrimaryContainer: accent.light,
          surface: MoclColors.bgLight,
          onSurface: MoclColors.inkLight,
          onSurfaceVariant: MoclColors.subLight,
          surfaceContainerLowest: MoclColors.surfaceLight,
          surfaceContainerLow: MoclColors.surfaceLight,
          surfaceContainer: MoclColors.surfaceLight,
          outline: MoclColors.faintLight,
          outlineVariant: MoclColors.lineLight,
          surfaceTint: Colors.transparent,
        ),
    textStyles: AppTextStyles.light,
    ink: MoclColors.inkLight,
    sub: MoclColors.subLight,
    faint: MoclColors.faintLight,
    popupColor: MoclColors.surfaceLight,
  );

  static ThemeData dark(AccentColors accent) => _darkCache[accent] ??= _build(
    brightness: Brightness.dark,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: accent.dark,
          brightness: Brightness.dark,
        ).copyWith(
          primary: accent.dark,
          onPrimary: MoclColors.bgDark,
          primaryContainer: accent.darkWeak,
          onPrimaryContainer: accent.dark,
          surface: MoclColors.bgDark,
          onSurface: MoclColors.inkDark,
          onSurfaceVariant: MoclColors.subDark,
          surfaceContainerLowest: MoclColors.surfaceDark,
          surfaceContainerLow: MoclColors.surfaceDark,
          surfaceContainer: MoclColors.surfaceDark,
          outline: MoclColors.faintDark,
          outlineVariant: MoclColors.lineDark,
          surfaceTint: Colors.transparent,
        ),
    textStyles: AppTextStyles.dark,
    ink: MoclColors.inkDark,
    sub: MoclColors.subDark,
    faint: MoclColors.faintDark,
    popupColor: MoclColors.surfaceDark,
  );

  /// 밝기에 맞는 테마([SiteAccentTheme] 처럼 화면 일부만 다른 강조색으로 덮을 때).
  static ThemeData of(Brightness brightness, AccentColors accent) =>
      brightness == Brightness.dark ? dark(accent) : light(accent);

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppTextStyles textStyles,
    required Color ink,
    required Color sub,
    required Color faint,
    required Color popupColor,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final Color bg = colorScheme.surface;
    final Color accent = colorScheme.primary;
    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: kAppFontFamily,
      extensions: [textStyles],
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: bg,
          systemNavigationBarColor: bg,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: brightness,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
      highlightColor: faint,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      popupMenuTheme: PopupMenuThemeData(
        color: popupColor,
        surfaceTintColor: Colors.transparent,
        position: PopupMenuPosition.under,
        menuPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        textStyle: TextStyle(color: ink, fontSize: 13),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: ink, fontSize: 15),
        ),
      ),
      dividerColor: colorScheme.outlineVariant,
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: ink, fontSize: 16),
        bodySmall: TextStyle(color: sub, fontSize: 14),
        headlineSmall: TextStyle(color: ink, fontSize: 13),
        headlineMedium: TextStyle(color: ink, fontSize: 16),
        // 앱바 크럼브(작은 제목)는 코랄 강조 라벨로 쓴다.
        labelSmall: TextStyle(
          color: accent,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        titleLarge: TextStyle(color: ink, fontSize: 18),
        titleMedium: TextStyle(color: ink, fontSize: 16),
        titleSmall: TextStyle(color: ink, fontSize: 14),
        // 검색창 힌트/입력 텍스트.
        labelMedium: TextStyle(color: sub, fontSize: 14),
        labelLarge: TextStyle(color: ink, fontSize: 17),
      ),
    );
  }
}
