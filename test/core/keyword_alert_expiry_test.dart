import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/keyword_alert_expiry.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

AlertSubscription _sub(int? startedAt) => AlertSubscription(
  site: SiteType.ppomppu,
  board: 'ppomppu',
  url: 'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
  title: '뽐뿌게시판',
  keywords: const ['에어팟'],
  startedAt: startedAt,
);

void main() {
  const Duration ttl = Duration(days: 3);
  final DateTime start = DateTime(2026, 11, 9, 9);
  String? label(Duration after, {Duration? ttl = ttl, int? startedAt}) =>
      KeywordAlertExpiry.of(
        _sub(startedAt ?? start.millisecondsSinceEpoch),
        ttl,
        start.add(after),
      ).label;

  test('남은 기간을 올림해서 보여 준다', () {
    expect(label(Duration.zero), '3일 남음');
    expect(label(const Duration(hours: 25)), '2일 남음');
    expect(label(const Duration(hours: 50)), '22시간 남음');
    expect(label(const Duration(hours: 71, minutes: 30)), '곧 끝남');
    expect(label(const Duration(hours: 72)), '끝남');
  });

  test('끝났는지', () {
    final KeywordAlertExpiry e = KeywordAlertExpiry.of(
      _sub(start.millisecondsSinceEpoch),
      ttl,
      start.add(const Duration(days: 4)),
    );
    expect(e.isExpired, isTrue);
    expect(e.hasLimit, isTrue);
  });

  test('기한 없음 · 시작 시각 모름이면 표시하지 않는다', () {
    expect(label(const Duration(days: 30), ttl: null), isNull);
    final KeywordAlertExpiry e = KeywordAlertExpiry.of(_sub(null), ttl, start);
    expect(e.label, isNull);
    expect(e.isExpired, isFalse);
  });
}
