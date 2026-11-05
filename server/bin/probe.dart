import 'dart:io';

import 'package:mocl_server/src/crawl/site_fetcher.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 서버 IP 에서 각 사이트 공개 목록을 받을 수 있는지 확인한다.
///
///   dart run bin/probe.dart            # 전체
///   dart run bin/probe.dart ppomppu    # 일부
///
/// 결과로 크롤러 허용 목록(`crawlableSites`)을 정한다. 데이터센터 IP 는 사이트마다
/// 막는 정도가 달라서 직접 재 봐야 한다.
const List<(SiteType, String board, String url)> samples = [
  (SiteType.arcalive, 'live', 'https://arca.live/b/live'),
  (
    SiteType.bobaedream,
    'best',
    'https://m.bobaedream.co.kr/board/new_writing/best',
  ),
  (SiteType.clien, 'recommend', 'https://m.clien.net/service/recommend/list'),
  (SiteType.clien, 'jirum', 'https://m.clien.net/service/board/jirum'),
  (SiteType.cook82, '15', 'https://www.82cook.com/entiz/enti.php?bn=15'),
  (SiteType.damoang, 'free', 'https://damoang.net/free'),
  (SiteType.dcinside, 'dcbest', 'https://m.dcinside.com/board/dcbest'),
  (SiteType.dogdrip, 'dogdrip', 'https://www.dogdrip.net/dogdrip'),
  (SiteType.geekNews, 'past', 'https://news.hada.io/past'),
  (SiteType.instiz, 'pt', 'https://www.instiz.net/pt'),
  (SiteType.inven, '2097', 'https://m.inven.co.kr/board/webzine/2097'),
  (SiteType.meeco, 'free', 'https://meeco.kr/free'),
  (SiteType.mlbpark, 'bullpen', 'https://mlbpark.donga.com/mp/b.php?b=bullpen'),
  (SiteType.nate, 'ranking', 'https://m.pann.nate.com/talk/ranking'),
  (
    SiteType.ppomppu,
    'ppomppu',
    'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
  ),
  (SiteType.ruliweb, 'best', 'https://m.ruliweb.com/best/best'),
  (
    SiteType.theqoo,
    'total?filter_mode=normal',
    'https://theqoo.net/total?filter_mode=normal',
  ),
];

Future<void> main(List<String> args) async {
  final SiteFetcher fetcher = SiteFetcher();
  int failed = 0;
  for (final (SiteType site, String board, String url) in samples) {
    if (args.isNotEmpty && !args.contains(site.name)) continue;
    final Stopwatch watch = Stopwatch()..start();
    try {
      final List<ListItem> items = await fetcher.fetchList(
        site,
        board: board,
        url: url,
      );
      final String first = items.isEmpty ? '-' : items.first.title;
      stdout.writeln(
        'OK   ${site.name.padRight(10)} $board  n=${items.length} '
        '${watch.elapsedMilliseconds}ms  "${first.length > 30 ? first.substring(0, 30) : first}"',
      );
      if (items.isEmpty) failed++;
    } catch (e) {
      failed++;
      stdout.writeln(
        'FAIL ${site.name.padRight(10)} $board  $e ${watch.elapsedMilliseconds}ms',
      );
    }
  }
  fetcher.close();
  exit(failed == 0 ? 0 : 1);
}
