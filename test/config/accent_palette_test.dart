import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/config/accent_palette.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

double _contrast(Color a, Color b) {
  final double la = a.computeLuminance(), lb = b.computeLuminance();
  final (double hi, double lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + 0.05) / (lo + 0.05);
}

double _hue(Color c) => HSLColor.fromColor(c).hue;

void main() {
  final Map<String, AccentColors> all = {
    for (final SiteType s in SiteType.values) s.name: AccentPalette.site(s),
    for (int i = 0; i < AccentPalette.custom.length; i++)
      'custom$i': AccentPalette.custom[i],
  };

  // 기준은 지금 기본 코랄이 내는 대비(라이트 흰 글씨 ≈3.6 · 종이 배경 ≈3.5, 다크 배경 ≈7).
  final double coralOnPaper = _contrast(
    MoclColors.accentLight,
    MoclColors.bgLight,
  );

  for (final MapEntry(key: String name, value: AccentColors c) in all.entries) {
    test('$name: 라이트 · 다크 모두 코랄만큼 읽힌다', () {
      expect(
        _contrast(c.light, MoclColors.bgLight),
        greaterThanOrEqualTo(coralOnPaper - 0.05),
      );
      // 본문 잉크와 구분되는 밝기(남색 · 검정 브랜드가 글자색처럼 보이지 않게).
      expect(c.light.computeLuminance(), greaterThanOrEqualTo(0.069));
      // 다크: 어두운 배경 위 글자 · 그 배경색 글자(onPrimary)가 읽힌다.
      expect(_contrast(c.dark, MoclColors.bgDark), greaterThanOrEqualTo(4.5));
    });
  }

  test('밝기만 당기고 색상(hue)은 브랜드 그대로', () {
    for (final SiteType s in SiteType.values) {
      final Color brand = AccentPalette.brandOf(s);
      if (HSLColor.fromColor(brand).saturation < 0.05) continue; // 무채색
      expect(
        (_hue(AccentPalette.site(s).light) - _hue(brand)).abs(),
        lessThan(1.0),
        reason: s.name,
      );
    }
  });

  test('이미 범위 안인 색은 그대로 둔다', () {
    const Color ok = Color(0xFF3B4890); // 디시
    expect(AccentPalette.derive(ok).light, ok);
  });

  test('기본 코랄은 테마 상수 그대로', () {
    expect(AccentPalette.coral.light, MoclColors.accentLight);
    expect(AccentPalette.coral.dark, MoclColors.accentDark);
  });
}
