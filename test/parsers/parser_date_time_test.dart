import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';

void main() {
  group('ParserDateTime.parse', () {
    test('clien/theqoo: yyyy-MM-dd HH:mm:ss', () {
      expect(
        ParserDateTime.parse('2025-12-25 14:30:05'),
        DateTime(2025, 12, 25, 14, 30, 5),
      );
    });

    test('naver/meeco: yyyy.MM.dd HH:mm (말미 점 포함 변형도)', () {
      expect(
        ParserDateTime.parse('2025.12.25 14:30'),
        DateTime(2025, 12, 25, 14, 30),
      );
      expect(
        ParserDateTime.parse('2025.12.25. 14:30'),
        DateTime(2025, 12, 25, 14, 30),
      );
    });

    test('월.일/월-일 + 시각은 올해로 파싱한다', () {
      final now = DateTime.now();
      expect(
        ParserDateTime.parse('12.25 14:30'),
        DateTime(now.year, 12, 25, 14, 30),
      );
      expect(
        ParserDateTime.parse('12-25 14:30'),
        DateTime(now.year, 12, 25, 14, 30),
      );
    });

    test('시각만 있으면 오늘 날짜로 파싱한다', () {
      final now = DateTime.now();
      final dt = ParserDateTime.parse('14:30');
      expect(dt, DateTime(now.year, now.month, now.day, 14, 30));
      final dtSec = ParserDateTime.parse('14:30:05');
      expect(dtSec, DateTime(now.year, now.month, now.day, 14, 30, 5));
    });

    test('날짜만 있으면 연도를 보존하고 시각은 현재를 유지한다', () {
      final dt = ParserDateTime.parse('2025-12-25');
      expect(dt.year, 2025);
      expect(dt.month, 12);
      expect(dt.day, 25);
      final dotted = ParserDateTime.parse('2025.12.25');
      expect(dotted.year, 2025);
    });

    test('어제', () {
      final dt = ParserDateTime.parse('어제');
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(dt.day, yesterday.day);
    });

    test('damoang: 한국어 오전/오후 형식', () {
      expect(
        ParserDateTime.parse('2026년 3월 12일 오후 03:10'),
        DateTime(2026, 3, 12, 15, 10),
      );
      expect(
        ParserDateTime.parse('2026년 3월 12일 오전 12:05'),
        DateTime(2026, 3, 12, 0, 5),
      );
    });

    test('damoang: ISO 8601', () {
      final dt = ParserDateTime.parse('2026-03-13T11:04:59+09:00');
      expect(dt.toUtc(), DateTime.utc(2026, 3, 13, 2, 4, 59));
    });

    test('지원하지 않는 형식은 FormatException 을 던진다', () {
      expect(() => ParserDateTime.parse('잘못된값'), throwsFormatException);
      expect(() => ParserDateTime.parse(''), throwsFormatException);
    });
  });
}
