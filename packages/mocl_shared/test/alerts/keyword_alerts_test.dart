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
}
