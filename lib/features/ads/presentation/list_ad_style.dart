import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

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
}) with Equatable {
  /// 목록 행([AppTextStyles])의 안 읽은 글 스타일을 따른다.
  factory from(AppTextStyles styles, Color background) => ListAdStyle._(
    background: background,
    title: styles.titleTextStyle,
    small: styles.smallTextStyle,
    badge: styles.badgeTextStyle,
    titleLineHeight: _lineHeight(styles.titleTextStyle),
    smallLineHeight: _lineHeight(styles.smallTextStyle),
    badgeLineHeight: _lineHeight(styles.badgeTextStyle),
  );

  static const double _paddingVertical = 14;
  static const double _rowGap = 8;
  static const double _iconSize = 16;
  static const double _badgePaddingVertical = 1.5;

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

  Map<String, Object> toOptions() => {
    'background': background.toARGB32(),
    'iconSize': _iconSize,
    ..._text('title', title, titleLineHeight),
    ..._text('small', small, smallLineHeight),
    ..._text('badge', badge, badgeLineHeight),
    'badgeBackground': (badge.color ?? MoclColors.accentLight)
        .withValues(alpha: 0.12)
        .toARGB32(),
  };

  static Map<String, Object> _text(String prefix, TextStyle style, double lh) =>
      {
        '${prefix}Size': style.fontSize ?? 14.0,
        '${prefix}Color': (style.color ?? const Color(0xFF000000)).toARGB32(),
        '${prefix}Weight': (style.fontWeight ?? FontWeight.w400).value,
        '${prefix}LineHeight': lh,
      };

  /// `PlainText` 와 같은 조건(스케일 없음)으로 잰 한 줄 높이.
  static double _lineHeight(TextStyle style) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: '가A', style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
    )..layout();
    final double height = painter.height;
    painter.dispose();
    return height;
  }

  @override
  List<Object?> get props => [background, title, small, badge];
}
