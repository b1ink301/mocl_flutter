import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

import 'native_ad_look.dart';

/// 글 상세의 카드형 네이티브 광고 모양. Android 팩토리는
/// `DetailNativeAdFactory.kt`(`detailCard`)이고, 여백 상수는 그쪽과 같아야 한다.
class DetailAdStyle._({
  required final Color background,
  required final Color mediaBackground,
  required final Color ctaBackground,
  required final TextStyle title,
  required final TextStyle small,
  required final TextStyle badge,
  required final TextStyle cta,
  required final double titleLineHeight,
  required final double smallLineHeight,
  required final double badgeLineHeight,
  required final double ctaLineHeight,
  required final double mediaHeight,
}) with Equatable implements NativeAdLook {
  /// [width] 는 광고가 들어갈 칸의 너비. 미디어는 16:9 로 맞춘다.
  factory from(AppTextStyles styles, ThemeData theme, double width) {
    final Color accent = theme.colorScheme.primary;
    final TextStyle cta = styles.smallTextStyle.copyWith(
      color: accent,
      fontWeight: FontWeight.w600,
    );
    return DetailAdStyle._(
      background: theme.scaffoldBackgroundColor,
      mediaBackground: theme.colorScheme.onSurface.withValues(alpha: 0.04),
      ctaBackground: accent.withValues(alpha: 0.12),
      title: styles.titleTextStyle.copyWith(fontWeight: FontWeight.w500),
      small: styles.smallTextStyle,
      badge: styles.badgeTextStyle,
      cta: cta,
      titleLineHeight: adLineHeight(styles.titleTextStyle),
      smallLineHeight: adLineHeight(styles.smallTextStyle),
      badgeLineHeight: adLineHeight(styles.badgeTextStyle),
      ctaLineHeight: adLineHeight(cta),
      // 미디어 칸은 최소 120dp 여야 한다(AdMob 권장).
      mediaHeight: (width * 9 / 16).clamp(120.0, 280.0).roundToDouble(),
    );
  }

  static const double _paddingVertical = 16;
  static const double _sectionGap = 10;
  static const double _iconSize = 20;
  static const double _ctaHeight = 32;
  static const double _badgePaddingVertical = 1.5;

  @override
  String get factoryId => 'detailCard';

  @override
  NativeAdOptions get nativeAdOptions => NativeAdOptions(
    adChoicesPlacement: AdChoicesPlacement.topRightCorner,
    mediaAspectRatio: MediaAspectRatio.landscape,
  );

  @override
  double get height {
    final double topRow = [
      titleLineHeight,
      _iconSize,
      badgeLineHeight + _badgePaddingVertical * 2,
    ].reduce((a, b) => a > b ? a : b);
    final double bottomRow = [
      smallLineHeight * 2,
      _ctaHeight,
    ].reduce((a, b) => a > b ? a : b);
    return _paddingVertical +
        topRow +
        _sectionGap +
        mediaHeight +
        _sectionGap +
        bottomRow +
        _paddingVertical;
  }

  @override
  Map<String, Object> toOptions() => {
    'background': background.toARGB32(),
    'mediaBackground': mediaBackground.toARGB32(),
    'mediaHeight': mediaHeight,
    ...adTextOptions('title', title, titleLineHeight),
    ...adTextOptions('small', small, smallLineHeight),
    ...adTextOptions('badge', badge, badgeLineHeight),
    'badgeBackground': (badge.color ?? MoclColors.accentLight)
        .withValues(alpha: 0.12)
        .toARGB32(),
    ...adTextOptions('cta', cta, ctaLineHeight),
    'ctaBackground': ctaBackground.toARGB32(),
  };

  @override
  List<Object?> get props => [
    background,
    mediaBackground,
    ctaBackground,
    title,
    small,
    badge,
    cta,
    mediaHeight,
  ];
}
