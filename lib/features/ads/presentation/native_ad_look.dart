import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';

/// 네이티브 광고 한 종류의 모양. Android 팩토리([factoryId])가 [toOptions] 를
/// `customOptions` 로 받아 그리고, Dart 는 같은 값으로 잰 [height] 로 광고를 감싼다.
///
/// 구현은 값 동등성을 가져야 한다. 같으면 이미 받은 광고를 그대로 쓰고,
/// 다르면(글자 크기 · 테마 변경) 새 모양으로 다시 받는다.
abstract interface class NativeAdLook() {
  String get factoryId;

  double get height;

  NativeAdOptions get nativeAdOptions;

  Map<String, Object> toOptions();
}

/// `PlainText` 와 같은 조건(스케일 없음)으로 잰 한 줄 높이.
double adLineHeight(TextStyle style) {
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

/// 팩토리의 `textView(o, prefix)` 가 읽는 글자 옵션.
Map<String, Object> adTextOptions(
  String prefix,
  TextStyle style,
  double lineHeight,
) => {
  '${prefix}Size': style.fontSize ?? 14.0,
  '${prefix}Color': (style.color ?? const Color(0xFF000000)).toARGB32(),
  '${prefix}Weight': (style.fontWeight ?? FontWeight.w400).value,
  '${prefix}LineHeight': lineHeight,
};
