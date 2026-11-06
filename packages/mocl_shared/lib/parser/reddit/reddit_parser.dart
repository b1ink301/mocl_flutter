import 'dart:convert';
import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_shared/util/html_unescape.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_comment_item.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_shared/error/failures.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:mocl_shared/parser/base/base_ext.dart';
import 'package:mocl_shared/parser/base/parser_isolate_client.dart';
import 'package:mocl_shared/parser/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

class const RedditParser() extends BaseParser {
  /// reddit.com 첫 화면(구독 커뮤니티를 섞은 홈 피드) 게시판 이름.
  static const String homeTitle = '홈';

  /// 레딧 공식 아이콘(192px). 홈 게시판 아이콘으로 쓴다.
  static const String homeIcon =
      'https://www.redditstatic.com/shreddit/assets/favicon/192x192.png';

  @override
  String get baseUrl => 'https://www.reddit.com';

  @override
  bool get supportsTranslation => true;

  /// board_link.json 에 없어도 레딧 첫 화면(홈 피드)을 볼 수 있게 항상 붙인다.
  @override
  List<MainItem> get pinnedBoards => [
    MainItem(
      siteType: SiteType.reddit,
      orderBy: -1,
      url: baseUrl,
      board: homeTitle,
      text: homeTitle,
      // 구독 커뮤니티는 각자 아이콘이 있어 홈만 비면 줄이 어긋난다.
      icon: homeIcon,
      type: 0,
    ),
  ];

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(dynamic json) {
    if (json == null || json.isEmpty == true) {
      return Right<Failure, Details>(Details.empty());
    }

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final detailData =
        (json[0]['data']['children'] as List<dynamic>).first['data'];

    // selftext_html 은 링크/이미지 게시물에선 null → "null" 문자열 방지.
    // 링크 · 이미지 · 동영상 · 갤러리 글은 글 본문이 없으므로 미디어로 본문을 채운다.
    final rawBody = detailData['selftext_html'];
    final bodyHtml =
        _mediaHtml(detailData as Map<String, dynamic>) +
        (rawBody is String ? unescapeHtml(rawBody) : '');
    final title = detailData['title'].toString();
    final viewCount = '';
    final likeCount = detailData['ups'].toString();
    final nickImage = '';
    final userId = detailData['author_fullname'].toString();
    final nickName = detailData['author'].toString();
    final double created = detailData['created'] as double;
    final int milliseconds = (created * 1000).toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    final parsedTime = timeago.format(date, locale: 'ko');
    final info = BaseParser.parserInfo(parsedTime, viewCount);

    // 화면은 평평한 목록(isReply 로 들여쓰기)만 그리므로 트리를 원글 순서대로
    // 펼친다. replies 에 담아 두면 대댓글이 화면에 나오지 않는다.
    final comment = json[1]['data']['children'] as List<dynamic>?;
    final List<CommentItem> comments = [];
    if (comment != null) _flattenComments(comment, comments);

    // final translator = GoogleTranslator();
    // final html = htmlUnescape.convert(bodyHtml);
    // final translation = await translator.translate(html, to: 'ko');

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: created.toString(),
      info: info,
      userInfo: UserInfo(id: userId, nickName: nickName, nickImage: nickImage),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }

  static final RegExp _imageUrl = RegExp(
    r'\.(jpe?g|png|gif|webp)(\?|$)',
    caseSensitive: false,
  );

