import 'package:mocl_server/src/crawl/site_fetcher.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 사이트가 HTML 을 바꿔 파서가 깨졌는지 실제 사이트로 확인한다(`bin/canary.dart`).
///
/// 픽스처 테스트는 저장해 둔 옛 HTML 로 돌아서 사이트가 바뀌어도 통과한다.
/// 카나리는 지금 사이트에서 목록 1쪽과 그 안의 글 상세를 받아 앱과 같은 파서로 읽어 본다.

/// 카나리가 보는 게시판 하나.
class const CanaryTarget(
  final SiteType site,
  final String board,
  final String url, {

  /// 상세까지 볼지. 앱이 웹뷰로 받는 사이트(아카라이브)는 목록만 본다.
  final bool detail = true,
});

enum CanaryStatus() {
  /// 목록 · 상세 모두 읽힘.
  ok,

  /// 사이트가 막았거나(403 · 429 · 503) 연결이 안 됨. 파서 문제인지 알 수 없다.
  unreachable,

  /// 응답은 받았는데 읽지 못했다(파싱 실패 · 빈 목록 · 빈 본문 · 404/410 등).
  broken,
}

class const CanaryResult(
  final CanaryTarget target,
  final CanaryStatus status,
  final String message, {
  final int listCount = 0,
  final String sampleTitle = '',
});

/// 앱 기본 게시판 위주. 사이트마다 하나 이상, 앱에서 많이 여는 곳을 고른다.
const List<CanaryTarget> canaryTargets = [
  CanaryTarget(
    SiteType.arcalive,
    'live',
    'https://arca.live/b/live',
    detail: false,
  ),
  CanaryTarget(
    SiteType.bobaedream,
    'best',
    'https://m.bobaedream.co.kr/board/new_writing/best',
  ),
  CanaryTarget(
    SiteType.clien,
    'park',
    'https://m.clien.net/service/board/park',
  ),
  CanaryTarget(
    SiteType.clien,
    'jirum',
    'https://m.clien.net/service/board/jirum',
  ),
  CanaryTarget(
    SiteType.cook82,
    '15',
    'https://www.82cook.com/entiz/enti.php?bn=15',
  ),
  CanaryTarget(SiteType.damoang, 'free', 'https://damoang.net/free'),
  CanaryTarget(
    SiteType.dcinside,
    'dcbest',
    'https://m.dcinside.com/board/dcbest',
  ),
  CanaryTarget(SiteType.dogdrip, 'dogdrip', 'https://www.dogdrip.net/dogdrip'),
  CanaryTarget(SiteType.geekNews, 'past', 'https://news.hada.io/past'),
  CanaryTarget(SiteType.instiz, 'pt', 'https://www.instiz.net/pt'),
  CanaryTarget(
    SiteType.inven,
    '2097',
    'https://m.inven.co.kr/board/webzine/2097',
  ),
  CanaryTarget(SiteType.meeco, 'free', 'https://meeco.kr/free'),
  CanaryTarget(
    SiteType.mlbpark,
    'bullpen',
    'https://mlbpark.donga.com/mp/b.php?b=bullpen',
  ),
  CanaryTarget(
    SiteType.nate,
    'ranking',
    'https://m.pann.nate.com/talk/ranking',
  ),
  CanaryTarget(
    SiteType.ppomppu,
    'ppomppu',
    'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
  ),
  CanaryTarget(SiteType.ruliweb, 'best', 'https://m.ruliweb.com/best/best'),
  CanaryTarget(
    SiteType.theqoo,
    'total?filter_mode=normal',
    'https://theqoo.net/total?filter_mode=normal',
  ),
];

/// 목록 항목 중 제목 · 주소가 빈 비율이 이보다 크면 파서가 깨진 것으로 본다.
const double _maxBlankRatio = 0.2;

class Canary({
  required final SiteFetcher fetcher,

  /// 요청 사이 쉬는 시간(사이트 부담 · 차단 방지).
  final Duration pause = const Duration(milliseconds: 500),
}) {
  Future<CanaryResult> check(CanaryTarget target) async {
    final List<ListItem> items;
    try {
      items = await fetcher.fetchList(
        target.site,
        board: target.board,
        url: target.url,
        ppomppuRss: false,
      );
    } on FetchFailure catch (e) {
      return CanaryResult(target, _statusOf(e), '목록: $e');
    }

    if (items.isEmpty) {
      return CanaryResult(target, CanaryStatus.broken, '목록: 0개');
    }
    final int blank = items
        .where((i) => i.title.trim().isEmpty || i.url.trim().isEmpty)
        .length;
    if (blank / items.length > _maxBlankRatio) {
      return CanaryResult(
        target,
        CanaryStatus.broken,
        '목록: 제목/주소 빈 항목 $blank/${items.length}',
        listCount: items.length,
      );
    }
    if (!target.detail) {
      return CanaryResult(
        target,
        CanaryStatus.ok,
        '목록만',
        listCount: items.length,
        sampleTitle: items.first.title,
      );
    }

    // 위쪽은 공지 · 고정글이 많아 가운데 글로 본다. 지워졌거나 성인 글일 수 있으니
    // 두 개까지 시도하고, 둘 다 실패하면 마지막 실패로 판정한다.
    final int mid = items.length ~/ 2;
    final List<ListItem> picks = [
      items[mid],
      if (items.length > 1) items[(mid + 1) % items.length],
    ];
    CanaryResult? last;
    for (final ListItem item in picks) {
      await Future<void>.delayed(pause);
      try {
        final Details details = await fetcher.fetchDetail(target.site, item);
        if (details.title.trim().isEmpty) {
          last = _broken(target, items, '상세: 제목 없음 ${item.url}');
          continue;
        }
        if (details.bodyHtml.trim().isEmpty) {
          last = _broken(target, items, '상세: 본문 없음 ${item.url}');
          continue;
        }
        return CanaryResult(
          target,
          CanaryStatus.ok,
          '댓글 ${details.comments.length}',
          listCount: items.length,
          sampleTitle: details.title,
        );
      } on FetchFailure catch (e) {
        last = CanaryResult(
          target,
          _statusOf(e),
          '상세: $e ${item.url}',
          listCount: items.length,
        );
      }
    }
    return last!;
  }

  static CanaryResult _broken(
    CanaryTarget target,
    List<ListItem> items,
    String message,
  ) => CanaryResult(
    target,
    CanaryStatus.broken,
    message,
    listCount: items.length,
  );

  static CanaryStatus _statusOf(FetchFailure e) =>
      e.network || const {403, 429, 503}.contains(e.statusCode)
      ? CanaryStatus.unreachable
      : CanaryStatus.broken;
}
