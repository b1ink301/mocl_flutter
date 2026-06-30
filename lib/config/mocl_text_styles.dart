import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// 앱 내에서 사용되는 시맨틱 컬러 정의
class MoclColors {
  // Light Theme Colors
  static const Color title = Color(0xFF111111);
  static const Color readTitle = Color(0xFFAAAAAA);
  static const Color small = Color(0xFF888888);
  static const Color readSmall = Color(0xFFAAAAAA);
  static const Color badge = Color(0xFF888888);
  static const Color readBadge = Color(0xFFAAAAAA);

  // Dark Theme Colors
  static const Color darkTitle = Color(0xFFEEEEEE);
  static const Color darkReadTitle = Color(0xFF888888);
  static const Color darkSmall = Color(0xFFAAAAAA);
  static const Color darkReadSmall = Color(0xFF888888);
  static const Color darkBadge = Color(0xFFAAAAAA);
  static const Color darkReadBadge = Color(0xFF888888);
}

/// 기본 폰트 사이즈 정의
/// Flutter의 Text 위젯이 시스템 폰트 설정을 자동으로 반영하므로 기준값만 정의합니다.
class _AppFontSizes {
  static const double title = 15.6;
  static const double small = 13.2;
  static const double badge = 11.0;
}

class AppTextStyles extends ThemeExtension<AppTextStyles> with EquatableMixin {
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

  /// 모든 텍스트 스타일의 크기를 비율로 조절한다.
  AppTextStyles scaled(double factor) {
    if (factor == 1.0) return this;
    return AppTextStyles(
      titleTextStyle: _scale(titleTextStyle, factor),
      readTitleTextStyle: _scale(readTitleTextStyle, factor),
      smallTextStyle: _scale(smallTextStyle, factor),
      readSmallTextStyle: _scale(readSmallTextStyle, factor),
      badgeTextStyle: _scale(badgeTextStyle, factor),
      readBadgeTextStyle: _scale(readBadgeTextStyle, factor),
    );
  }

  static TextStyle _scale(TextStyle style, double factor) =>
      style.copyWith(fontSize: (style.fontSize ?? 14.0) * factor);

  /// Light Theme 인스턴스
  static final AppTextStyles light = AppTextStyles(
    titleTextStyle: _create(MoclColors.title, _AppFontSizes.title),
    readTitleTextStyle: _create(MoclColors.readTitle, _AppFontSizes.title),
    smallTextStyle: _create(MoclColors.small, _AppFontSizes.small),
    readSmallTextStyle: _create(MoclColors.readSmall, _AppFontSizes.small),
    badgeTextStyle: _create(MoclColors.badge, _AppFontSizes.badge),
    readBadgeTextStyle: _create(MoclColors.readBadge, _AppFontSizes.badge),
  );

  /// Dark Theme 인스턴스
  static final AppTextStyles dark = AppTextStyles(
    titleTextStyle: _create(MoclColors.darkTitle, _AppFontSizes.title),
    readTitleTextStyle: _create(MoclColors.darkReadTitle, _AppFontSizes.title),
    smallTextStyle: _create(MoclColors.darkSmall, _AppFontSizes.small),
    readSmallTextStyle: _create(MoclColors.darkReadSmall, _AppFontSizes.small),
    badgeTextStyle: _create(MoclColors.darkBadge, _AppFontSizes.badge),
    readBadgeTextStyle: _create(MoclColors.darkReadBadge, _AppFontSizes.badge),
  );

  static TextStyle _create(Color color, double fontSize) =>
      TextStyle(color: color, fontSize: fontSize);

  @override
  AppTextStyles copyWith({
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
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
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

  // Convenience methods for conditional styles
  TextStyle title(bool isRead) => isRead ? readTitleTextStyle : titleTextStyle;
  TextStyle smallTitle(bool isRead) =>
      isRead ? readSmallTextStyle : smallTextStyle;
  TextStyle badge(bool isRead) => isRead ? readBadgeTextStyle : badgeTextStyle;

  static AppTextStyles _of(BuildContext context) =>
      Theme.of(context).extension<AppTextStyles>() ?? light;

  @override
  List<Object?> get props => [
    titleTextStyle,
    readTitleTextStyle,
    smallTextStyle,
    readSmallTextStyle,
    badgeTextStyle,
    readBadgeTextStyle,
  ];
}

/// BuildContext를 통한 편리한 접근을 위한 Extension
extension AppTextStylesContextExtension on BuildContext {
  AppTextStyles get textStyles => AppTextStyles._of(this);
}
