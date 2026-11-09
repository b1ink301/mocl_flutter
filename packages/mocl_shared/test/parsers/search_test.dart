import 'package:dio/dio.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/error/failures.dart';
import 'package:mocl_shared/parser/arcalive/arcalive_parser.dart';
import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:mocl_shared/parser/bobaedream/bobaedream_parser.dart';
import 'package:mocl_shared/parser/clien/clien_parser.dart';
import 'package:mocl_shared/parser/cook82/cook82_parser.dart';
import 'package:mocl_shared/parser/damoang/damoang_parser.dart';
import 'package:mocl_shared/parser/dcinside/dcinside_parser.dart';
import 'package:mocl_shared/parser/dogdrip/dogdrip_parser.dart';
import 'package:mocl_shared/parser/geek_news/geek_news_parser.dart';
import 'package:mocl_shared/parser/instiz/instiz_parser.dart';
import 'package:mocl_shared/parser/inven/inven_parser.dart';
import 'package:mocl_shared/parser/meeco/meeco_parser.dart';
import 'package:mocl_shared/parser/mlbpark/mlbpark_parser.dart';
import 'package:mocl_shared/parser/nate/nate_parser.dart';
import 'package:mocl_shared/parser/naver_cafe/naver_cafe_parser.dart';
import 'package:mocl_shared/parser/ppomppu/ppomppu_parser.dart';
import 'package:mocl_shared/parser/reddit/reddit_parser.dart';
import 'package:mocl_shared/parser/ruliweb/ruliweb_parser.dart';
import 'package:mocl_shared/parser/theqoo/theqoo_parser.dart';
import 'package:test/test.dart';

import '../helpers/parse_list_harness.dart';

