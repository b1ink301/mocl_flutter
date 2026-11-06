import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

import 'native_ad_look.dart';

/// 목록 행을 흉내 내는 네이티브 광고의 모양.
///
/// Android 팩토리(`ListNativeAdFactory.kt`)는 이 값을 `customOptions` 로 받아
/// 각 줄의 높이를 그대로 고정한다. 그래서 [height] 가 실제 광고 높이와 맞는다.
/// 여백 상수는 팩토리와 같아야 한다.
class ListAdStyle._({
  required final Color background,
  required final TextStyle title,
  required final TextStyle small,
  required final TextStyle badge,
  required final double titleLineHeight,
  required final double smallLineHeight,
  required final double badgeLineHeight,
  required final double paddingStart,
  required final double paddingEnd,
}) with Equatable implements NativeAdLook {
  /// 목록 행([AppTextStyles])의 안 읽은 글 스타일을 따른다.
  ///
  /// 좌우 여백 기본값은 목록 행과 같다. 이미 좌우 여백이 있는 곳(글 상세)은
  /// 0 으로 넘긴다.
  factory from(
    AppTextStyles styles,
    Color background, {
    double paddingStart = 16,
    double paddingEnd = 10,
  }) => ListAdStyle._(
    background: background,
    paddingStart: paddingStart,
    paddingEnd: paddingEnd,
    title: styles.titleTextStyle,
    small: styles.smallTextStyle,
    badge: styles.badgeTextStyle,
    titleLineHeight: adLineHeight(styles.titleTextStyle),
    smallLineHeight: adLineHeight(styles.smallTextStyle),
    badgeLineHeight: adLineHeight(styles.badgeTextStyle),
  );

  static const double _paddingVertical = 14;
  static const double _rowGap = 8;
  static const double _iconSize = 16;
  static const double _badgePaddingVertical = 1.5;

  @override
  String get factoryId => 'listTile';

  @override
  NativeAdOptions get nativeAdOptions =>
      NativeAdOptions(adChoicesPlacement: AdChoicesPlacement.topRightCorner);

  @override
  double get height {
    final double badgeHeight = badgeLineHeight + _badgePaddingVertical * 2;
    final double rowHeight = [
      smallLineHeight,
      badgeHeight,
      _iconSize,
    ].reduce((a, b) => a > b ? a : b);
    return _paddingVertical +
        titleLineHeight +
        _rowGap +
        rowHeight +
        _paddingVertical;
  }

  @override
  Widget placeholder(BuildContext context) {
    final Color color = adSkeletonColor(context);
    return ColoredBox(
      color: background,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          paddingStart,
          _paddingVertical,
          paddingEnd,
          _paddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            adSkeletonLine(
              lineHeight: titleLineHeight,
              widthFactor: 0.6,
              color: color,
            ),
            const SizedBox(height: _rowGap),
            adSkeletonLine(
              lineHeight: smallLineHeight,
              widthFactor: 0.3,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Map<String, Object> toOptions() => {
    'background': background.toARGB32(),
    'iconSize': _iconSize,
    'paddingStart': paddingStart,
    'paddingEnd': paddingEnd,
    ...adTextOptions('title', title, titleLineHeight),
    ...adTextOptions('small', small, smallLineHeight),
    ...adTextOptions('badge', badge, badgeLineHeight),
    'badgeBackground': (badge.color ?? MoclColors.accentLight)
        .withValues(alpha: 0.12)
        .toARGB32(),
  };

  @override
  List<Object?> get props => [
    background,
    title,
    small,
    badge,
    paddingStart,
    paddingEnd,
  ];
}
