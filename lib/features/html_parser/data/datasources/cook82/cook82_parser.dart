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

/// 82쿡(www.82cook.com) 파서.
///
/// 테이블 기반 리스트(`td.title`), 상세 본문 `#articleBody`,
/// 댓글 `ul.reples > li.rp` 가 모두 단일 응답에 포함된다.
/// 리스트의 글 링크는 `read.php?...` 상대경로라 `/entiz/` 기준으로 절대화한다.
class Cook82Parser extends BaseParser {
  const Cook82Parser();

  @override
  SiteType get siteType => SiteType.cook82;

  @override
  String get baseUrl => 'https://www.82cook.com';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://www.82cook.com/';

  /// 82쿡 홈의 주메뉴(`ul.menu > li`)를 카테고리(예: 리빙/푸드앤쿠킹/라이프/
  /// 커뮤니티) 단위로 파싱해 게시판 목록을 구성한다.
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
    for (final topLi in document.querySelectorAll('ul.menu > li')) {
      final catEl = topLi.querySelector('a.tmenu');
      if (catEl == null) continue;
      // a.tmenu = "<em>LIVING</em> 리빙" → em 제거 후 한글 라벨만.
      final catClone = catEl.clone(true);
      catClone.querySelectorAll('em').forEach((e) => e.remove());
      var category = catClone.text.trim();
      if (category.isEmpty) category = catEl.text.trim();

      for (final a in topLi.querySelectorAll('ul li a')) {
        // 카테고리 대표 링크(a.tmenu)는 게시판이 아니므로 제외
        // (첫 게시판과 bn 을 공유해 가려지는 것을 방지).
        if (a.className.contains('tmenu')) continue;
        final href = a.attributes['href'] ?? '';
        final bn = _queryParam(href, 'bn');
        if (bn.isEmpty || !seen.add(bn)) continue;
        final name = a.text.trim();
        if (name.isEmpty) continue;
        items.add(
          MainItem(
            siteType: SiteType.cook82,
            board: bn,
            text: name,
            url: 'https://www.82cook.com/entiz/enti.php?bn=$bn',
            orderBy: orderBy++,
            category: category,
          ),
        );
      }
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '게시판 메뉴를 찾지 못했습니다.'));
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
    final String bn = board.isNotEmpty ? board : '15';
    return 'https://www.82cook.com/entiz/enti.php'
        '?bn=$bn&page=$page&search_type=title&keyword=$keyword';
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
    final titleCells = document.querySelectorAll('td.title');

    final items = <ListItem>[];
    final seen = <int>{};

    for (final td in titleCells) {
      // 공지(a.bbs_title_word)·썸네일링크(a.photolink) 제외, 본문 제목 앵커만.
      final anchors = td.querySelectorAll('a');
      Element? anchor;
      for (final a in anchors) {
        final cls = a.className;
        final href = a.attributes['href'] ?? '';
        if (!href.contains('read.php')) continue;
        if (cls.contains('photolink') || cls.contains('bbs_title_word')) {
          continue;
        }
        anchor = a;
        break;
      }
      if (anchor == null) continue;

      final href = anchor.attributes['href']!.trim();
      final url = _absUrl(href, baseUrl);
      final int id = int.tryParse(_queryParam(url, 'num')) ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      if (!seen.add(id)) continue;
      final String board = _queryParam(url, 'bn');

      final String title = anchor.text.trim();
      if (title.isEmpty) continue;

      // 댓글 수는 제목 뒤 td.title > em (댓글 없으면 em 없음).
      final String reply = td.querySelector('em')?.text.trim() ?? '';

      final row = td.parent;
      final String nickName = row.qText('td.user_function');
      final regdateEl = row?.querySelector('td.regdate');
      final String time =
          (regdateEl?.attributes['title']?.trim().isNotEmpty ?? false)
          ? regdateEl!.attributes['title']!.trim()
          : (regdateEl?.text.trim() ?? '');
      final rowTds = row?.querySelectorAll('td') ?? const [];
      final String hit = rowTds.isNotEmpty ? rowTds.last.text.trim() : '';

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
          like: '',
          hit: hit,
          userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
          hasImage: td.querySelector('a.photolink') != null,
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

    final title = document.qText('h4.title.bbstitle span');

    final readLeft = document.querySelector('div.readLeft');
    final nickName = readLeft.qText('strong');
    final readLeftText = readLeft?.text ?? '';
    final viewCount =
        RegExp(r'조회수\s*:\s*([\d,]+)').firstMatch(readLeftText)?.group(1) ?? '';

    // 작성 시간: div.readRight "작성일 : 2026-06-15 23:38:47"
    final time =
        RegExp(r'\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}(:\d{2})?')
            .firstMatch(document.qText('div.readRight'))
            ?.group(0) ??
        '';

    final bodyEl = document.querySelector('#articleBody') ??
        document.querySelector('#content');
    bodyEl.removeAll('script, style, input, button, ins, iframe');
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final int totalComments =
        int.tryParse(document.qText('strong.total_reple')) ?? 0;

    final comments = <CommentItem>[];
    for (final li in document.querySelectorAll('ul.reples li.rp')) {
      final cNick = li.qText('h5 strong');
      final funcEl = li.querySelector('div.repleFunc');
      var cTime = '';
      final ems = funcEl?.querySelectorAll('em') ?? const [];
      for (final em in ems) {
        if (em.classes.contains('ip')) continue;
        cTime = em.text.trim();
        break;
      }
      final bodyP = li.querySelector('p');
      bodyP.removeAll('script, input, button');
      final cBody = bodyP?.innerHtml.trim() ?? '';
      if (cBody.isEmpty && cNick.isEmpty) continue;
      final int cId =
          int.tryParse(li.attributes['data-rn'] ?? '') ?? comments.length;

      comments.add(
        CommentItem(
          id: cId,
          isReply: false,
          bodyHtml: cBody,
          likeCount: '',
          mediaHtml: '',
          isVideo: false,
          info: cNick,
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
      extraData: {'totalComments': totalComments},
    );

    return Right<Failure, Details>(detail);
  }

  /// 82쿡 리스트 링크는 `read.php?...` 상대경로 → `/entiz/` 기준 절대 URL.
  static String _absUrl(String href, String baseUrl) {
    if (href.startsWith('http')) return href;
    if (href.startsWith('/')) return '$baseUrl$href';
    return '$baseUrl/entiz/$href';
  }

  static String _queryParam(String url, String key) {
    final q = url.contains('?') ? url.split('?').last : '';
    for (final pair in q.split('&')) {
      final kv = pair.split('=');
      if (kv.length == 2 && kv[0] == key) return kv[1];
    }
    return '';
  }
}
