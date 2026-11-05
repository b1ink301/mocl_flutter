import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/sort_type.dart';
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
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:mocl_shared/remote_config/user_agents.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';
import 'package:xml/xml.dart';

/// 서버가 쓰는 사이트 파서. 닉네임 이미지는 필요 없으므로 끈다.
BaseParser parserOf(SiteType site) => switch (site) {
  SiteType.arcalive => const ArcaliveParser(),
  SiteType.bobaedream => const BobaedreamParser(),
  SiteType.clien => const ClienParser(false),
  SiteType.cook82 => const Cook82Parser(),
  SiteType.damoang => const DamoangParser(false),
  SiteType.dcinside => const DcinsideParser(),
  SiteType.dogdrip => const DogdripParser(),
  SiteType.geekNews => const GeekNewsParser(),
  SiteType.instiz => const InstizParser(),
  SiteType.inven => const InvenParser(),
  SiteType.meeco => const MeecoParser(false),
  SiteType.mlbpark => const MlbparkParser(),
  SiteType.nate => const NateParser(),
  SiteType.naverCafe => const NaverCafeParser(),
  SiteType.ppomppu => const PpomppuParser(),
  SiteType.reddit => const RedditParser(),
  SiteType.ruliweb => const RuliwebParser(),
  SiteType.theqoo => const TheQooParser(),
};

/// 목록을 받아 오지 못한 이유. 사이트가 막았는지(403 · 429)를 구분해 둔다.
class const FetchFailure(final String message, {final int? statusCode}) {
  bool get isBlocked => statusCode == 403 || statusCode == 429;

  @override
  String toString() =>
      'FetchFailure($message${statusCode != null ? ', $statusCode' : ''})';
}

/// 공개 게시판 목록 1쪽을 받아 파싱한다.
///
/// 로그인 쿠키는 쓰지 않는다(서버는 공개 페이지만 본다). UA 는 앱과 같은 규칙
/// (사이트별 기본 프리셋 + 원격 설정)을 따른다.
class SiteFetcher({
  final RemoteConfig Function() remoteConfig = _emptyConfig,
  final Dio Function(String userAgent) dioFactory = _defaultDio,
}) {
  static RemoteConfig _emptyConfig() => RemoteConfig.empty;

  /// UA 는 요청 헤더가 아니라 HttpClient 에 박는다. dart:io 는 리다이렉트를 따라갈 때
  /// 원래 요청의 User-Agent 헤더를 넘기지 않는다(앱 network_provider 와 같은 이유).
  /// 그래서 UA 마다 Dio 를 따로 둔다.
  static Dio _defaultDio(String userAgent) =>
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 15),
            responseType: ResponseType.bytes,
            validateStatus: (_) => true,
          ),
        )
        ..httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () => HttpClient()..userAgent = userAgent,
        );

  final Map<String, Dio> _dios = {};

  Dio _dioFor(String userAgent) =>
      _dios.putIfAbsent(userAgent, () => dioFactory(userAgent));

  String userAgentOf(SiteType site) => remoteConfig().userAgentFor(
    site,
    defaultPreset: defaultUserAgentPreset(site),
    builtIn: builtInUserAgents,
  );

  /// [site] 의 [board](목록 URL [url]) 1쪽. 실패하면 [FetchFailure] 를 던진다.
  Future<List<ListItem>> fetchList(
    SiteType site, {
    required String board,
    required String url,
    String boardTitle = '',
  }) async {
    // 뽐뿌는 목록 페이지가 데이터센터 IP 를 막아 RSS 로 받는다(RSS 는 열려 있다).
    if (site == SiteType.ppomppu) return _ppomppuRss(board, boardTitle);

    final BaseParser parser = parserOf(site);
    final String listUrl = parser.urlByList(
      url,
      board,
      1,
      SortType.recent,
      const LastId(),
    );
    final Response<List<int>> response;
    try {
      response = await _dioFor(userAgentOf(site)).get<List<int>>(
        listUrl,
        options: Options(
          headers: {
            'Referer': parser.baseUrl,
            'Accept-Language': 'ko-KR,ko;q=0.9',
          },
        ),
      );
    } on DioException catch (e) {
      throw FetchFailure('${e.type}');
    }
    final int status = response.statusCode ?? 0;
    if (status != 200) throw FetchFailure('HTTP', statusCode: status);

    final Response<String> decoded = Response<String>(
      data: decodeBody(response.data ?? const []),
      requestOptions: response.requestOptions,
      statusCode: status,
      headers: response.headers,
    );
    final result = await parser.list(
      decoded,
      const LastId(),
      boardTitle,
      (_, _) async => const <int>[],
    );
    return result.fold(
      (Failure f) => throw FetchFailure('parse: ${f.message}'),
      // 알림으로 보낸 주소를 앱이 그대로 열 수 있게 절대 주소로 맞춘다.
      (List<ListItem> items) => [
        for (final ListItem item in items)
          item.copyWith(url: Uri.parse(listUrl).resolve(item.url).toString()),
      ],
    );
  }

  Future<List<ListItem>> _ppomppuRss(String board, String boardTitle) async {
    if (!RegExp(r'^[A-Za-z0-9_]+$').hasMatch(board)) {
      throw FetchFailure('잘못된 뽐뿌 게시판: $board');
    }
    final Response<List<int>> response;
    try {
      response = await _dioFor(userAgentOf(SiteType.ppomppu))
          .get<List<int>>('https://www.ppomppu.co.kr/rss.php?id=$board');
    } on DioException catch (e) {
      throw FetchFailure('${e.type}');
    }
    final int status = response.statusCode ?? 0;
    if (status != 200) throw FetchFailure('HTTP', statusCode: status);
    try {
      return parsePpomppuRss(
        decodeBody(response.data ?? const []),
        board: board,
        boardTitle: boardTitle,
      );
    } on XmlException catch (e) {
      throw FetchFailure('rss: ${e.message}');
    }
  }

  /// 뽐뿌 RSS 를 목록 항목으로 바꾼다. 링크(`view.php?id=..&no=..`)는 https 로만 바꾼다
  /// — 앱의 SiteLinkResolver 가 이 형식을 상세로 연다.
  static List<ListItem> parsePpomppuRss(
    String xml, {
    required String board,
    String boardTitle = '',
  }) {
    final XmlDocument doc = XmlDocument.parse(xml);
    final List<ListItem> items = [];
    for (final XmlElement item in doc.findAllElements('item')) {
      String text(String name) => item.getElement(name)?.innerText.trim() ?? '';
      final String link = text('link').replaceFirst('http://', 'https://');
      final int? id = int.tryParse(
        Uri.tryParse(link)?.queryParameters['no'] ?? '',
      );
      final String title = text('title');
      if (id == null || title.isEmpty) continue;
      items.add(
        ListItem.empty().copyWith(
          id: id,
          title: title,
          url: link,
          board: board,
          boardTitle: boardTitle,
          time: text('pubDate'),
          userInfo: UserInfo(id: '', nickName: text('author'), nickImage: ''),
        ),
      );
    }
    return items;
  }

  /// UTF-8 로 읽고, 아니면 CP949(뽐뿌 등 옛 사이트)로 읽는다.
  static String decodeBody(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return cp949.decode(Uint8List.fromList(bytes), allowInvalid: true);
    }
  }

  void close() {
    for (final Dio dio in _dios.values) {
      dio.close(force: true);
    }
    _dios.clear();
  }
}
