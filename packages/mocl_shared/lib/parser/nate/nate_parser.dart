import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_comment_item.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_shared/error/failures.dart';
import 'package:mocl_shared/parser/base/base_ext.dart';
import 'package:mocl_shared/parser/base/parser_isolate_client.dart';
import 'package:mocl_shared/parser/base/parser_isolate_message.dart';

import '../base/base_parser.dart';

/// 네이트판(pann.nate.com) 파서.
///
/// 리스트는 실시간 인기톡 랭킹(`/talk/ranking`)을 사용한다. 랭킹은 고정 top-N
/// 목록이라 페이지네이션이 없으므로 단일 페이지 게시판으로 처리한다
/// (list_providers 의 _isSinglePageBoard 참고).
/// 상세 URL: `/talk/{id}`. 본문 · 베스트 댓글은 글 페이지에, 전체 댓글은
/// `/talk/reply/view` 에 있다([urlByReplies]).
class const NateParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.nate;

  // 리스트/상세 모두 모바일(m.pann) 마크업 기준으로 파싱한다. 데스크톱(pann)은
  // 마크업이 다르고 today/talker 등 일부 게시판은 모바일에만 존재한다.
  @override
  String get baseUrl => 'https://m.pann.nate.com';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) => url; // 랭킹은 단일 페이지.

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) => 'https://pann.nate.com/search/talk?q=$keyword&page=$page';

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response<dynamic> response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    try {
      final items = await ParserIsolateClient.instance.parseList(
        siteType: siteType,
        responseData: response.data is String
            ? response.data as String
            : response.data.toString(),
        lastId: lastId,
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

  static final RegExp _idRe = RegExp(r'/talk/(\d+)');

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final items = <ListItem>[];
    final seen = <int>{};

    // 모바일(m.pann) 리스트 마크업: 항목마다
    //   <a class="cnbox" href="/talk/{id}...">
    //     <span class="thumb"><img></span>
    //     <span class="tit"><h2>제목</h2><span class="count">(3)</span></span>
    //     <span class="sub">조회 <span class="num">N</span> 추천 <span class="num">M</span></span>
    for (final a in document.querySelectorAll('a.cnbox')) {
      final href = a.attributes['href']?.trim() ?? '';
      final int id = int.tryParse(_idRe.firstMatch(href)?.group(1) ?? '') ?? 0;
      if (id <= 0 || !seen.add(id)) continue;

      // 게시판마다 tit/h2 중첩이 반대다:
      //   today  : <span class="tit"><h2>제목</h2><span class="count">(3)</span></span>
      //   ranking: <h2><span class="tit">제목</span></h2><span class="count">(211)</span>
      // span.tit 안에 h2 가 있으면 그 텍스트, 없으면 span.tit 텍스트를 쓴다.
      final String title =
          (a.querySelector('span.tit h2')?.text ?? a.qText('span.tit')).trim();
      if (title.isEmpty) continue;

      // 댓글수 span.count 는 tit 안/밖이 게시판마다 다르므로 anchor 기준 첫 항목.
      final String reply = a
          .qText('span.count')
          .replaceAll(RegExp(r'[^0-9]'), '');
      final nums = a
          .querySelectorAll('span.sub span.num')
          .map((e) => e.text.trim())
          .toList();
      final String hit = nums.isNotEmpty ? nums[0] : '';
      final String like = nums.length > 1 ? nums[1] : '';
      final String url = '$baseUrl/talk/$id';

      final String info = BaseParser.parserInfo('', hit);

      items.add(
        ListItem(
          id: id,
          title: title,
          reply: reply,
          category: '',
          time: '',
          info: info,
          url: url,
          board: 'ranking',
          boardTitle: boardTitle,
          like: like,
          hit: hit,
          userInfo: const UserInfo(id: '', nickName: '', nickImage: ''),
          hasImage: a.querySelector('span.thumb img') != null,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  /// [response] 의 data 는 글 HTML 문자열 또는 `[글 HTML, 댓글 HTML]`.
  ///
  /// 2026-11 개편 뒤 글 페이지는 베스트 댓글 3개만 주므로, 앱은 전체 댓글 페이지
  /// (`/talk/reply/view`, 옛 마크업 그대로)를 같이 받아 넘긴다([urlByReplies]).
  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final dynamic data = response.data;
    final String html;
    String replyHtml = '';
    if (data is List) {
      html = data.isNotEmpty ? '${data[0] ?? ''}' : '';
      replyHtml = data.length > 1 ? '${data[1] ?? ''}' : '';
    } else {
      html = data as String;
    }
    return Isolate.run(() => _parseDetail(html, replyHtml));
  }

  /// 글 [id] 의 전체 댓글(최신순) 페이지.
  static String urlByReplies(int id) =>
      'https://m.pann.nate.com/talk/reply/view?pann_id=$id&order=N&rankingType=total';

  static Either<Failure, Details> _parseDetail(String html, String replyHtml) {
    final document = parse(html);
    final Map<String, dynamic>? ld = _postingJsonLd(document);
    final header = document.querySelector('#talk-article');

    String ldString(Object? v) => v is String ? v.trim() : '';
    final Map<String, dynamic>? ldAuthor = ld?['author'] is Map
        ? ld!['author'] as Map<String, dynamic>
        : null;

    // 제목: 옛 화면 → 새 화면(h1) → 구조화 데이터 → og:title.
    String title = document.qText('h1.view-tit');
    if (title.isEmpty) title = header?.qText('h1') ?? '';
    if (title.isEmpty) title = ldString(ld?['headline']);
    if (title.isEmpty) {
      title =
          (document
                      .querySelector('meta[property="og:title"]')
                      ?.attributes['content'] ??
                  '')
              .replaceFirst(RegExp(r'\s*\|\s*네이트.*$'), '')
              .trim();
    }

    String nickName = document.qText('div.writer span.nick');
    if (nickName.isEmpty) nickName = ldString(ldAuthor?['name']);

    String likeCount = document
        .qText('div.updown div.btnbox.up span.count')
        .replaceAll(RegExp(r'[^0-9]'), '');
    if (likeCount.isEmpty) likeCount = _ldCount(ld, 'LikeAction');
    final String viewCount = _ldCount(ld, 'ViewAction');
    final String time = header?.qText('time') ?? '';

    // 본문: 옛 화면은 #pann-content, 새 화면은 헤더 바로 다음 칸의 첫 div.
    Element? bodyEl = document.querySelector('#pann-content');
    if (bodyEl == null) {
      final Element? next = header?.nextElementSibling;
      bodyEl = next?.children.where((e) => e.localName == 'div').firstOrNull;
    }
    bodyEl.removeAll('script, style, ins, iframe, .adv');
    String bodyHtml = bodyEl?.innerHtml.trim() ?? '';
    if (bodyHtml.isEmpty) {
      // 마크업을 못 찾으면 구조화 데이터의 글자만이라도 보여 준다.
      final String text = ldString(ld?['text']);
      if (text.isNotEmpty) {
        bodyHtml = text
            .split('\n')
            .map(
              (line) =>
                  '<p>${const HtmlEscape(HtmlEscapeMode.element).convert(line)}</p>',
            )
            .join();
      }
    }

    // 댓글: 전체 댓글 페이지 → (옛 화면이면) 글 페이지 → 구조화 데이터의 베스트 댓글.
    List<CommentItem> comments = replyHtml.isEmpty
        ? const []
        : _parseReplyList(parse(replyHtml));
    if (comments.isEmpty) comments = _parseReplyList(document);
    if (comments.isEmpty) comments = _ldComments(ld);

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time,
      info: BaseParser.parserInfo('', ''),
      userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }

  /// 옛 마크업 댓글(`div.reply-list dl`). 전체 댓글 페이지가 아직 이 형식이다.
  static List<CommentItem> _parseReplyList(Document document) {
    final comments = <CommentItem>[];
    var index = 0;
    for (final dl in document.querySelectorAll('div.reply-list dl')) {
      final dd = dl.querySelector('dd.userText');
      if (dd == null) continue;
      final dt = dl.querySelector('dt');

      String cNick = '';
      for (final s in dt?.querySelectorAll('span') ?? const <Element>[]) {
        if (!s.classes.contains('bar')) {
          cNick = s.text.trim();
          break;
        }
      }
      String cTime = '';
      for (final e in dt?.querySelectorAll('em') ?? const <Element>[]) {
        if (!e.classes.contains('best')) cTime = e.text.trim();
      }
      final bool isBest = dl.classes.contains('best');
      // 사진 댓글: `a.image > img` + "이미지확대보기" 글자. 글자만 읽으면 사진 대신
      // 버튼 문구가 나오므로 사진은 꺼내 img 로 붙이고 링크째 지운다.
      final List<String> images = [
        for (final img in dd.querySelectorAll('a.image img'))
          if ((img.attributes['src'] ?? '').startsWith('http'))
            img.attributes['src']!,
      ];
      dd.removeAll('script, button, a.image');
      final String text = dd.text.trim();
      if (text.isEmpty && images.isEmpty) continue;
      // 화면은 댓글을 HTML 로 그리므로 글자는 이스케이프한다.
      final String body = [
        if (text.isNotEmpty)
          const HtmlEscape(HtmlEscapeMode.element)
              .convert(text)
              .replaceAll(RegExp(r'\s*\n\s*'), '<br>'),
        for (final src in images)
          '<p><img src="${const HtmlEscape(HtmlEscapeMode.attribute).convert(src)}"></p>',
      ].join();

      comments.add(_comment(index++, cNick, cTime, body, isBest: isBest));
    }
    return comments;
  }

  /// 구조화 데이터의 `comment`(베스트 댓글). 글 페이지에는 이것만 온다.
  static List<CommentItem> _ldComments(Map<String, dynamic>? ld) {
    final raw = ld?['comment'];
    if (raw is! List) return const [];
    final comments = <CommentItem>[];
    var index = 0;
    for (final c in raw) {
      if (c is! Map) continue;
      final String body = (c['text'] as String? ?? '').trim();
      if (body.isEmpty) continue;
      final author = c['author'];
      final String nick = author is Map ? '${author['name'] ?? ''}'.trim() : '';
      comments.add(
        _comment(
          index++,
          nick,
          _ldTime(c['datePublished'] as String? ?? ''),
          const HtmlEscape(HtmlEscapeMode.element)
              .convert(body)
              .replaceAll(RegExp(r'\s*\n\s*'), '<br>'),
          isBest: true,
        ),
      );
    }
    return comments;
  }

  static CommentItem _comment(
    int id,
    String nick,
    String time,
    String body, {
    required bool isBest,
  }) => CommentItem(
    id: id,
    isReply: false,
    bodyHtml: body,
    likeCount: '',
    mediaHtml: '',
    isVideo: false,
    info: '${isBest ? '[베플] ' : ''}$time',
    time: time,
    userInfo: UserInfo(id: nick, nickName: nick, nickImage: ''),
    authorId: '',
  );

  /// `<script type="application/ld+json">` 의 `DiscussionForumPosting`.
  static Map<String, dynamic>? _postingJsonLd(Document document) {
    for (final script in document.querySelectorAll(
      'script[type="application/ld+json"]',
    )) {
      final Object? json;
      try {
        json = jsonDecode(script.text);
      } on FormatException {
        continue;
      }
      final List<Object?> nodes = switch (json) {
        {'@graph': final List<Object?> graph} => graph,
        final Map<String, dynamic> one => [one],
        final List<Object?> many => many,
        _ => const [],
      };
      for (final node in nodes) {
        if (node is Map<String, dynamic> &&
            node['@type'] == 'DiscussionForumPosting') {
          return node;
        }
      }
    }
    return null;
  }

  /// `interactionStatistic` 에서 [action](ViewAction · LikeAction) 횟수.
  static String _ldCount(Map<String, dynamic>? ld, String action) {
    final stats = ld?['interactionStatistic'];
    if (stats is! List) return '';
    for (final s in stats) {
      if (s is Map && '${s['interactionType']}'.endsWith('/$action')) {
        return '${s['userInteractionCount'] ?? ''}';
      }
    }
    return '';
  }

  /// `2026-11-05T10:28:36+09:00` → `11.05 10:28`(화면의 댓글 시각과 같은 모양).
  static String _ldTime(String iso) {
    final m = RegExp(r'^\d{4}-(\d{2})-(\d{2})T(\d{2}):(\d{2})').firstMatch(iso);
    return m == null ? '' : '${m[1]}.${m[2]} ${m[3]}:${m[4]}';
  }
}
