import 'dart:ui' show Brightness, Color;

import 'package:flutter/painting.dart' show HSLColor;
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 강조색 한 벌(라이트 · 다크, 각각 진한 색 · 연한 칩 배경).
///
/// 앱은 강조색만 바꾸고 종이 배경 · 글자 · 구분선은 그대로 둔다(`MoclTheme`).
class const AccentColors({
  required final Color light,
  required final Color lightWeak,
  required final Color dark,
  required final Color darkWeak,
}) {
  Color of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  Color weakOf(Brightness brightness) =>
      brightness == Brightness.dark ? darkWeak : lightWeak;

  @override
  bool operator ==(Object other) =>
      other is AccentColors &&
      other.light == light &&
      other.lightWeak == lightWeak &&
      other.dark == dark &&
      other.darkWeak == darkWeak;

  @override
  int get hashCode => Object.hash(light, lightWeak, dark, darkWeak);
}

/// 강조색 표.
///
/// 브랜드색을 그대로 쓰면 읽히지 않는 사이트가 많다(클리앙 · 개드립 남색은 본문 잉크와
/// 구분되지 않고, 다모앙 노랑 · MLBPARK 주황은 종이 배경 위 글자 · 흰 글씨 배지가 안 읽힌다).
/// 그래서 **색상은 브랜드 그대로 두고 밝기만** 읽히는 범위로 당긴다([derive]).
/// 범위는 지금 기본 코랄(라이트 `#E8552D` · 다크 `#FF7A57`)과 같은 대비를 기준으로 잡았다.
abstract final class AccentPalette() {
  /// 기본(코랄). 테마 상수를 그대로 쓴다(밝기를 당기지 않는다).
  static const AccentColors coral = AccentColors(
    light: MoclColors.accentLight,
    lightWeak: MoclColors.accentWeakLight,
    dark: MoclColors.accentDark,
    darkWeak: MoclColors.accentWeakDark,
  );

  /// 라이트: 상대 휘도 범위. 위는 코랄(≈0.24, 흰 글씨 대비 ≈3.6)까지 — 더 밝으면
  /// 종이 배경 위 글자가 흐려진다. 아래는 본문 잉크(≈0.01)와 구분되는 밝기.
  static const double lightMinLuminance = 0.07;
  static const double lightMaxLuminance = 0.24;

  /// 다크: 어두운 배경 위 글자 대비 ≥ 4.5 이상(≈0.21)부터, 코랄 다크(≈0.36)보다
  /// 조금 밝은 정도까지(더 밝으면 눈부시다).
  static const double darkMinLuminance = 0.22;
  static const double darkMaxLuminance = 0.42;

  /// 브랜드색 [brand] 에서 강조색 한 벌을 만든다.
  static AccentColors derive(Color brand) {
    final Color light = _fitLuminance(
      brand,
      lightMinLuminance,
      lightMaxLuminance,
    );
    final Color dark = _fitLuminance(brand, darkMinLuminance, darkMaxLuminance);
    return AccentColors(
      light: light,
      dark: dark,
      // 연한 칩 배경: 코랄의 `#FCEBE5`(흰 바탕에 11%) · `#2A211D`(어두운 바탕에 10%)와 같은 비율.
      lightWeak: Color.alphaBlend(
        light.withValues(alpha: 0.11),
        const Color(0xFFFFFFFF),
      ),
      darkWeak: Color.alphaBlend(
        dark.withValues(alpha: 0.10),
        MoclColors.bgDark,
      ),
    );
  }

  /// HSL 밝기만 움직여 상대 휘도를 [min]~[max] 안에 넣는다(색상 · 채도는 유지).
  static Color _fitLuminance(Color color, double min, double max) {
    final double lum = color.computeLuminance();
    if (lum >= min && lum <= max) return color;
    final HSLColor hsl = HSLColor.fromColor(color);
    final double target = lum < min ? min : max;
    double lo = 0, hi = 1;
    for (int i = 0; i < 24; i++) {
      final double mid = (lo + hi) / 2;
      final double l = hsl.withLightness(mid).toColor().computeLuminance();
      if (l < target) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    // 범위 안쪽으로 붙인다(경계에서 반올림으로 벗어나지 않게).
    return hsl.withLightness(lum < min ? hi : lo).toColor();
  }

  /// 사이트 브랜드색(로고 에셋 `assets/icons/` 픽셀 · 사이트 `theme-color` 기준).
  ///
  /// 뽐뿌(로고 에셋 없음) · 아카라이브(무채색 로고) · 다모앙(노랑 → 겨자색)은 잠정값이다.
  /// 색을 바꾸려면 여기 기준값만 고친다(밝기는 [derive] 가 맞춘다).
  static Color brandOf(SiteType site) => switch (site) {
    SiteType.arcalive => const Color(0xFF313131),
    SiteType.bobaedream => const Color(0xFF18486C),
    SiteType.clien => const Color(0xFF232F3E),
    SiteType.cook82 => const Color(0xFF309024),
    SiteType.damoang => const Color(0xFFFCD818),
    SiteType.dcinside => const Color(0xFF3B4890),
    SiteType.dogdrip => const Color(0xFF2E4361),
    SiteType.geekNews => const Color(0xFF000065),
    SiteType.instiz => const Color(0xFF14BF68),
    SiteType.inven => const Color(0xFFA80000),
    SiteType.meeco => const Color(0xFF616BAF),
    SiteType.mlbpark => const Color(0xFFFC7800),
    SiteType.nate => const Color(0xFFFC2424),
    SiteType.naverCafe => const Color(0xFF03C75A),
    SiteType.ppomppu => const Color(0xFFA8455F),
    SiteType.reddit => const Color(0xFFFF4500),
    SiteType.ruliweb => const Color(0xFF003090),
    SiteType.theqoo => const Color(0xFF30546C),
  };

  static final Map<SiteType, AccentColors> _siteCache = {};

  /// 사이트 강조색.
  static AccentColors site(SiteType site) =>
      _siteCache[site] ??= derive(brandOf(site));

  /// "직접 고르기" 색(설정에 순번으로 저장 — 순서를 바꾸지 말고 뒤에 더할 것).
  static const List<Color> customBrands = [
    Color(0xFF2F6FEB), // 파랑
    Color(0xFF17905F), // 초록
    Color(0xFFB9770E), // 호박
    Color(0xFF7357D3), // 보라
    Color(0xFFD6336C), // 분홍
    Color(0xFF0B8A9B), // 청록
    Color(0xFF6B7079), // 회색
  ];

  static final List<AccentColors> custom = [
    for (final Color c in customBrands) derive(c),
  ];
}