  /// 글 본문이 아닌 첨부(갤러리 · 레딧 동영상 · 외부 임베드 · 이미지 · 링크)를
  /// 본문 HTML 로 만든다. 크로스포스트는 원글의 첨부를 쓴다.
  /// 레딧 JSON 의 미디어 주소는 `&` 가 `&amp;` 로 이스케이프되어 온다.
  static String _mediaHtml(Map<String, dynamic> post) {
    final crossposts = post['crosspost_parent_list'];
    final Map<String, dynamic> src =
        crossposts is List && crossposts.isNotEmpty && crossposts.first is Map
        ? crossposts.first as Map<String, dynamic>
        : post;
    String clean(Object? url) => unescapeHtml('${url ?? ''}');
    String attr(String url) =>
        const HtmlEscape(HtmlEscapeMode.attribute).convert(url);

    // 1) 갤러리: gallery_data 순서대로 media_metadata 의 원본.
    final metadata = src['media_metadata'];
    final gallery = src['gallery_data']?['items'];
    if (src['is_gallery'] == true && metadata is Map && gallery is List) {
      final buffer = StringBuffer();
      for (final item in gallery) {
        final meta = metadata[item['media_id']];
        if (meta is! Map) continue;
        final s = meta['s'];
        if (s is! Map) continue;
        final mp4 = s['mp4'];
        if (mp4 != null) {
          buffer.write('<video controls src="${attr(clean(mp4))}"></video>');
        } else {
          final url = clean(s['u'] ?? s['gif']);
          if (url.isNotEmpty) buffer.write('<p><img src="${attr(url)}"></p>');
        }
      }
      return buffer.toString();
    }

    // 2) 레딧 동영상(v.redd.it). HLS 는 소리가 함께 나오고, fallback 은 영상만 있다.
    final video =
        src['secure_media']?['reddit_video'] ??
        src['media']?['reddit_video'] ??
        src['preview']?['reddit_video_preview'];
    if (video is Map) {
      final url = clean(video['hls_url'] ?? video['fallback_url']);
      if (url.isNotEmpty) {
        return '<video controls src="${attr(url)}"></video>';
      }
    }

    final String url = clean(src['url_overridden_by_dest'] ?? src['url']);
    final bool isSelf = src['is_self'] == true;

    // 3) 외부 임베드(유튜브 등). 상세 화면이 iframe 을 썸네일로 그린다.
    final embed = src['secure_media_embed']?['content'];
    final String embedHtml = embed is String ? unescapeHtml(embed) : '';
    if (embedHtml.contains('<iframe')) {
      return '$embedHtml'
          '<p><a href="${attr(url)}">${const HtmlEscape().convert(url)}</a></p>';
    }

    if (isSelf) {
      // 크로스포스트한 원글이 텍스트 글이면 원글 본문을 보여준다.
      final text = src['selftext_html'];
      return !identical(src, post) && text is String
          ? unescapeHtml(text)
          : '';
    }
    if (url.isEmpty) return '';

    // 4) 이미지 글.
    if (src['post_hint'] == 'image' || _imageUrl.hasMatch(url)) {
      return '<p><img src="${attr(url)}"></p>';
    }

    // 5) 링크 글: 미리보기 그림이 있으면 함께 보여주고 원문 링크를 단다.
    final preview = src['preview']?['images'];
    final String thumb = preview is List && preview.isNotEmpty
        ? clean(preview.first['source']?['url'])
        : '';
    return '${thumb.isEmpty ? '' : '<p><img src="${attr(thumb)}"></p>'}'
        '<p><a href="${attr(url)}">${const HtmlEscape().convert(url)}</a></p>';
  }

  /// 댓글 트리를 깊이 우선(부모 → 그 답글들 → 다음 부모)으로 [out] 에 펼친다.
  static void _flattenComments(
    List<dynamic> children,
    List<CommentItem> out,
  ) {
    for (final element in children) {
      if (element is! Map<String, dynamic>) continue;
      final item = _parseComment(element);
      if (item == null) continue;
      out.add(item);

      final replies = (element['data'] as Map<String, dynamic>)['replies'];
      if (replies is Map<String, dynamic>) {
        final repliesData = replies['data']?['children'];
        if (repliesData is List<dynamic>) {
          _flattenComments(repliesData, out);
        }
      }
    }
  }

