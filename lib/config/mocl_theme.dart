import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

class MoclTheme {
  static ThemeData lightTheme(BuildContext context) =>
      ThemeData.light().copyWith(
        extensions: [AppTextStyles.light(context)],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF595D66),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF4d5057),
            systemNavigationBarColor: Color(0xFFEAEBE6),
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
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
        // listTileTheme: ListTileThemeData(),
        focusColor: const Color(0xFF0E7EA3),
        highlightColor: const Color(0xFFAAAAAA),
        primaryColor: const Color(0xFF595D66),
        scaffoldBackgroundColor: const Color(0xFFEAEBE6),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFFEAEBE6),
          position: PopupMenuPosition.under,
          menuPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          textStyle: TextStyle(color: Color(0xFF111111), fontSize: 13),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(color: Color(0xFF111111), fontSize: 15),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFC9CAC5),
          space: 1,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF111111), fontSize: 16),
          bodySmall: TextStyle(color: Color(0xFF888888), fontSize: 14),
          headlineSmall: TextStyle(color: Color(0xFF000000), fontSize: 13),
          headlineMedium: TextStyle(color: Color(0xFF111111), fontSize: 16),
          labelSmall: TextStyle(color: Colors.white, fontSize: 11),
          labelMedium: TextStyle(color: Colors.white, fontSize: 14),
          labelLarge: TextStyle(color: Colors.white, fontSize: 17),
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData.dark().copyWith(
    extensions: [AppTextStyles.dark(context)],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF292929),
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1f1f1f),
        systemNavigationBarColor: Color(0xFF333333),
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF222222),
      space: 1,
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      },
    ),
    focusColor: const Color(0xFFFF4081),
    highlightColor: const Color(0xFF888888),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFFEEEEEE), fontSize: 16),
      bodySmall: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
      headlineSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 13),
      headlineMedium: TextStyle(color: Colors.white, fontSize: 16),
      labelSmall: TextStyle(color: Colors.white, fontSize: 11),
      labelMedium: TextStyle(color: Colors.white, fontSize: 14),
      labelLarge: TextStyle(color: Colors.white, fontSize: 17),
    ),
    primaryColor: const Color(0xFF292929),
    scaffoldBackgroundColor: const Color(0xFF333333),
    popupMenuTheme: const PopupMenuThemeData(
      color: Color(0xFF333333),
      textStyle: TextStyle(color: Color(0xFFEEEEEE), fontSize: 13),
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(color: Color(0xFFEEEEEE), fontSize: 15),
      ),
    ),
  );
}
