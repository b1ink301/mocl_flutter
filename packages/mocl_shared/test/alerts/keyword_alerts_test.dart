import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:test/test.dart';

Map<String, Object?> _sub({
  String site = 'ppomppu',
  String url = 'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
  List<Object?> keywords = const ['에어팟'],
  String board = 'ppomppu',
}) => {
  'site': site,
  'board': board,
  'url': url,
  'title': '뽐뿌게시판',
  'keywords': keywords,
};

void main() {
  group('matchedKeywords', () {
    test('대소문자와 공백을 무시한다', () {
      expect(
        KeywordAlerts.matchedKeywords('[11번가] 애플 에어팟프로 2 (199,000원)', [
          '에어팟 프로',
          'AIRPODS',
          '애플',
        ]),
        ['에어팟 프로', '애플'],
      );
      expect(KeywordAlerts.matchedKeywords('Apple AirPods Pro', ['airpods']), [
        'airpods',
      ]);
    });
  });

  group('AlertSubscription.fromJson', () {
    test('정상 입력은 키워드를 다듬고 중복을 뺀다', () {
      final s = AlertSubscription.fromJson(
        _sub(keywords: [' 에어팟 ', '에어팟', '갤럭시']),
      );
      expect(s.site, SiteType.ppomppu);
      expect(s.keywords, ['에어팟', '갤럭시']);
      expect(s.boardKey, 'ppomppu|ppomppu');
    });

    test('지원하지 않는 사이트 · 다른 도메인 URL · 빈 키워드는 거절한다', () {
      for (final Map<String, Object?> bad in [
        _sub(site: 'theqoo'),
        _sub(site: 'nope'),
        _sub(url: 'http://169.254.169.254/latest/meta-data'),
        _sub(url: 'https://m.ppomppu.co.kr:8443/x'),
        _sub(url: 'https://evil.com/?m.ppomppu.co.kr'),
        _sub(url: 'file:///etc/passwd'),
        _sub(keywords: []),
        _sub(keywords: ['   ']),
        _sub(keywords: ['a' * 31]),
        _sub(keywords: List<String>.generate(11, (i) => 'k$i')),
      ]) {
        expect(
          () => AlertSubscription.fromJson(bad),
          throwsFormatException,
          reason: '$bad',
        );
      }
    });
  });

  group('AlertRegistration.fromJson', () {
    Map<String, Object?> reg(List<Object?> subs) => {
      'fcmToken': 'tok',
      'platform': 'android',
      'subscriptions': subs,
    };

    test('toJson 과 왕복한다', () {
      final r = AlertRegistration.fromJson(reg([_sub()]));
      expect(AlertRegistration.fromJson(r.toJson()).toJson(), r.toJson());
    });

    test('같은 게시판 두 번 · 게시판 수 초과 · 모르는 플랫폼은 거절한다', () {
      expect(
        () => AlertRegistration.fromJson(reg([_sub(), _sub()])),
        throwsFormatException,
      );
      expect(
        () => AlertRegistration.fromJson(
          reg(List.generate(11, (i) => _sub(board: 'b$i'))),
        ),
        throwsFormatException,
      );
      expect(
        () => AlertRegistration.fromJson({...reg([]), 'platform': 'web'}),
        throwsFormatException,
      );
    });
  });

  group('AlertRegistration.limited', () {
    Map<String, Object?> reg(List<Object?> subs) => {
      'fcmToken': 'tok',
      'platform': 'android',
      'subscriptions': subs,
    };

    test('한도 안이면 그대로 돌려준다', () {
      final r = AlertRegistration.fromJson(reg([_sub()]));
      expect(identical(r.limited(), r), isTrue);
    });

    test('옛 앱(한도 10)의 등록은 받되 앞에서부터 한도만큼만 쓴다', () {
      final r = AlertRegistration.fromJson(
        reg(
          List.generate(
            KeywordAlerts.acceptBoards,
            (i) => _sub(
              board: 'b$i',
              keywords: List.generate(
                KeywordAlerts.acceptKeywordsPerBoard,
                (k) => 'k$k',
              ),
            ),
          ),
        ),
      );
      final limited = r.limited();
      expect(
        limited.subscriptions.map((s) => s.board),
        List.generate(KeywordAlerts.maxBoards, (i) => 'b$i'),
      );
      for (final s in limited.subscriptions) {
        expect(
          s.keywords,
          List.generate(KeywordAlerts.maxKeywordsPerBoard, (k) => 'k$k'),
        );
      }
      expect(limited.fcmToken, 'tok');
    });

    test('allow 로 허용 밖 구독을 먼저 걸러 낸 뒤 한도만큼 자른다', () {
      final r = AlertRegistration.fromJson(
        reg([
          for (int i = 0; i < 3; i++) _sub(board: 'x$i'),
          for (int i = 0; i < 4; i++) _sub(board: 'ok$i'),
        ]),
      );
      final limited = r.limited(allow: (s) => s.board.startsWith('ok'));
      expect(
        limited.subscriptions.map((s) => s.board),
        List.generate(KeywordAlerts.maxBoards, (i) => 'ok$i'),
      );
      expect(r.limited(allow: (_) => false).subscriptions, isEmpty);
      final within = AlertRegistration.fromJson(reg([_sub()]));
      expect(identical(within.limited(allow: (_) => true), within), isTrue);
    });
  });

  group('기한', () {
    test('startedAt 은 선택이고 왕복한다 · 음수나 문자열은 거절한다', () {
      expect(AlertSubscription.fromJson(_sub()).startedAt, isNull);
      final s = AlertSubscription.fromJson({..._sub(), 'startedAt': 123});
      expect(s.startedAt, 123);
      expect(AlertSubscription.fromJson(s.toJson()).startedAt, 123);
      expect(
        () => AlertSubscription.fromJson({..._sub(), 'startedAt': -1}),
        throwsFormatException,
      );
      expect(
        () => AlertSubscription.fromJson({..._sub(), 'startedAt': '1'}),
        throwsFormatException,
      );
    });

    test('isExpired', () {
      const Duration day = Duration(days: 1);
      final int ms = day.inMilliseconds;
      expect(KeywordAlerts.isExpired(0, ms - 1, day), isFalse);
      expect(KeywordAlerts.isExpired(0, ms, day), isTrue);
      expect(KeywordAlerts.isExpired(0, ms * 1000, null), isFalse);
    });
  });
}
