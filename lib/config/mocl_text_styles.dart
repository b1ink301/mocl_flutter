import 'package:flutter/material.dart';

class MoclColors {
  static const Color title = Color(0xFF111111);
  static const Color readTitle = Color(0xFFAAAAAA);
  static const Color small = Color(0xFF888888);
  static const Color readSmall = Color(0xFFAAAAAA);
  static const Color badge = Color(0xFF888888);
  static const Color readBadge = Color(0xFFAAAAAA);

  // Dark theme colors
  static const Color darkTitle = Color(0xFFEEEEEE);
  static const Color darkReadTitle = Color(0xFF888888);
  static const Color darkSmall = Color(0xFFAAAAAA);
  static const Color darkReadSmall = Color(0xFF888888);
  static const Color darkBadge = Color(0xFFAAAAAA);
  static const Color darkReadBadge = Color(0xFF888888);
}

class MoclSizes {
  static const double titleFontSize = 16.4;
  static const double smallFontSize = 14.0;
  static const double badgeFontSize = 11.0;
}

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

  static TextStyle _createTextStyle({
    required Color color,
    required double fontSize,
    FontWeight? fontWeight,
    double? height,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  @override
  ThemeExtension<MoclTextStyles> copyWith({
    TextStyle? titleTextStyle,
    TextStyle? readTitleTextStyle,
    TextStyle? smallTextStyle,
    TextStyle? readSmallTextStyle,
    TextStyle? badgeTextStyle,
    TextStyle? readBadgeTextStyle,
  }) => MoclTextStyles(
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
      readTitleTextStyle: TextStyle.lerp(
        readTitleTextStyle,
        other.readTitleTextStyle,
        t,
      )!,
      smallTextStyle: TextStyle.lerp(smallTextStyle, other.smallTextStyle, t)!,
      readSmallTextStyle: TextStyle.lerp(
        readSmallTextStyle,
        other.readSmallTextStyle,
        t,
      )!,
      badgeTextStyle: TextStyle.lerp(badgeTextStyle, other.badgeTextStyle, t)!,
      readBadgeTextStyle: TextStyle.lerp(
        readBadgeTextStyle,
        other.readBadgeTextStyle,
        t,
      )!,
    );
  }

  TextStyle badge(bool isRead) => isRead ? readBadgeTextStyle : badgeTextStyle;

  TextStyle title(bool isRead) => isRead ? readTitleTextStyle : titleTextStyle;

  TextStyle smallTitle(bool isRead) =>
      isRead ? readSmallTextStyle : smallTextStyle;

  static MoclTextStyles of(BuildContext context) =>
      Theme.of(context).extension<MoclTextStyles>()!;

  static MoclTextStyles light() => MoclTextStyles(
    titleTextStyle: _createTextStyle(
      color: MoclColors.title,
      fontSize: MoclSizes.titleFontSize,
    ),
    readTitleTextStyle: _createTextStyle(
      color: MoclColors.readTitle,
      fontSize: MoclSizes.titleFontSize,
    ),
    smallTextStyle: _createTextStyle(
      color: MoclColors.small,
      fontSize: MoclSizes.smallFontSize,
    ),
    readSmallTextStyle: _createTextStyle(
      color: MoclColors.readSmall,
      fontSize: MoclSizes.smallFontSize,
    ),
    badgeTextStyle: _createTextStyle(
      color: MoclColors.badge,
      fontSize: MoclSizes.badgeFontSize,
    ),
    readBadgeTextStyle: _createTextStyle(
      color: MoclColors.readBadge,
      fontSize: MoclSizes.badgeFontSize,
    ),
  );

  static MoclTextStyles dark() => MoclTextStyles(
    titleTextStyle: _createTextStyle(
      color: MoclColors.darkTitle,
      fontSize: MoclSizes.titleFontSize,
    ),
    readTitleTextStyle: _createTextStyle(
      color: MoclColors.darkReadTitle,
      fontSize: MoclSizes.titleFontSize, // Fixed font size consistency
    ),
    smallTextStyle: _createTextStyle(
      color: MoclColors.darkSmall,
      fontSize: MoclSizes.smallFontSize,
    ),
    readSmallTextStyle: _createTextStyle(
      color: MoclColors.darkReadSmall,
      fontSize: MoclSizes.smallFontSize,
    ),
    badgeTextStyle: _createTextStyle(
      color: MoclColors.darkBadge,
      fontSize: MoclSizes.badgeFontSize,
    ),
    readBadgeTextStyle: _createTextStyle(
      color: MoclColors.darkReadBadge,
      fontSize: MoclSizes.badgeFontSize,
    ),
  );
}
