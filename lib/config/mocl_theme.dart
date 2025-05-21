import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

class MoclTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        extensions: [
          MoclTextStyles.light(),
        ],
        appBarTheme: const AppBarTheme(
          color: Color(0xFF595D66),
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
        // listTileTheme: ListTileThemeData(),
        highlightColor: const Color(0xFF0E7EA3),
        primaryColor: const Color(0xFF595D66),
        scaffoldBackgroundColor: const Color(0xFFEAEBE6),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFFEAEBE6),
          textStyle: TextStyle(color: Color(0xFF111111), fontSize: 17),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFC9CAC5),
          space: 1,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF111111), fontSize: 17),
          bodySmall: TextStyle(color: Color(0xFF888888), fontSize: 14),
          labelSmall: TextStyle(color: Color(0xFF888888), fontSize: 11),
          headlineSmall: TextStyle(color: Color(0xFF000000), fontSize: 15),
          headlineMedium: TextStyle(color: Color(0xFF111111), fontSize: 16),
          labelMedium: TextStyle(color: Colors.white, fontSize: 16),
          labelLarge: TextStyle(color: Colors.white, fontSize: 17),
        ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFFEAEBE6)),
        // pageTransitionsTheme: const PageTransitionsTheme(
        //   builders: {
        //     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //   },
        // ),
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        extensions: [
          MoclTextStyles.dark(),
        ],
        appBarTheme: const AppBarTheme(
          color: Color(0xFF292929),
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
        highlightColor: const Color(0xFFFF4081),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFEEEEEE), fontSize: 17),
          bodySmall: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
          labelSmall: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11),
          headlineSmall: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 16),
          labelMedium: TextStyle(color: Colors.white, fontSize: 16),
          labelLarge: TextStyle(color: Colors.white, fontSize: 17),
        ),
        primaryColor: const Color(0xFF292929),
        scaffoldBackgroundColor: const Color(0xFF333333),
        popupMenuTheme: PopupMenuThemeData(
          color: const Color(0xFF333333),
          textStyle: const TextStyle(color: Color(0xFFEEEEEE), fontSize: 17),
        ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF333333)),
        // pageTransitionsTheme: const PageTransitionsTheme(
        //   builders: {
        //     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //   },
        // ),
      );
}
