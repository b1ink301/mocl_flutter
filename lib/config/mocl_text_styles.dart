import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';

/// 앱 기본 폰트 패밀리(pubspec.yaml `fonts:` 에 번들).
///
/// [ThemeData.fontFamily] 로도 지정하지만, `PlainText`(RichText) 처럼
/// DefaultTextStyle 을 상속하지 않는 경로가 있어 스타일에도 직접 넣는다.
const String kAppFontFamily = 'Pretendard';

/// 앱 내에서 사용되는 시맨틱 컬러 정의 — "Paper" 디자인 시스템.
///
/// 웜 뉴트럴(종이) 배경 위에 단일 강조색(코랄)을 쓰는 읽기 중심 팔레트.
class MoclColors() {
  // ── Paper 공용 토큰 (Light) ──
  static const Color bgLight = Color(0xFFFBFAF9); // 배경(종이)
  static const Color surfaceLight = Color(0xFFFFFFFF); // 카드/표면
  static const Color accentLight = Color(0xFFE8552D); // 강조(코랄)
  static const Color accentWeakLight = Color(0xFFFCEBE5); // 강조 약(칩 배경)
  static const Color inkLight = Color(0xFF181A1F); // 본문 잉크
  static const Color subLight = Color(0xFF8B8F98); // 보조 텍스트
  static const Color faintLight = Color(0xFFB7BBC2); // 읽음/비활성
  static const Color lineLight = Color(0xFFEDEAE5); // 구분선

  // ── Paper 공용 토큰 (Dark) ──
  static const Color bgDark = Color(0xFF121316);
  static const Color surfaceDark = Color(0xFF1B1D22);
  static const Color accentDark = Color(0xFFFF7A57);
  static const Color accentWeakDark = Color(0xFF2A211D);
  static const Color inkDark = Color(0xFFECECEE);
  static const Color subDark = Color(0xFF8E929C);
  static const Color faintDark = Color(0xFF5C606A);
  static const Color lineDark = Color(0xFF26282E);

  // Light Theme Colors (시맨틱)
  static const Color title = inkLight;
  static const Color readTitle = faintLight;
  static const Color small = subLight;
  static const Color readSmall = faintLight;
  static const Color badge = accentLight;
  static const Color readBadge = faintLight;

  // Dark Theme Colors (시맨틱)
  static const Color darkTitle = inkDark;
  static const Color darkReadTitle = faintDark;
  static const Color darkSmall = subDark;
  static const Color darkReadSmall = faintDark;
  static const Color darkBadge = accentDark;
  static const Color darkReadBadge = faintDark;

  // ── 말머리 태그(CategoryTag) 색 — 말머리 뜻별 6가지 ──
  static const Color tagCoralLight = accentLight;
  static const Color tagBlueLight = Color(0xFF2F6FEB);
  static const Color tagGreenLight = Color(0xFF17905F);
  static const Color tagAmberLight = Color(0xFFB9770E);
  static const Color tagVioletLight = Color(0xFF7357D3);
  static const Color tagSlateLight = Color(0xFF6B7079);

  static const Color tagCoralDark = accentDark;
  static const Color tagBlueDark = Color(0xFF6EA0FF);
  static const Color tagGreenDark = Color(0xFF4CC596);
  static const Color tagAmberDark = Color(0xFFE9A93A);
  static const Color tagVioletDark = Color(0xFFA38BFF);
  static const Color tagSlateDark = Color(0xFFA2A6AF);
}

/// 기본 폰트 사이즈 정의
/// Flutter의 Text 위젯이 시스템 폰트 설정을 자동으로 반영하므로 기준값만 정의합니다.
class _AppFontSizes() {
  static const double title = 16.0;
  static const double small = 13.0;
  static const double badge = 11.0;
}

class const AppTextStyles({
  required final TextStyle titleTextStyle,
  required final TextStyle readTitleTextStyle,
  required final TextStyle smallTextStyle,
  required final TextStyle readSmallTextStyle,
  required final TextStyle badgeTextStyle,
  required final TextStyle readBadgeTextStyle,
  // 말머리 태그처럼 라이트/다크 색이 따로 있는 요소가 Theme 조회 없이 고르도록 둔다.
  final Brightness brightness = Brightness.light,
}) extends ThemeExtension<AppTextStyles> with Equatable {
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
      brightness: brightness,
    );
  }

  static TextStyle _scale(TextStyle style, double factor) =>
      style.copyWith(fontSize: (style.fontSize ?? 14.0) * factor);

  /// Light Theme 인스턴스
  static final AppTextStyles light = AppTextStyles(
    titleTextStyle: _create(
      MoclColors.title,
      _AppFontSizes.title,
    ).copyWith(fontWeight: FontWeight.w400),
    readTitleTextStyle: _create(MoclColors.readTitle, _AppFontSizes.title),
    smallTextStyle: _create(
      MoclColors.small,
      _AppFontSizes.small,
    ).copyWith(fontWeight: FontWeight.w300),
    readSmallTextStyle: _create(MoclColors.readSmall, _AppFontSizes.small),
    badgeTextStyle: _create(
      MoclColors.badge,
      _AppFontSizes.badge,
    ).copyWith(fontWeight: FontWeight.w500),
    readBadgeTextStyle: _create(
      MoclColors.readBadge,
      _AppFontSizes.badge,
    ).copyWith(fontWeight: FontWeight.w300),
  );

  /// Dark Theme 인스턴스
  static final AppTextStyles dark = AppTextStyles(
    titleTextStyle: _create(MoclColors.darkTitle, _AppFontSizes.title),
    readTitleTextStyle: _create(MoclColors.darkReadTitle, _AppFontSizes.title),
    smallTextStyle: _create(MoclColors.darkSmall, _AppFontSizes.small),
    readSmallTextStyle: _create(MoclColors.darkReadSmall, _AppFontSizes.small),
    badgeTextStyle: _create(MoclColors.darkBadge, _AppFontSizes.badge),
    readBadgeTextStyle: _create(MoclColors.darkReadBadge, _AppFontSizes.badge),
    brightness: Brightness.dark,
  );

  static TextStyle _create(Color color, double fontSize) =>
      TextStyle(color: color, fontSize: fontSize, fontFamily: kAppFontFamily);

  @override
  AppTextStyles copyWith({
    TextStyle? titleTextStyle,
    TextStyle? readTitleTextStyle,
    TextStyle? smallTextStyle,
    TextStyle? readSmallTextStyle,
    TextStyle? badgeTextStyle,
    TextStyle? readBadgeTextStyle,
    Brightness? brightness,
  }) => AppTextStyles(
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    readTitleTextStyle: readTitleTextStyle ?? this.readTitleTextStyle,
    smallTextStyle: smallTextStyle ?? this.smallTextStyle,
    readSmallTextStyle: readSmallTextStyle ?? this.readSmallTextStyle,
    badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
    readBadgeTextStyle: readBadgeTextStyle ?? this.readBadgeTextStyle,
    brightness: brightness ?? this.brightness,
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
      brightness: t < 0.5 ? brightness : other.brightness,
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
    brightness,
  ];
}

/// BuildContext를 통한 편리한 접근을 위한 Extension
extension AppTextStylesContextExtension on BuildContext {
  AppTextStyles get textStyles => AppTextStyles._of(this);
}
