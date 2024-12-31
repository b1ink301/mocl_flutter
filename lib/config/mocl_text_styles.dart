import 'package:flutter/material.dart';

@immutable
class MoclTextStyles extends ThemeExtension<MoclTextStyles> {
  final TextStyle titleTextStyle;
  final TextStyle readTitleTextStyle;
  final TextStyle smallTextStyle;
  final TextStyle readSmallTextStyle;
  final TextStyle badgeTextStyle;
  final TextStyle readBadgeTextStyle;

  const MoclTextStyles({
    required this.titleTextStyle,
    required this.readTitleTextStyle,
    required this.smallTextStyle,
    required this.readSmallTextStyle,
    required this.badgeTextStyle,
    required this.readBadgeTextStyle,
  });

  @override
  ThemeExtension<MoclTextStyles> copyWith({
    TextStyle? titleTextStyle,
    TextStyle? readTitleTextStyle,
    TextStyle? smallTextStyle,
    TextStyle? readSmallTextStyle,
    TextStyle? badgeTextStyle,
    TextStyle? readBadgeTextStyle,
  }) =>
      MoclTextStyles(
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        readTitleTextStyle: readTitleTextStyle ?? this.readTitleTextStyle,
        smallTextStyle: smallTextStyle ?? this.smallTextStyle,
        readSmallTextStyle: readSmallTextStyle ?? this.readSmallTextStyle,
        badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
        readBadgeTextStyle: readBadgeTextStyle ?? this.readBadgeTextStyle,
      );

  @override
  ThemeExtension<MoclTextStyles> lerp(
    ThemeExtension<MoclTextStyles>? other,
    double t,
  ) {
    if (other is! MoclTextStyles) return this;
    return MoclTextStyles(
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t)!,
      readTitleTextStyle:
          TextStyle.lerp(readTitleTextStyle, other.readTitleTextStyle, t)!,
      smallTextStyle: TextStyle.lerp(smallTextStyle, other.smallTextStyle, t)!,
      readSmallTextStyle:
          TextStyle.lerp(readSmallTextStyle, other.readSmallTextStyle, t)!,
      badgeTextStyle: TextStyle.lerp(badgeTextStyle, other.badgeTextStyle, t)!,
      readBadgeTextStyle:
          TextStyle.lerp(readBadgeTextStyle, other.readBadgeTextStyle, t)!,
    );
  }

  TextStyle badge(bool isRead) => isRead ? readBadgeTextStyle : badgeTextStyle;
  TextStyle title(bool isRead) => isRead ? readTitleTextStyle : titleTextStyle;
  TextStyle smallTitle(bool isRead) => isRead ? readSmallTextStyle : smallTextStyle;

  static MoclTextStyles of(BuildContext context) =>
      Theme.of(context).extension<MoclTextStyles>()!;

  static MoclTextStyles light() => const MoclTextStyles(
        titleTextStyle: TextStyle(color: Color(0xFF111111), fontSize: 17),
        readTitleTextStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 17),
        smallTextStyle: TextStyle(color: Color(0xFF888888), fontSize: 14),
        readSmallTextStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        badgeTextStyle: TextStyle(color: Color(0xFF888888), fontSize: 11),
        readBadgeTextStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11),
      );

  static MoclTextStyles dark() => const MoclTextStyles(
        titleTextStyle: TextStyle(color: Color(0xFFEEEEEE), fontSize: 17),
        readTitleTextStyle: TextStyle(color: Color(0xFF888888), fontSize: 14),
        smallTextStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        readSmallTextStyle: TextStyle(color: Color(0xFF888888), fontSize: 14),
        badgeTextStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 11),
        readBadgeTextStyle: TextStyle(color: Color(0xFF888888), fontSize: 11),
      );
}
