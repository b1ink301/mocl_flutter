import 'package:timeago/timeago.dart' as timeago;

/// 사이트별 파서들이 공통으로 사용하는 날짜 문자열 파서.
///
/// 지원 형식:
/// - `어제`
/// - `2026년 3월 12일 오후 03:10` (damoang 한국어 형식)
/// - `2026-06-11 10:00:00`, `2026.06.11 10:00` (연-월-일 + 시각)
/// - `12-25 14:30`, `12.25 14:30` (월-일 + 시각, 연도는 올해)
/// - `14:30`, `14:30:05` (시각만, 날짜는 오늘)
/// - `2026-06-11`, `2026.06.11` (날짜만, 시각은 현재 유지)
/// - `26.7.20 1:44 PM` (2자리 연도 + 영문 AM/PM)
/// - ISO 8601 (`2026-03-13T11:04:59+09:00`)
class ParserDateTime {
  ParserDateTime._();

  static final RegExp _korean = RegExp(
    r'(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일\s*(오전|오후)\s*(\d{1,2}):(\d{2})',
  );
  static final RegExp _ampm = RegExp(
    r'^(\d{2,4})[.-](\d{1,2})[.-](\d{1,2})\s+(\d{1,2}):(\d{2})\s*(AM|PM)$',
    caseSensitive: false,
  );
  static final RegExp _dateOnly = RegExp(
    r'^(\d{4})[.-](\d{1,2})[.-](\d{1,2})\.?$',
  );
  static final RegExp _timeOnly = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$');

  static DateTime parse(String input) {
    final String s = input.trim();
    final DateTime now = DateTime.now();

    if (s == '어제') return now.subtract(const Duration(days: 1));

    final koreanMatch = _korean.firstMatch(s);
    if (koreanMatch != null) {
      final bool isPm = koreanMatch.group(4) == '오후';
      int hour = int.parse(koreanMatch.group(5)!);
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return DateTime(
        int.parse(koreanMatch.group(1)!),
        int.parse(koreanMatch.group(2)!),
        int.parse(koreanMatch.group(3)!),
        hour,
        int.parse(koreanMatch.group(6)!),
      );
    }

    // `26.7.20 1:44 PM` — 2자리 연도 허용 + 영문 AM/PM 12시간제
    final ampmMatch = _ampm.firstMatch(s);
    if (ampmMatch != null) {
      final bool isPm = ampmMatch.group(6)!.toUpperCase() == 'PM';
      int year = int.parse(ampmMatch.group(1)!);
      if (year < 100) year += 2000;
      int hour = int.parse(ampmMatch.group(4)!);
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return DateTime(
        year,
        int.parse(ampmMatch.group(2)!),
        int.parse(ampmMatch.group(3)!),
        hour,
        int.parse(ampmMatch.group(5)!),
      );
    }

    // 날짜만 있으면 시각은 현재를 유지한다(timeago 표시가 일 단위로 끊기도록).
    final dateOnlyMatch = _dateOnly.firstMatch(s);
    if (dateOnlyMatch != null) {
      return DateTime(
        int.parse(dateOnlyMatch.group(1)!),
        int.parse(dateOnlyMatch.group(2)!),
        int.parse(dateOnlyMatch.group(3)!),
        now.hour,
        now.minute,
      );
    }

    final timeOnlyMatch = _timeOnly.firstMatch(s);
    if (timeOnlyMatch != null) {
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeOnlyMatch.group(1)!),
        int.parse(timeOnlyMatch.group(2)!),
        int.parse(timeOnlyMatch.group(3) ?? '0'),
      );
    }

    // "<날짜> <시각>" — 날짜는 점/대시 구분 2~3토큰, 시각은 HH:mm[:ss]
    final List<String> parts = s.split(RegExp(r'\s+'));
    if (parts.length == 2) {
      final List<String> dateParts = parts[0]
          .split(RegExp(r'[.-]'))
          .where((e) => e.isNotEmpty)
          .toList();
      final List<String> timeParts = parts[1].split(':');
      if ((dateParts.length == 2 || dateParts.length == 3) &&
          (timeParts.length == 2 || timeParts.length == 3)) {
        final bool hasYear = dateParts.length == 3;
        return DateTime(
          hasYear ? int.parse(dateParts[0]) : now.year,
          int.parse(dateParts[hasYear ? 1 : 0]),
          int.parse(dateParts[hasYear ? 2 : 1]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
          timeParts.length == 3 ? int.parse(timeParts[2]) : 0,
        );
      }
    }

    // ISO 8601 등 나머지는 표준 파서에 위임
    try {
      return DateTime.parse(s);
    } catch (_) {
      throw FormatException('지원하지 않는 날짜 형식', input);
    }
  }
}

/// `try { timeago.format(ParserDateTime.parse(raw)) } catch { raw }` 패턴을 한 줄로.
/// 파싱 실패 시 원본 문자열을 그대로 돌려준다.
String formatTimeago(String raw) {
  try {
    return timeago.format(ParserDateTime.parse(raw), locale: 'ko');
  } catch (_) {
    return raw;
  }
}
