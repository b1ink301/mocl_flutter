import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';

void main() {
  TextStyle body(double factor) =>
      TextStyle(fontSize: kAppTitleFontSize * factor);

  test('0단계는 28/34, 펼침 98(툴바 56 + 제목 34 + 아래 8)', () {
    final TextStyle style = largeTitleStyle(body(1.0));
    expect(style.fontSize, 28);
    expect(largeTitleLineHeight(style), closeTo(34, 0.001));
    expect(largeTitleSingleLineExpandedHeight(style), closeTo(98, 0.001));
  });

  test('글자 크기 설정의 절반 비율로 따라간다', () {
    expect(largeTitleStyle(body(1.1)).fontSize, closeTo(29.4, 0.001));
    expect(largeTitleStyle(body(0.75)).fontSize, closeTo(24.5, 0.001));
  });

  test('설정 범위(0.75~1.5배) 어디서나 제목이 본문보다 1.4배 이상 크다', () {
    for (double f = 0.75; f <= 1.5; f += 0.05) {
      final double title = largeTitleStyle(body(f)).fontSize!;
      expect(title / (kAppTitleFontSize * f), greaterThan(1.4), reason: '$f');
    }
  });

  test('상세 제목은 한 단계 작은 24/30, 같은 절반 비율로 따라간다', () {
    final TextStyle style = detailTitleStyle(body(1.0));
    expect(style.fontSize, 24);
    expect(largeTitleLineHeight(style), closeTo(30, 0.001));
    expect(detailTitleStyle(body(1.1)).fontSize, closeTo(25.2, 0.001));
    expect(style.fontWeight, largeTitleStyle(body(1.0)).fontWeight);
  });
}