  static CommentItem? _parseComment(
    Map<String, dynamic> json,
  ) {
    // "more"(더보기 placeholder) 등 실제 댓글(t1)이 아닌 노드는 건너뛴다.
    if (json['kind'] != 't1') return null;
    final data = json['data'] as Map<String, dynamic>;
    final rawBody = data['body_html'];
    final bodyHtml = rawBody is String ? unescapeHtml(rawBody) : '';
    final id = data['id'].toString();
    final likeCount = data['ups'].toString();
    final userId = data['author_fullname'].toString();
    final nickName = data['author'].toString();
    final double created = (data['created'] as num?)?.toDouble() ?? 0;
    final int depth = (data['depth'] as num?)?.toInt() ?? 0;

    final int milliseconds = (created * 1000).toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    final parsedTime = timeago.format(date, locale: 'ko');
    final info = BaseParser.parserInfo(parsedTime, '');

    return CommentItem(
      id: id.hashCode,
      isReply: depth > 0,
      bodyHtml: bodyHtml,
      likeCount: likeCount,
      mediaHtml: '',
      isVideo: false,
      time: created.toString(),
      info: info,
      userInfo: UserInfo(id: userId, nickName: nickName, nickImage: ''),
      authorId: '',
    );
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response<dynamic> response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType p1, List<int> p2) isReads,
  ) async {
    try {
      final items = await ParserIsolateClient.instance.parseList(
        siteType: siteType,
        responseData: response.data as Object,
        lastId: const LastId(intId: -1),
        boardTitle: boardTitle,
        baseUrl: baseUrl,
        isShowNickImage: false,
        isReads: isReads,
      );
      return Right(items);
    } catch (e) {
      return Left(GetListFailure(message: e.toString()));
    }
  }

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final dynamic json = message.responseData;
    final boardTitle = message.boardTitle;

    final list = json['data']['children'] as List<dynamic>?;

    if (list == null) {
      replyPort.send(List<ListItem>.empty());
      return;
    }


    final items = list
        .map((element) {
          final data = element['data'];
          if (data == null) return null;

          final double created = data['created'] as double;
          final int milliseconds = (created * 1000).toInt();
          final date = DateTime.fromMillisecondsSinceEpoch(milliseconds)
              .toLocal();
          final parsedTime = timeago.format(date, locale: 'ko');
          final hit = '';
          final nickName = data['author'].toString();
          final info = BaseParser.parserInfo(parsedTime, hit);
          final id = data['id'].toString();
          final title = data['title'].toString();
          final reply = data['num_comments'].toString();
          final userId = data['author_fullname'].toString();
          final board = data['subreddit'].toString();
          // 홈 피드는 여러 커뮤니티 글이 섞이므로 커뮤니티 이름을 태그로 단다.
          // flair 가 없으면 null 이 와서 toString() 하면 "null" 태그가 붙는다.
          final category = boardTitle == homeTitle
              ? 'r/$board'
              : (data['link_flair_text'] as String?)?.trim() ?? '';

          return ListItem(
            id: id.hashCode,
            title: unescapeHtml(title),
            reply: reply,
            category: category,
            time: milliseconds.toString(),
            url: id,
            info: info,
            board: board,
            boardTitle: boardTitle,
            like: '',
            hit: hit,
            userInfo: UserInfo(id: userId, nickName: nickName, nickImage: ''),
            hasImage: false,
            isRead: false,
          );
        })
        .whereType<ListItem>()
        .toList();

    replyPort.send(items);
  }

  /// 구독 커뮤니티 Listing(`/subreddits/mine/subscriber.json`, kind=t5)을
  /// 게시판 목록으로 바꾼다. 이름순으로 정렬한다.
  @override
  Future<Either<Failure, List<MainItem>>> main(
    Response<dynamic> response,
  ) async {
    final dynamic json = response.data;
    final dynamic data = json is Map ? json['data'] : null;
    final dynamic children = data is Map ? data['children'] : null;
    if (children is! List) {
      return const Left(GetMainFailure(message: '구독 커뮤니티 응답 형식이 달라요.'));
    }

    final List<Map<String, dynamic>> subs = [
      for (final child in children)
        if (child is Map && child['kind'] == 't5' && child['data'] is Map)
          child['data'] as Map<String, dynamic>,
    ];
    subs.sort(
      (a, b) => a['display_name'].toString().toLowerCase().compareTo(
        b['display_name'].toString().toLowerCase(),
      ),
    );

    var orderBy = 0;
    final List<MainItem> result = [
      for (final sub in subs)
        MainItem(
          siteType: SiteType.reddit,
          orderBy: orderBy++,
          url: 'https://www.reddit.com/${sub['display_name_prefixed']}',
          // urlByList 가 경로(r/xxx)로 쓰는 text 와 같은 값. board_link.json 시절
          // 키(FlutterDev)와 달라도 담아 둔 게시판은 DB 에 그대로 남아 동작한다.
          board: sub['display_name_prefixed'].toString(),
          text: sub['display_name_prefixed'].toString(),
          icon: _iconOf(sub),
        ),
    ];

    MoclLogger.d(() => '[main] subscribed=${result.length}');
    return Right(result);
  }

  /// 커뮤니티 아이콘. community_icon 이 우선이고 없으면 icon_img.
  /// community_icon 은 쿼리의 `&` 가 `&amp;` 로 이스케이프되어 온다.
  static String _iconOf(Map<String, dynamic> sub) {
    for (final key in ['community_icon', 'icon_img']) {
      final value = sub[key];
      if (value is String && value.isNotEmpty) {
        return unescapeHtml(value);
      }
    }
    return '';
  }

  @override
  SiteType get siteType => SiteType.reddit;

  @override
  String urlByDetail(String url, String board, int id) =>
      '$_apiUrl/r/$board/comments/$url?limit=500';

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final bool home = board == homeTitle;
    // 홈 추천은 웹 첫 화면과 같은 개인화 피드(best). hot 은 전체 인기글이 섞인다.
    final sort = home && sortType == SortType.recommend
        ? 'best'
        : sortType.toQuery(siteType);
    final extra = page > 1 ? '&after=t3_${lastId.stringId}' : '';
    // 홈은 커뮤니티 경로 없이 첫 화면 피드를 받는다(로그인 쿠키로 개인화).
    final path = home ? '' : '/$board';
    return '$_apiUrl$path/$sort?limit=25$extra';
  }

  @override
  String urlByMain() => '$_apiUrl/subreddits/mine/subscriber?limit=100';

  /// 데이터는 api.reddit.com 에서 받는다. www.reddit.com 은 정렬을 경로에 넣은
  /// `.json`(`/new/.json` · `/r/x/hot/.json`)을 로그인해도 403 으로 막는다.
  /// 같은 `.reddit.com` 로그인 쿠키로 응답 형식도 같다.
  static const String _apiUrl = 'https://api.reddit.com';

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) => url;
}
