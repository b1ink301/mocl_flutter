import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoclTheme {
  static ThemeData get lightTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF595D66),
          foregroundColor: Colors.white,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Color(0xFF4d5057)),
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
        scaffoldBackgroundColor: const Color(0xFFEAEBE6),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFC9CAC5),
          space: 1,
          thickness: 1,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAAAAAA),
          foregroundColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF292929),
          space: 1,
          thickness: 1,
        ),
        scaffoldBackgroundColor: const Color(0xFFAAAAAA),
      );
}
