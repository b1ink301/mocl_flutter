import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 서버 크롤러가 실제로 만든 글 주소(2026-11-05, `server` 의 SiteFetcher 결과).
/// 알림을 누르면 이 주소를 SiteLinkResolver 로 열므로, 모든 지원 사이트에서
/// 상세로 열려야 한다(브라우저로 새면 안 된다).
const List<(String, String)> _crawledUrls = [
  ('bobaedream', 'https://m.bobaedream.co.kr/board/bbs_view/best/1045464/2/1'),
  (
    'clien',
    'https://m.clien.net/service/board/jirum/19284139?od=T31&po=1&category=0&groupCd=',
  ),
  ('cook82', 'https://www.82cook.com/entiz/read.php?bn=15&num=4256008&page=1'),
  ('damoang', 'https://damoang.net/economy/82588'),
  ('dcinside', 'https://m.dcinside.com/board/dcbest/475849?page=1'),
  ('dogdrip', 'https://www.dogdrip.net/dogdrip/733205366'),
  ('geekNews', 'https://news.hada.io/topic?id=36622'),
  ('inven', 'https://m.inven.co.kr/board/webzine/2097/2749127?p=1'),
  ('meeco', 'https://meeco.kr/free/42435108?page=1'),
  (
    'mlbpark',
    'https://mlbpark.donga.com/mp/b.php?id=202611050119910168&p=1&b=bullpen&m=view&select=&query=&subselect=&subquery=&user=&site=donga.com',
  ),
  ('nate', 'https://m.pann.nate.com/talk/375700631'),
  ('ppomppu', 'https://www.ppomppu.co.kr/zboard/view.php?id=ppomppu&no=746164'),
];

void main() {
  test('알림 지원 사이트를 빠짐없이 다룬다', () {
    expect(
      _crawledUrls.map((e) => e.$1).toSet(),
      KeywordAlerts.sites.map((s) => s.name).toSet(),
    );
  });

  for (final (String site, String url) in _crawledUrls) {
    test('$site 알림 주소는 앱 상세로 열린다', () {
      final SiteLink? link = SiteLinkResolver.resolve(url);
      expect(link, isNotNull, reason: url);
      expect(link!.siteType.name, site);
      expect(link.item.id, greaterThan(0));
    });
  }

  test('SiteType 이름과 맞는다', () {
    expect(
      SiteType.values.map((s) => s.name),
      containsAll(_crawledUrls.map((e) => e.$1)),
    );
  });
}
