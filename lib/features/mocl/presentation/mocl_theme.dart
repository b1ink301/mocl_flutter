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
        // listTileTheme: ListTileThemeData(),
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
          bodySmall: TextStyle(color: Color(0xFF555555), fontSize: 15),
          labelSmall: TextStyle(color: Color(0xFF888888), fontSize: 10),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF292929),
          foregroundColor: Colors.white,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Color(0xFF1f1f1f)),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF292929),
          space: 1,
          thickness: 1,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFAAAAAA), fontSize: 17),
          bodySmall: TextStyle(color: Color(0xFF888888), fontSize: 15),
          labelSmall: TextStyle(color: Color(0xFF666666), fontSize: 11),
        ),
        primaryColor: const Color(0xFF292929),
        scaffoldBackgroundColor: const Color(0xFF333333),
        dialogBackgroundColor: const Color(0xFF333333),
      );
}
