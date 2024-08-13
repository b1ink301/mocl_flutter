import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoclTheme {
  static ThemeData get lightTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF595D66),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF4d5057),
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        // colorScheme: const ColorScheme(
        //   brightness: Brightness.light,
        //   primary: Color(0xFF595D66),
        //   onPrimary: Color(0xFFEAEBE6),
        //   secondary: Color(0xFF4d5057),
        //   onSecondary: Color(0xFF888888),
        //   error: Color(0xFF595D66),
        //   onError: Color(0xFF595D66),
        //   surface: Color(0xFF595D66),
        //   onSurface: Color(0xFF595D66),
        // ),
        // listTileTheme: ListTileThemeData(),
        indicatorColor: const Color(0xFF0E7EA3),
        highlightColor: const Color(0xFFAAAAAA),
        primaryColor: const Color(0xFF595D66),
        scaffoldBackgroundColor: const Color(0xFFEAEBE6),
        dialogBackgroundColor: const Color(0xFFEAEBE6),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFC9CAC5),
          space: 1,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF111111), fontSize: 17),
          bodySmall: TextStyle(color: Color(0xFF888888), fontSize: 14),
          labelSmall: TextStyle(color: Color(0xFF888888), fontSize: 11),
          headlineSmall: TextStyle(color: Color(0xFF555555), fontSize: 16),
          labelMedium: TextStyle(color: Colors.white, fontSize: 16),
        ),
        // pageTransitionsTheme: const PageTransitionsTheme(
        //   builders: {
        //     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //   },
        // ),
      );

  static ThemeData get darkTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF292929),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF1f1f1f),
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF222222),
          space: 1,
          thickness: 1,
        ),
        indicatorColor: const Color(0xFFFF4081),
        highlightColor: const Color(0xFF888888),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFEEEEEE), fontSize: 17),
          bodySmall: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
          labelSmall: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11),
          headlineSmall: TextStyle(color: Color(0xFFAAAAAA), fontSize: 16),
          labelMedium: TextStyle(color: Colors.white, fontSize: 16),
        ),
        primaryColor: const Color(0xFF292929),
        scaffoldBackgroundColor: const Color(0xFF333333),
        dialogBackgroundColor: const Color(0xFF333333),
        // pageTransitionsTheme: const PageTransitionsTheme(
        //   builders: {
        //     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        //   },
        // ),
      );
}
