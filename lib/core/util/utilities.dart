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
