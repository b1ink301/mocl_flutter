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

class _AppFontSizes {
  static const double _baseTitleFontSize = 15.6;
  static const double _baseSmallFontSize = 14.0;
  static const double _baseBadgeFontSize = 11.0;

  static double _getFontSize(BuildContext context, double fontSize) =>
      MediaQuery.textScalerOf(context).scale(fontSize);

  // 시스템 textScaleFactor를 곱하여 실제 글꼴 크기를 계산하는 getter 추가
  static double getTitleFontSize(BuildContext context) =>
      _getFontSize(context, _baseTitleFontSize);

  static double getSmallFontSize(BuildContext context) =>
      _getFontSize(context, _baseSmallFontSize);

  static double getBadgeFontSize(BuildContext context) =>
      _getFontSize(context, _baseBadgeFontSize);
}

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle titleTextStyle;
  final TextStyle readTitleTextStyle;
  final TextStyle smallTextStyle;
  final TextStyle readSmallTextStyle;
  final TextStyle badgeTextStyle;
  final TextStyle readBadgeTextStyle;

  const AppTextStyles({
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
  }) => TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
  );

  @override
  ThemeExtension<AppTextStyles> copyWith({
    TextStyle? titleTextStyle,
    TextStyle? readTitleTextStyle,
    TextStyle? smallTextStyle,
    TextStyle? readSmallTextStyle,
    TextStyle? badgeTextStyle,
    TextStyle? readBadgeTextStyle,
  }) => AppTextStyles(
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    readTitleTextStyle: readTitleTextStyle ?? this.readTitleTextStyle,
    smallTextStyle: smallTextStyle ?? this.smallTextStyle,
    readSmallTextStyle: readSmallTextStyle ?? this.readSmallTextStyle,
    badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
    readBadgeTextStyle: readBadgeTextStyle ?? this.readBadgeTextStyle,
  );

  @override
  ThemeExtension<AppTextStyles> lerp(
    ThemeExtension<AppTextStyles>? other,
    double t,
  ) {
    if (other is! AppTextStyles) return this;
    return AppTextStyles(
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

  static AppTextStyles of(BuildContext context) =>
      Theme.of(context).extension<AppTextStyles>()!;

  static AppTextStyles light(BuildContext context) => AppTextStyles(
    titleTextStyle: _createTextStyle(
      color: MoclColors.title,
      fontSize: _AppFontSizes.getTitleFontSize(context),
    ),
    readTitleTextStyle: _createTextStyle(
      color: MoclColors.readTitle,
      fontSize: _AppFontSizes.getTitleFontSize(context),
    ),
    smallTextStyle: _createTextStyle(
      color: MoclColors.small,
      fontSize: _AppFontSizes.getSmallFontSize(context),
    ),
    readSmallTextStyle: _createTextStyle(
      color: MoclColors.readSmall,
      fontSize: _AppFontSizes.getSmallFontSize(context),
    ),
    badgeTextStyle: _createTextStyle(
      color: MoclColors.badge,
      fontSize: _AppFontSizes.getBadgeFontSize(context),
    ),
    readBadgeTextStyle: _createTextStyle(
      color: MoclColors.readBadge,
      fontSize: _AppFontSizes.getBadgeFontSize(context),
    ),
  );

  static AppTextStyles dark(BuildContext context) => AppTextStyles(
    titleTextStyle: _createTextStyle(
      color: MoclColors.darkTitle,
      fontSize: _AppFontSizes.getTitleFontSize(context),
    ),
    readTitleTextStyle: _createTextStyle(
      color: MoclColors.darkReadTitle,
      fontSize: _AppFontSizes.getTitleFontSize(
        context,
      ), // Fixed font size consistency
    ),
    smallTextStyle: _createTextStyle(
      color: MoclColors.darkSmall,
      fontSize: _AppFontSizes.getSmallFontSize(context),
    ),
    readSmallTextStyle: _createTextStyle(
      color: MoclColors.darkReadSmall,
      fontSize: _AppFontSizes.getSmallFontSize(context),
    ),
    badgeTextStyle: _createTextStyle(
      color: MoclColors.darkBadge,
      fontSize: _AppFontSizes.getBadgeFontSize(context),
    ),
    readBadgeTextStyle: _createTextStyle(
      color: MoclColors.darkReadBadge,
      fontSize: _AppFontSizes.getBadgeFontSize(context),
    ),
  );
}
