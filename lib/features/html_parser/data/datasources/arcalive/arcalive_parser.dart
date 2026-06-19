import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

/// 아카라이브(arca.live) 파서.
///
/// 리스트 URL: `/b/{channel}` (예: `/b/live` 베스트), 페이지 `?p=N`.
/// 상세 URL: `/b/{channel}/{id}`. 본문/댓글 단일 응답에 포함.
/// 주의: 아카라이브 글 보기는 Cloudflare 로 보호되어 데이터센터 IP 의 단순
/// 요청은 403 이 날 수 있다(실기기/주거 IP 에서는 통과되는 경우가 많음).
class ArcaliveParser extends BaseParser {
  const ArcaliveParser();

  @override
  SiteType get siteType => SiteType.arcalive;

  @override
  String get baseUrl => 'https://arca.live';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://arca.live/';

  // 운영/종합 성격 채널(게임 채널과 구분).
  static const Set<String> _generalChannels = {
    'live', 'hotdeal', 'headline', 'breaking', 'replay', 'notice',
    'whyiblocked', 'stock', 'baseball', 'rogersfu',
  };

  /// 아카라이브 홈에 노출되는 채널 링크(`/b/{slug}`)를 파싱한다.
  /// (Cloudflare 때문에 [ArcaliveApi] 가 헤드리스 웹뷰로 렌더한 HTML 을 넘긴다.)
  @override
  Future<Either<Failure, List<MainItem>>> main(Response<dynamic> response) {
    final responseData = response.data as String;
    return Isolate.run(() => _parseMain(responseData));
  }

