import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';

void main() {
  void expectLink(
    String url,
    SiteType siteType, {
    required String detailUrl,
    required String board,
    int? id,
  }) {
    final SiteLink? link = SiteLinkResolver.resolve(url);
    expect(link, isNotNull, reason: url);
    expect(link!.siteType, siteType, reason: url);
    expect(link.item.url, detailUrl, reason: url);
    expect(link.item.board, board, reason: url);
    if (id != null) expect(link.item.id, id, reason: url);
  }

  group('게시글 링크를 상세로 바꾼다', () {
    test('PC 주소는 파서가 읽는 모바일 주소로 바꾼다', () {
      expectLink(
        'https://www.clien.net/service/board/park/19012345?od=T31',
        SiteType.clien,
        detailUrl: 'https://m.clien.net/service/board/park/19012345',
        board: 'park',
        id: 19012345,
      );
      expectLink(
        'https://gall.dcinside.com/mgallery/board/view/?id=github&no=1234',
        SiteType.dcinside,
        detailUrl: 'https://m.dcinside.com/board/github/1234',
        board: 'github',
      );
      expectLink(
        'https://www.ppomppu.co.kr/zboard/view.php?id=ppomppu&no=600001',
        SiteType.ppomppu,
        detailUrl:
            'https://m.ppomppu.co.kr/new/bbs_view.php?id=ppomppu&no=600001',
        board: 'ppomppu',
      );
      expectLink(
        'https://bbs.ruliweb.com/community/board/300143/read/70000001',
        SiteType.ruliweb,
        detailUrl: 'https://m.ruliweb.com/community/board/300143/read/70000001',
        board: '300143',
      );
      expectLink(
        'https://www.inven.co.kr/board/maple/5974/123456',
        SiteType.inven,
        detailUrl: 'https://m.inven.co.kr/board/maple/5974/123456',
        board: '5974',
      );
      expectLink(
        'https://www.bobaedream.co.kr/view?code=freeb&No=3000001',
        SiteType.bobaedream,
        detailUrl: 'https://m.bobaedream.co.kr/board/bbs_view/freeb/3000001',
        board: 'freeb',
      );
      expectLink(
        'https://pann.nate.com/talk/370000001',
        SiteType.nate,
        detailUrl: 'https://m.pann.nate.com/talk/370000001',
        board: 'ranking',
      );
    });

    test('모바일 · 경로형 주소', () {
      expectLink(
        'https://damoang.net/free/1234567',
        SiteType.damoang,
        detailUrl: 'https://damoang.net/free/1234567',
        board: 'free',
      );
      expectLink(
        'https://arca.live/b/breaking/100000001?p=1',
        SiteType.arcalive,
        detailUrl: 'https://arca.live/b/breaking/100000001',
        board: 'breaking',
      );
      expectLink(
        'https://theqoo.net/hot/3500000001',
        SiteType.theqoo,
        detailUrl: 'https://theqoo.net/hot/3500000001',
        board: 'hot',
      );
      expectLink(
        'https://meeco.kr/index.php?mid=news&document_srl=40000001',
        SiteType.meeco,
        detailUrl: 'https://meeco.kr/news/40000001',
        board: 'news',
      );
      expectLink(
        'https://news.hada.io/topic?id=21000',
        SiteType.geekNews,
        detailUrl: 'https://news.hada.io/topic?id=21000',
        board: '',
      );
      expectLink(
        'https://www.82cook.com/entiz/read.php?bn=15&num=3900001',
        SiteType.cook82,
        detailUrl: 'https://www.82cook.com/entiz/read.php?bn=15&num=3900001',
        board: '15',
      );
      expectLink(
        'https://mlbpark.donga.com/mp/b.php?p=1&b=bullpen&id=202601010001&m=view',
        SiteType.mlbpark,
        detailUrl: 'https://mlbpark.donga.com/mp/b.php?m=view&b=bullpen&id=202601010001',
        board: 'bullpen',
      );
      expectLink(
        'https://www.instiz.net/pt/7000001',
        SiteType.instiz,
        detailUrl: 'https://www.instiz.net/pt/7000001',
        board: 'pt',
      );
      expectLink(
        'https://www.dogdrip.net/dogdrip/600000001',
        SiteType.dogdrip,
        detailUrl: 'https://www.dogdrip.net/dogdrip/600000001',
        board: 'dogdrip',
      );
    });

    test('레딧은 url 자리에 글 id 를 둔다', () {
      expectLink(
        'https://www.reddit.com/r/FlutterDev/comments/1abcde/some_title/',
        SiteType.reddit,
        detailUrl: '1abcde',
        board: 'FlutterDev',
        id: '1abcde'.hashCode,
      );
    });

    test('네이버카페는 숫자 카페 id 로 받는다', () {
      expectLink(
        'https://m.cafe.naver.com/ca-fe/web/cafes/10050146/articles/1234',
        SiteType.naverCafe,
        detailUrl: '',
        board: '10050146',
        id: 1234,
      );
      expectLink(
        'https://cafe.naver.com/ArticleRead.nhn?clubid=10050146&articleid=99',
        SiteType.naverCafe,
        detailUrl: '',
        board: '10050146',
        id: 99,
      );
    });
  });

  group('글이 아닌 링크는 브라우저로 보낸다', () {
    for (final url in <String>[
      'https://www.google.com/search?q=mocl',
      'https://m.clien.net/service/board/park',
      'https://damoang.net/free',
      'https://gall.dcinside.com/board/lists/?id=github',
      'https://cafe.naver.com/joonggonara/123',
      'https://www.reddit.com/r/FlutterDev/',
      'https://theqoo.net/hot',
      'mailto:a@b.com',
      'not a url',
    ]) {
      test(url, () => expect(SiteLinkResolver.resolve(url), isNull));
    }
  });
}
