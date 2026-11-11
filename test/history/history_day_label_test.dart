import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/history/presentation/history_page.dart';

void main() {
  final DateTime now = DateTime(2026, 11, 11, 0, 30);

  test('오늘 · 어제 · 올해 · 지난해', () {
    expect(historyDayLabel(DateTime(2026, 11, 11, 0, 1), now), '오늘');
    expect(historyDayLabel(DateTime(2026, 11, 10, 23, 59), now), '어제');
    expect(historyDayLabel(DateTime(2026, 11, 3, 9), now), '11월 3일');
    expect(historyDayLabel(DateTime(2025, 12, 30), now), '2025년 12월 30일');
  });
}