/// 게시판 검색 주소 · 검색 결과 행. 실제 사이트 확인은 `server/bin/canary.dart --search`.
void main() {
  /// 검색을 켠 파서와 (목록 주소, 게시판). 주소는 카나리 대상과 같다.
  final Map<BaseParser, (String, String)> searchable = {
    const ArcaliveParser(): ('https://arca.live/b/live', 'live'),
    const ClienParser(false): (
      'https://m.clien.net/service/board/park',
      'park',
    ),
    const Cook82Parser(): ('https://www.82cook.com/entiz/enti.php?bn=15', '15'),
    const DamoangParser(false): ('https://damoang.net/free', 'free'),
    const DcinsideParser(): ('https://m.dcinside.com/board/dcbest', 'dcbest'),
    const DogdripParser(): ('https://www.dogdrip.net/dogdrip', 'dogdrip'),
    const InstizParser(): ('https://www.instiz.net/pt', 'pt'),
    const InvenParser(): ('https://m.inven.co.kr/board/webzine/2097', '2097'),
    const MeecoParser(false): ('https://meeco.kr/free', 'free'),
    const MlbparkParser(): (
      'https://mlbpark.donga.com/mp/b.php?b=bullpen',
      'bullpen',
    ),
    const NateParser(): ('https://m.pann.nate.com/talk/ranking', 'ranking'),
    const PpomppuParser(): (
      'https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu',
      'ppomppu',
    ),
    const RedditParser(): (
      'https://www.reddit.com/r/flutterdev',
      'r/flutterdev',
    ),
    const RuliwebParser(): ('https://m.ruliweb.com/best/best', 'best'),
    const TheQooParser(): ('https://theqoo.net/hot', 'hot'),
  };

  group('검색 지원', () {
    test('검색 결과를 못 읽는 사이트는 끈다', () {
      expect(
        const BobaedreamParser().supportsSearch,
        isFalse,
        reason: '모바일 게시판 검색이 검색어를 무시한다',
      );
      expect(const GeekNewsParser().supportsSearch, isFalse);
      expect(const NaverCafeParser().supportsSearch, isFalse);
    });

    test('켠 사이트는 모두 검색 주소를 만든다', () {
      for (final MapEntry(key: parser, value: (url, board))
          in searchable.entries) {
        expect(parser.supportsSearch, isTrue, reason: '${parser.siteType}');
        expect(
          () => parser.searchListUrl(
            url,
            board,
            parser.firstSearchPage,
            '검색',
            const LastId(),
          ),
          returnsNormally,
          reason: '${parser.siteType}',
        );
      }
    });

    test('첫 쪽: 클리앙만 0, 나머지는 1', () {
      for (final BaseParser parser in searchable.keys) {
        expect(
          parser.firstSearchPage,
          parser is ClienParser ? 0 : 1,
          reason: '${parser.siteType}',
        );
      }
    });
  });

  group('검색어 인코딩', () {
    test('특수문자가 쿼리를 깨지 않는다', () {
      for (final MapEntry(key: parser, value: (url, board))
          in searchable.entries) {
        final String built = parser.searchListUrl(
          url,
          board,
          parser.firstSearchPage,
          ' a&b=c#d+e%f 한글 ',
          const LastId(),
        );
        final Uri uri = Uri.parse(built);
        expect(uri.fragment, isEmpty, reason: '${parser.siteType}: $built');
        expect(
          uri.queryParametersAll.values.expand((v) => v),
          contains('a&b=c#d+e%f 한글'),
          reason: '${parser.siteType}: $built',
        );
      }
    });
  });

  group('사이트별 검색 주소', () {
    String url(BaseParser p, int page, {LastId lastId = const LastId()}) {
      final (String u, String b) = searchable[p]!;
      return p.searchListUrl(u, b, page, '아이폰', lastId);
    }

    test('클리앙: 게시판 한정 통합 검색', () {
      expect(
        url(const ClienParser(false), 0),
        'https://m.clien.net/service/search'
        '?q=%EC%95%84%EC%9D%B4%ED%8F%B0&sort=recency&boardCd=park&isBoard=true&p=0',
      );
    });

    test('엠팍: 제목 검색, 쪽은 글 오프셋', () {
      expect(url(const MlbparkParser(), 1), contains('select=stt'));
      expect(url(const MlbparkParser(), 1), endsWith('&p=1'));
      expect(url(const MlbparkParser(), 3), endsWith('&p=61'));
    });

    test('뽐뿌: 게시판 목록 검색', () {
      expect(
        url(const PpomppuParser(), 2),
        startsWith('https://m.ppomppu.co.kr/new/bbs_list.php?id=ppomppu&'),
      );
      expect(url(const PpomppuParser(), 2), endsWith('&page=2'));
    });

    test('네이트: 모바일 검색', () {
      expect(
        url(const NateParser(), 1),
        startsWith('https://m.pann.nate.com/search/talk?q='),
      );
    });

    test('레딧: 커뮤니티 안 최신순, 다음 쪽은 after', () {
      expect(
        url(const RedditParser(), 1),
        'https://api.reddit.com/r/flutterdev/search'
        '?q=%EC%95%84%EC%9D%B4%ED%8F%B0&restrict_sr=1&sort=new&limit=25',
      );
      expect(
        url(const RedditParser(), 2, lastId: const LastId(stringId: 'abc')),
        endsWith('&after=t3_abc'),
      );
      expect(
        const RedditParser().searchListUrl(
          '',
          RedditParser.homeTitle,
          1,
          'x',
          const LastId(),
        ),
        'https://api.reddit.com/search?q=x&sort=new&limit=25',
      );
    });
  });

  group('검색 결과 읽기', () {
    test('네이트: 제목 안 댓글 수를 떼고 글쓴이 · 시각을 읽는다', () async {
      const String html = '''
<ul class="list"><li>
  <a class="cnbox" href="/talk/375705365?currMenu=search&amp;page=1&amp;q=아이폰">
    <span class="cont">
      <h2><span class="tit"><b>아이폰</b> 배터리 효율<span class="count">(3)</span></span></h2>
      <span class="sub"><span class="name">ㅇㅇ</span><span class="bar">|</span><span class="num">26.11.06 14:04</span></span>
    </span>
  </a>
</li></ul>''';
      final items = await runParseListWorker(
        NateParser.parseListInWorker,
        responseData: html,
        baseUrl: 'https://m.pann.nate.com',
      );
      expect(items, hasLength(1));
      expect(items.first.id, 375705365);
      expect(items.first.title, '아이폰 배터리 효율');
      expect(items.first.reply, '3');
      expect(items.first.userInfo.nickName, 'ㅇㅇ');
      expect(items.first.time, '26.11.06 14:04');
      expect(items.first.hit, isEmpty);
    });

    Future<Failure?> listFailure(BaseParser parser, String data) async {
      final result = await parser.list(
        Response<String>(
          data: data,
          requestOptions: RequestOptions(path: ''),
        ),
        const LastId(),
        '',
        (_, _) async => const <int>[],
      );
      return result.fold((f) => f, (_) => null);
    }

    test('로그인해야 검색되는 사이트는 로그인 실패로 돌려준다', () async {
      expect(
        await listFailure(
          const DamoangParser(false),
          '{"type":"data","nodes":[null,null,{"type":"data","data":'
          '[{"postsData":1},{"error":2},"로그인 후 검색할 수 있습니다."]}]}',
        ),
        isA<NotLoginFailure>(),
      );
      expect(
        await listFailure(
          const InstizParser(),
          '<span class="sorrybaby">죄송해요, 검색은 회원만 할 수 있어요</span>',
        ),
        isA<NotLoginFailure>(),
      );
    });
  });
}
