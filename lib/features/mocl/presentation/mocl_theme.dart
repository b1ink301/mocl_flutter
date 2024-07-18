import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/util/utilities.dart';

class MoclTheme {
  static ThemeData get lightTheme => ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.lightBlue,
      foregroundColor: Colors.white,
    ),

    dividerColor: Colors.cyanAccent,
    scaffoldBackgroundColor: '#FFFFFF'.toColor(),
  );

  static ThemeData get darkTheme => ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
    ),
    dividerColor: Colors.cyanAccent,
    scaffoldBackgroundColor: Colors.white54,
  );
}