  static Either<Failure, List<MainItem>> _parseMain(String responseData) {
    final document = parse(responseData);
    final items = <MainItem>[];
    final seen = <String>{};
    var orderBy = 0;
    for (final a in document.querySelectorAll('a[href^="/b/"]')) {
      final match = RegExp(
        r'^/b/([a-zA-Z0-9_]+)',
      ).firstMatch(a.attributes['href'] ?? '');
      if (match == null) continue;
      final board = match.group(1)!;
      if (!seen.add(board)) continue;
      var name = a.text.trim();
      if (name.isEmpty || name.length > 24) continue;
      name = name.replaceAll(RegExp(r'\s*채널$'), '');
      items.add(
        MainItem(
          siteType: SiteType.arcalive,
          board: board,
          text: name,
          url: 'https://arca.live/b/$board',
          orderBy: orderBy++,
          category: _generalChannels.contains(board) ? '종합' : '채널',
        ),
      );
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '채널 목록을 찾지 못했습니다.'));
    }
    return Right(items);
  }

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final String separator = url.contains('?') ? '&' : '?';
    return '$url${separator}p=$page';
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    final String ch = board.isNotEmpty ? board : 'live';
    return 'https://arca.live/b/$ch?target=all&keyword=$keyword&p=$page';
  }

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

  static final RegExp _readPath = RegExp(r'/b/([^/?#]+)/(\d+)');

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final rows = document.querySelectorAll('.vrow');

    final items = <ListItem>[];
    final seen = <int>{};

    for (final row in rows) {
      final cls = row.className;
      if (cls.contains('head') || cls.contains('notice')) continue;

      // .vrow 자체가 앵커(<a class="vrow column" href="/b/{board}/{id}">).
      // 구버전 레이아웃(a.title) 도 폴백으로 지원.
      final href =
          (row.attributes['href'] ??
                  row.querySelector('a.title')?.attributes['href'])
              ?.trim();
      if (href == null) continue;
      final match = _readPath.firstMatch(href);
      if (match == null) continue;
      final String board = match.group(1) ?? '';
      final int id = int.tryParse(match.group(2) ?? '') ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      if (!seen.add(id)) continue;
      final url = href.startsWith('http') ? href : '$baseUrl$href';

      // 제목: 현재 레이아웃은 `.col-title .title`(span), 구버전은 `a.title`.
      // (광고 행은 `<b id="textad">` 뿐이라 제목 요소가 없어 스킵된다.)
      final titleEl =
          row.querySelector('.col-title .title') ??
          row.querySelector('a.title');
      if (titleEl == null) continue;
      final String reply = titleEl
          .qText('.comment-count')
          .replaceAll(RegExp(r'[\[\]]'), '')
          .trim();
      // 미디어 아이콘/댓글수/뱃지 span 제거 후 순수 텍스트.
      final String title = _titleText(titleEl);
      if (title.isEmpty) continue;

      final authorEl = row.querySelector('.col-author .user-info');
      final String nickName =
          authorEl?.querySelector('[data-filter]')?.attributes['data-filter'] ??
          authorEl?.text.trim() ??
          '';
      final timeEl = row.querySelector('.col-time time');
      final String time =
          timeEl?.attributes['datetime'] ?? timeEl?.text.trim() ?? '';
      final String hit = row.qText('.col-view');
      final String like = row.qText('.col-rate');

      final String parsedTime = formatTimeago(time);
      final String info = BaseParser.parserInfo(false, nickName, parsedTime, hit);

      items.add(
        ListItem(
          id: id,
          title: title,
          reply: reply,
          category: '',
          time: time,
          info: info,
          url: url,
          board: board,
          boardTitle: boardTitle,
          like: like,
          hit: hit,
          userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
          hasImage: row.querySelector('.vrow-preview, .title.preview-image') !=
              null,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  /// 제목 앵커에서 자식 span(아이콘/댓글수/뱃지)을 빼고 순수 텍스트만.
  static String _titleText(Element el) {
    final clone = el.clone(true);
    clone
        .querySelectorAll('span, img, svg, time, i')
        .forEach((e) => e.remove());
    return clone.text.trim();
  }

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as String;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(String responseData) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
    final titleEl = document.querySelector('.article-head .title');
    if (titleEl == null) {
      return Left(GetDetailFailure(message: 'title is null'));
    }
    final category = titleEl.querySelector('.badge')?.text.trim() ?? '';
    final title = _titleText(titleEl);

    final nickName =
        document
            .querySelector('.article-wrapper .member-info .user-info a')
            ?.text
            .trim() ??
        '';

    // .article-info 의 head/body 쌍에서 추천/조회수/작성일 추출.
    var viewCount = '';
    var likeCount = '';
    var time = '';
    final info = document.querySelector('.article-info-section');
    if (info != null) {
      final children = info.children;
      for (var i = 0; i < children.length; i++) {
        final el = children[i];
        if (!el.classes.contains('head')) continue;
        final label = el.text.trim();
        final next = i + 1 < children.length ? children[i + 1] : null;
        final value = next?.text.trim() ?? '';
        if (label == '추천') likeCount = value;
        if (label == '조회수') viewCount = value;
      }
      time =
          info.querySelector('.date time')?.attributes['datetime'] ??
          info.querySelector('.date time')?.text.trim() ??
          '';
    }

    final bodyEl = document.querySelector('.fr-view.article-content') ??
        document.querySelector('.article-body');
    bodyEl.removeAll('script, style, ins, iframe');
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final infoStr = BaseParser.parserInfo(
      false,
      nickName,
      parsedTime,
      viewCount,
    );

    final comments = <CommentItem>[];
    for (final el in document.querySelectorAll('.comment-item')) {
      final bool isReply = _hasCommentAncestor(el);
      final cNick =
          el.querySelector('.info-row .user-info a')?.text.trim() ?? '';
      final msgEl = el.querySelector('.message');
      msgEl.removeAll('script, button');
      final cBody = msgEl?.innerHtml.trim() ?? '';
      if (cBody.isEmpty && cNick.isEmpty) continue;
      final timeEl = el.querySelector('.info-row .right time');
      final cTime =
          timeEl?.attributes['datetime'] ?? timeEl?.text.trim() ?? '';
      final int cId =
          int.tryParse((el.id).replaceAll(RegExp(r'[^0-9]'), '')) ??
          comments.length;
      final cParsedTime = formatTimeago(cTime);
      final cInfo = cNick.isNotEmpty ? '$cNickㆍ$cParsedTime' : cParsedTime;

      comments.add(
        CommentItem(
          id: cId,
          isReply: isReply,
          bodyHtml: cBody,
          likeCount: '',
          mediaHtml: '',
          isVideo: false,
          info: cInfo,
          time: cTime,
          userInfo: UserInfo(id: cNick, nickName: cNick, nickImage: ''),
          authorId: '',
        ),
      );
    }

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time,
      info: infoStr,
      userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
      extraData: {'category': category},
    );

    return Right<Failure, Details>(detail);
  }

  /// 댓글이 다른 comment-item 안에 중첩돼 있으면 대댓글로 본다.
  static bool _hasCommentAncestor(Element el) {
    Element? p = el.parent;
    while (p != null) {
      if (p.classes.contains('comment-item')) return true;
      p = p.parent;
    }
    return false;
  }
}
