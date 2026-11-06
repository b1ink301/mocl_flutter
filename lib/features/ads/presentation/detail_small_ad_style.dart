import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

import 'native_ad_look.dart';

/// 글 상세의 작은 네이티브 광고 모양(small).
///
/// 왼쪽에 정사각 미디어(120dp), 오른쪽에 제목 두 줄 · 설명 한 줄 · ("광고" 배지 · 행동 버튼).
/// Android 팩토리는 `DetailSmallNativeAdFactory.kt`(`detailSmall`)이고,
/// 여백 상수는 그쪽과 같아야 한다.
class DetailSmallAdStyle._({
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
}) with Equatable implements NativeAdLook {
  factory from(AppTextStyles styles, ThemeData theme) {
    final Color accent = theme.colorScheme.primary;
    final TextStyle cta = styles.smallTextStyle.copyWith(
      color: accent,
      fontWeight: FontWeight.w600,
    );
    return DetailSmallAdStyle._(
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
    );
  }

  static const double _paddingVertical = 12;

  /// 미디어 칸은 최소 120dp 여야 한다(AdMob 권장).
  static const double _mediaSize = 120;
  static const double _mediaGap = 12;
  static const double _textGap = 4;
  static const double _bottomGap = 8;
  static const double _ctaHeight = 32;
  static const double _badgePaddingVertical = 1.5;

  @override
  String get factoryId => 'detailSmall';

  @override
  NativeAdOptions get nativeAdOptions => NativeAdOptions(
    adChoicesPlacement: AdChoicesPlacement.topRightCorner,
    // 정사각 칸이라 정사각 이미지를 달라고 한다(없는 광고는 칸 안에 맞춘다).
    mediaAspectRatio: MediaAspectRatio.square,
  );

  double get _bottomRowHeight => [
    _ctaHeight,
    badgeLineHeight + _badgePaddingVertical * 2,
  ].reduce((a, b) => a > b ? a : b);

  /// 미디어 · 글자 칸 높이. 글자가 커도 잘리지 않게 글자 쪽이 더 크면 그만큼 늘린다.
  double get contentHeight {
    final double text =
        titleLineHeight * 2 +
        _textGap +
        smallLineHeight +
        _bottomGap +
        _bottomRowHeight;
    return text > _mediaSize ? text : _mediaSize;
  }

  @override
  double get height => _paddingVertical * 2 + contentHeight;

  @override
  Widget placeholder(BuildContext context) {
    final Color color = adSkeletonColor(context);
    return ColoredBox(
      color: background,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _paddingVertical),
        child: SizedBox(
          height: contentHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: _mediaSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: mediaBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: _mediaGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    adSkeletonLine(
                      lineHeight: titleLineHeight,
                      widthFactor: 0.9,
                      color: color,
                    ),
                    adSkeletonLine(
                      lineHeight: titleLineHeight,
                      widthFactor: 0.6,
                      color: color,
                    ),
                    const SizedBox(height: _textGap),
                    adSkeletonLine(
                      lineHeight: smallLineHeight,
                      widthFactor: 0.5,
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Map<String, Object> toOptions() => {
    'background': background.toARGB32(),
    'mediaBackground': mediaBackground.toARGB32(),
    'contentHeight': contentHeight,
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
  ];
}
