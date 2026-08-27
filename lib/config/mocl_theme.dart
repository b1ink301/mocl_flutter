import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

/// "Paper" 디자인 테마.
///
/// 웜 뉴트럴(종이) 배경 + 단일 코랄 강조 + 밝은 앱바(잉크 텍스트).
/// 경계는 굵은 선이 아니라 헤어라인(1px)과 여백으로 표현한다.
class MoclTheme() {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    extensions: [AppTextStyles.light],
    appBarTheme: const AppBarTheme(
      backgroundColor: MoclColors.bgLight,
      foregroundColor: MoclColors.inkLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black,
      scrolledUnderElevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: MoclColors.bgLight,
        systemNavigationBarColor: MoclColors.bgLight,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
    focusColor: MoclColors.accentLight,
    highlightColor: MoclColors.faintLight,
    primaryColor: MoclColors.accentLight,
    scaffoldBackgroundColor: MoclColors.bgLight,
    canvasColor: MoclColors.bgLight,
    popupMenuTheme: const PopupMenuThemeData(
      color: MoclColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      textStyle: TextStyle(color: MoclColors.inkLight, fontSize: 13),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: MoclColors.inkLight, fontSize: 15),
      ),
    ),
    dividerColor: MoclColors.lineLight,
    dividerTheme: const DividerThemeData(
      color: MoclColors.lineLight,
      space: 1,
      thickness: 1,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: MoclColors.inkLight, fontSize: 16),
      bodySmall: TextStyle(color: MoclColors.subLight, fontSize: 14),
      headlineSmall: TextStyle(color: MoclColors.inkLight, fontSize: 13),
      headlineMedium: TextStyle(color: MoclColors.inkLight, fontSize: 16),
      // 앱바 크럼브(작은 제목)는 코랄 강조 라벨로 쓴다.
      labelSmall: TextStyle(
        color: MoclColors.accentLight,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      // 검색창 힌트/입력 텍스트.
      labelMedium: TextStyle(color: MoclColors.subLight, fontSize: 14),
      labelLarge: TextStyle(color: MoclColors.inkLight, fontSize: 17),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    extensions: [AppTextStyles.dark],
    appBarTheme: const AppBarTheme(
      backgroundColor: MoclColors.bgDark,
      foregroundColor: MoclColors.inkDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.black,
      scrolledUnderElevation: 1,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: MoclColors.bgDark,
        systemNavigationBarColor: MoclColors.bgDark,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
    ),
    dividerColor: MoclColors.lineDark,
    dividerTheme: const DividerThemeData(
      color: MoclColors.lineDark,
      space: 1,
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
    focusColor: MoclColors.accentDark,
    highlightColor: MoclColors.faintDark,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: MoclColors.inkDark, fontSize: 16),
      bodySmall: TextStyle(color: MoclColors.subDark, fontSize: 14),
      headlineSmall: TextStyle(color: MoclColors.inkDark, fontSize: 13),
      headlineMedium: TextStyle(color: MoclColors.inkDark, fontSize: 16),
      labelSmall: TextStyle(
        color: MoclColors.accentDark,
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      labelMedium: TextStyle(color: MoclColors.subDark, fontSize: 14),
      labelLarge: TextStyle(color: MoclColors.inkDark, fontSize: 17),
    ),
    primaryColor: MoclColors.accentDark,
    scaffoldBackgroundColor: MoclColors.bgDark,
    canvasColor: MoclColors.bgDark,
    popupMenuTheme: const PopupMenuThemeData(
      color: MoclColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      textStyle: TextStyle(color: MoclColors.inkDark, fontSize: 13),
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: MoclColors.inkDark, fontSize: 15),
      ),
    ),
  );
}
