import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/list_page/domain/list_density.dart';

void main() {
  test('짧은 화면은 기본 컴팩트 여백', () {
    expect(compactSpacingFor(640), (padding: 9.0, gap: 3.0));
    expect(compactSpacingFor(700), (padding: 9.0, gap: 3.0));
  });

  test('긴 화면일수록 여백이 늘고 900dp 부터는 그대로', () {
    expect(compactSpacingFor(800), (padding: 11.0, gap: 4.5));
    expect(compactSpacingFor(900), (padding: 13.0, gap: 6.0));
    expect(compactSpacingFor(1200), (padding: 13.0, gap: 6.0));
  });

  test('0.5 단위로 끊어 화면 높이가 조금 바뀌어도 값이 출렁이지 않는다', () {
    expect(compactSpacingFor(832), (padding: 11.5, gap: 5.0)); // S24 Ultra 세로
    expect(compactSpacingFor(835).padding, 11.5);
  });
}
