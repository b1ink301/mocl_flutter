import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
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

/// 뽐뿌(m.ppomppu.co.kr) 파서.
///
/// 핫딜 게시판(썸네일 레이아웃, `a.list_b_01n`) 과 일반 텍스트 게시판
/// (`li.hybrid-skin-li > a.noeffect`) 의 리스트 구조가 다르므로 두 레이아웃을
/// 모두 클래스 기반 셀렉터로 흡수한다. 본문/댓글은 단일 응답에 포함된다.
///
/// 뽐뿌는 EUC-KR(CP949) 인코딩이라 디코딩은 [PpomppuApi] 에서 수행하고
/// 파서에는 이미 UTF-8 String 으로 전달된다.
class PpomppuParser extends BaseParser {
  const PpomppuParser();

  @override
  SiteType get siteType => SiteType.ppomppu;

  @override
  String get baseUrl => 'https://m.ppomppu.co.kr';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://www.ppomppu.co.kr/';

  /// PC 홈(JS 렌더)의 게시판 링크(`?id={board}`)를 파싱해 모바일 게시판 URL 로
  /// 변환한다. ([PpomppuApi] 가 헤드리스 웹뷰로 렌더한 UTF-8 HTML 을 넘긴다.)
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
    for (final a in document.querySelectorAll('a[href*="id="]')) {
      final match = RegExp(
        r'[?&]id=([a-zA-Z0-9_]+)',
      ).firstMatch(a.attributes['href'] ?? '');
      if (match == null) continue;
      final board = match.group(1)!;
      if (!seen.add(board)) continue;
      final name = a.text.trim();
      if (name.isEmpty || name.length > 20) continue;
      items.add(
        MainItem(
          siteType: SiteType.ppomppu,
          board: board,
          text: name,
          url: 'https://m.ppomppu.co.kr/new/bbs_list.php?id=$board',
          orderBy: orderBy++,
        ),
      );
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '게시판 목록을 찾지 못했습니다.'));
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
    return '$url${separator}page=$page';
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    final String id = board.isNotEmpty ? board : 'ppomppu';
    return 'https://m.ppomppu.co.kr/new/search_result.php'
        '?id=$id&page=$page&search_type=sub_memo&keyword=$keyword';
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

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final anchors = document.querySelectorAll(
      'a.list_b_01n, li.hybrid-skin-li > a.noeffect',
    );

    final items = <ListItem>[];

    for (final anchor in anchors) {
      final href = anchor.attributes['href']?.trim();
      if (href == null || !href.contains('bbs_view.php')) continue;
      final url = href.toUrl(baseUrl);

      final String board = _queryParam(url, 'id');
      if (board.isEmpty || board == 'sponsor') continue;
      final int id = int.tryParse(_queryParam(url, 'no')) ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;

      // 제목: 핫딜은 span.cont, 텍스트 게시판은 div.thumb_sec > strong.
      final titleEl =
          anchor.querySelector('span.cont') ??
          anchor.querySelector('div.thumb_sec > strong');
      if (titleEl == null) continue;

      final String reply = anchor.qText('span.rp');

      // 카테고리: 핫딜은 span.subject_preface, 텍스트는 span.names 의 [..] 접두.
      var category = titleEl.qText('span.subject_preface');
      final String namesRaw = anchor.qText('span.names, li.names');
      String nickName = namesRaw;
      final bracket = RegExp(r'^\[([^\]]*)\]\s*(.*)$').firstMatch(namesRaw);
      if (bracket != null) {
        if (category.isEmpty) category = bracket.group(1)?.trim() ?? '';
        nickName = bracket.group(2)?.trim() ?? namesRaw;
      }
      category = category.replaceAll(RegExp(r'[\[\]]'), '').trim();
      if (category == '공지') continue;

      // 제목 텍스트만 남기고 카테고리/댓글수/아이콘 제거.
      titleEl.removeAll('span, img, i');
      final String title = titleEl.text.trim();
      if (title.isEmpty) continue;

      final hitEl = anchor.querySelector('span.view');
      hitEl.removeAll('img');
      final String hit = hitEl?.text.trim() ?? '';

      final likeEl = anchor.querySelector('span.recs');
      likeEl.removeAll('img');
      final String like = likeEl?.text.trim() ?? '';

      final String time = anchor.qText('time');
      final bool hasImage =
          anchor.querySelector('img.thumb_img, span.thumb_img, div.thmb_N') !=
          null;

      final String parsedTime = formatTimeago(time);
      final String info = BaseParser.parserInfo(
        false,
        nickName,
        parsedTime,
        hit,
      );

      items.add(
        ListItem(
          id: id,
          title: title,
          reply: reply,
          category: category,
          time: time,
          info: info,
          url: url,
          board: board,
          boardTitle: boardTitle,
          like: like,
          hit: hit,
          userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
          hasImage: hasImage,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as String;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(String responseData) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
    final container = document.querySelector('div.bbs.view');
    if (container == null) {
      return Left(GetDetailFailure(message: 'container is null'));
    }

    // 메타는 div.info 를 제거하기 전에 먼저 읽는다.
    final nickName = container.qText('span.ct a');
    final time = container.qText('span.hi');
    final infoText = container.querySelector('div.info')?.text ?? '';
    final viewMatch = RegExp(r'조회\s*:\s*([\d,]+)').firstMatch(infoText);
    final viewCount = viewMatch?.group(1) ?? '';

    final h4 = container.querySelector('h4');
    h4.removeAll('div.info, script, select, span, img');
    final title = h4?.text.trim() ?? '';

    final bodyEl = container.querySelector('#KH_Content');
    bodyEl.removeAll('script, input, button');
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final comments = <CommentItem>[];
    var index = 0;
    for (final element in container.querySelectorAll('div.sect-cmt')) {
      final depth = element.attributes['data-depth'] ?? '0';
      final bool isReply = depth != '0';

      final cNick = element.qText('h6.com_name span.com_name_writer');
      final memoEl =
          element.querySelector('div.comment_memo table.content td') ??
          element.querySelector('div.comment_memo');
      final cBody = (memoEl?.innerHtml ?? '').trim();
      if (cBody.isEmpty && cNick.isEmpty) continue;

      final cTime = element.qText('div.cin_02 time');
      final cLike = element.qText('span[id^=vote_cnt_]');
      final int cId =
          int.tryParse(element.attributes['data-cno'] ?? '') ?? index;
      index++;

      final cParsedTime = formatTimeago(cTime);
      final cInfo = cNick.isNotEmpty ? '$cNickㆍ$cParsedTime' : cParsedTime;

      comments.add(
        CommentItem(
          id: cId,
          isReply: isReply,
          bodyHtml: cBody,
          likeCount: cLike,
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
      likeCount: '',
      csrf: '',
      time: time,
      info: info,
      userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }

  /// URL 쿼리스트링에서 [key] 값 추출.
  static String _queryParam(String url, String key) {
    final q = url.contains('?') ? url.split('?').last : '';
    for (final pair in q.split('&')) {
      final kv = pair.split('=');
      if (kv.length == 2 && kv[0] == key) return kv[1];
    }
    return '';
  }
}
