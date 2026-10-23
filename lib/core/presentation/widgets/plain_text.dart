import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

/// Theme/DefaultTextStyle/Directionality/MediaQuery 의존을 제거한 Text.
/// SliverAppBar floating 같은 상황에서 inherited 변화로 리빌드되는 것을 막는다.
///
/// 트레이드오프:
/// - 시스템 폰트 스케일링 미반영 (textScaler 명시 안 함)
/// - DefaultTextStyle 상속 미반영 (스타일 직접 명시 필수)
///   단, 폰트 패밀리가 비어 있으면 앱 기본 폰트([kAppFontFamily])를 채운다.
/// - RTL/LTR 자동 처리 안 함
class const PlainText(
  final String text, {
  super.key,
  required final TextStyle style,
  final int? maxLines,
  final TextOverflow overflow = TextOverflow.clip,
  final StrutStyle? strutStyle,
  final TextAlign textAlign = TextAlign.start,
  final TextScaler textScaler = TextScaler.noScaling,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RichText(
    // AppTextStyles 계열은 이미 패밀리가 있어 복사 없이 그대로 쓴다.
    text: TextSpan(
      text: text,
      style: style.fontFamily == null
          ? style.copyWith(fontFamily: kAppFontFamily)
          : style,
    ),
    textDirection: TextDirection.ltr, // 명시 → Directionality 의존 X
    textScaler: textScaler, // 명시 → MediaQuery 의존 X
    maxLines: maxLines,
    overflow: overflow,
    strutStyle: strutStyle,
    textAlign: textAlign,
  );
}
