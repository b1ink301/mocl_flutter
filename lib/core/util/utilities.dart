import 'dart:ui';

extension ColorFromSring on String {
  Color toColor() {
    if (startsWith('#')) {
      return Color(
        int.parse(substring(1, 7), radix: 16) + 0xFF000000,
      );
    } else {
      return Color(
        int.parse(this, radix: 16) + 0xFF000000,
      );
    }
  }
}

extension ColorExtension on Color {
  String get stringHexColor {
    final String red = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String green = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String blue = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    // final alpha = (color.a * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#$red$green$blue'.toUpperCase();
  }
}
