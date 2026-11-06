import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/ads/domain/list_ad_placement.dart';
import 'package:mocl_flutter/features/ads/presentation/detail_ad_style.dart';
import 'package:mocl_flutter/features/ads/presentation/detail_small_ad_style.dart';

void main() {
  test('목록 광고 자리는 first 뒤, 그다음 interval 마다', () {
    const ListAdPlacement placement = ListAdPlacement(first: 3, interval: 10);
    // 구분선 index i 는 글 i 와 i+1 사이 → 3개 뒤는 index 2.
    expect(placement.slotAt(1), isNull);
    expect(placement.slotAt(2), 0);
    expect(placement.slotAt(11), isNull);
    expect(placement.slotAt(12), 1);
    expect(const ListAdPlacement().slotAt(4), 0);
    expect(const ListAdPlacement().slotAt(19), 1);
  });

  test('small 은 미디어 120 + 위아래 12 이상, medium 은 large 보다 낮다', () {
    final AppTextStyles styles = AppTextStyles.light;
    final ThemeData theme = ThemeData.light();
    final small = DetailSmallAdStyle.from(styles, theme);
    expect(small.height, greaterThanOrEqualTo(144));

    for (final double width in [336.0, 369.0, 696.0]) {
      final medium = DetailAdStyle.from(
        styles,
        theme,
        width,
        compactMedia: true,
      );
      final large = DetailAdStyle.from(styles, theme, width);
      expect(medium.height, lessThan(large.height));
      expect(medium.height, greaterThan(small.height));
    }
  });
}
