import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:test/test.dart';

void main() {
  RemoteConfig parse(Object? alerts, {bool strict = false}) =>
      RemoteConfig.fromJson({
        'schemaVersion': RemoteConfig.schemaVersion,
        'alerts': alerts,
      }, strict: strict);

  test('없으면 기본 3일', () {
    final RemoteConfig c = parse(null);
    expect(c.alerts.isEmpty, isTrue);
    expect(c.alerts.ttl, const Duration(days: 3));
    expect(c.toJson().containsKey('alerts'), isFalse);
  });

  test('ttlDays 를 읽고 왕복한다 · 0 은 기한 없음', () {
    expect(parse({'ttlDays': 7}).alerts.ttl, const Duration(days: 7));
    expect(parse({'ttlDays': 0}).alerts.ttl, isNull);
    final RemoteConfig c = parse({'ttlDays': 7});
    expect(RemoteConfig.fromJson(c.toJson()).alerts.ttlDays, 7);
  });

  test('범위 밖 · 모양이 틀리면 엄격 모드에서 던지고, 느슨하면 기본값', () {
    for (final Object? bad in [
      {'ttlDays': -1},
      {'ttlDays': 91},
      {'ttlDays': '3'},
      3,
    ]) {
      expect(() => parse(bad, strict: true), throwsFormatException);
      expect(parse(bad).alerts.ttl, const Duration(days: 3));
    }
    expect(
      RemoteConfig.validate({
        'schemaVersion': RemoteConfig.schemaVersion,
        'alerts': {'ttlDays': 100},
      }),
      hasLength(1),
    );
  });

  group('boards', () {
    test('없으면 기본 허용 게시판(클리앙 park · sold, 다모앙 free)', () {
      final AlertsRemoteConfig a = parse(null).alerts;
      expect(a.isAlertBoard(SiteType.clien, 'park'), isTrue);
      expect(a.isAlertBoard(SiteType.clien, 'sold'), isTrue);
      expect(a.isAlertBoard(SiteType.damoang, 'free'), isTrue);
      expect(a.isAlertBoard(SiteType.clien, 'bug'), isFalse);
      expect(a.isAlertBoard(SiteType.damoang, 'laboratory'), isFalse);
      expect(a.isAlertBoard(SiteType.ppomppu, 'ppomppu'), isFalse);
    });

    test('설정이 있으면 그것만 쓰고 왕복한다', () {
      final RemoteConfig c = parse({
        'boards': {
          'ppomppu': {'ppomppu': '뽐뿌게시판'},
        },
      }, strict: true);
      expect(c.alerts.isAlertBoard(SiteType.ppomppu, 'ppomppu'), isTrue);
      expect(c.alerts.isAlertBoard(SiteType.clien, 'park'), isFalse);
      expect(
        RemoteConfig.fromJson(c.toJson(), strict: true).toJson(),
        c.toJson(),
      );
    });

    test('빈 객체면 알림 게시판이 없다(기본값과 다르다)', () {
      final AlertsRemoteConfig a = parse({
        'boards': <String, Object?>{},
      }, strict: true).alerts;
      expect(a.isEmpty, isFalse);
      expect(a.effectiveBoards, isEmpty);
      expect(a.isAlertBoard(SiteType.clien, 'park'), isFalse);
    });

    test('잘못된 값은 엄격 모드에서 던진다', () {
      for (final Object? bad in [
        {'boards': <Object?>[]},
        {
          'boards': {
            'ruliweb': {'best': '베스트'},
          },
        },
        {
          'boards': {
            'nope': {'a': 'b'},
          },
        },
        {
          'boards': {'clien': 'park'},
        },
        {
          'boards': {
            'clien': {'park': ''},
          },
        },
        {
          'boards': {
            'clien': {'': '빈 id'},
          },
        },
        {
          'boards': {
            'clien': {
              for (int i = 0; i <= AlertsRemoteConfig.maxBoardsPerSite; i++)
                'b$i': '게시판$i',
            },
          },
        },
      ]) {
        expect(() => parse(bad, strict: true), throwsFormatException);
      }
    });
  });
}
