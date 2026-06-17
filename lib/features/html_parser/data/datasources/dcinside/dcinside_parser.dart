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

/// 디시인사이드 모바일(m.dcinside.com) 파서.
///
/// 리스트 URL: `/board/{gallery}` (실시간베스트 `dcbest` 포함), 페이지 `?page=N`.
/// 상세 URL: `/board/{gallery}/{no}`. 본문/댓글 모두 단일 응답에 포함되며
/// 본문 이미지는 lazy-load 라 `data-original` 을 `src` 로 치환한다.
class DcinsideParser extends BaseParser {
  const DcinsideParser();

  @override
  SiteType get siteType => SiteType.dcinside;

  @override
  String get baseUrl => 'https://m.dcinside.com';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://m.dcinside.com/galltotal';

  /// galltotal 은 전체 갤러리를 가나다(알파벳)순 `<a href="/board/{id}">이름</a>`
  /// 으로 나열한다. 초성으로 묶어 카테고리를 부여한다.
  @override
  Future<Either<Failure, List<MainItem>>> main(Response<dynamic> response) {
    final responseData = response.data as String;
    return Isolate.run(() => _parseMain(responseData));
  }

  static Either<Failure, List<MainItem>> _parseMain(String responseData) {
    final document = parse(responseData);
    final anchors = document.querySelectorAll('a[href*="/board/"]');
    final items = <MainItem>[];
    final seen = <String>{};
    var orderBy = 0;
    for (final a in anchors) {
      final href = a.attributes['href']?.trim() ?? '';
      final match = RegExp(r'/board/([a-zA-Z0-9_]+)/?$').firstMatch(
        href.split('?').first,
      );
      if (match == null) continue;
      final board = match.group(1)!;
      if (!seen.add(board)) continue;
      final name = a.text.trim();
      if (name.isEmpty) continue;

      items.add(
        MainItem(
          siteType: SiteType.dcinside,
          board: board,
          text: name,
          url: 'https://m.dcinside.com/board/$board',
          orderBy: orderBy++,
          category: _chosung(name),
        ),
      );
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '갤러리 목록을 찾지 못했습니다.'));
    }
    // 초성 카테고리로 묶어서 보이도록 정렬(같은 초성끼리 인접).
    items.sort((a, b) {
      final c = a.category.compareTo(b.category);
      return c != 0 ? c : a.text.compareTo(b.text);
    });
    return Right(items);
  }

  static const List<String> _chosungTable = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  /// 이름 첫 글자의 초성을 카테고리로. 한글 외(영문/숫자)는 '#/A-Z' 로.
  static String _chosung(String name) {
    final code = name.runes.first;
    if (code >= 0xAC00 && code <= 0xD7A3) {
      return _chosungTable[(code - 0xAC00) ~/ 588];
    }
    final ch = name[0].toUpperCase();
    return RegExp(r'[A-Z]').hasMatch(ch) ? ch : '#';
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
    final String gall = board.isNotEmpty ? board : 'dcbest';
    return 'https://m.dcinside.com/board/$gall'
        '?s_type=search_subject_memo&s_keyword=$keyword&page=$page';
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

  static final RegExp _readPath = RegExp(r'/board/([^/?#]+)/(\d+)');
  static final RegExp _timeLike = RegExp(r'^\d{1,2}[:.]\d{1,2}');

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final rows = document.querySelectorAll(
      'ul.gall-detail-lst > li > div.gall-detail-lnktb',
    );

    final items = <ListItem>[];
    for (final lnktb in rows) {
      final anchor = lnktb.querySelector('a.lt');
      final href = anchor?.attributes['href']?.trim();
      if (anchor == null || href == null) continue;
      final match = _readPath.firstMatch(href);
      if (match == null) continue;
      final String board = match.group(1) ?? '';
      final int id = int.tryParse(match.group(2) ?? '') ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      final url = href.startsWith('http') ? href : '$baseUrl$href';

      // 제목/카테고리: span.subjectin (앞에 <b>[갤]</b> 카테고리가 올 수 있음).
      final subjectEl = anchor.querySelector('span.subjectin');
      final category = subjectEl
          ?.querySelector('b')
          ?.text
          .replaceAll(RegExp(r'[\[\]]'), '')
          .trim() ??
          '';
      String title = subjectEl?.text.trim() ?? '';
      if (category.isNotEmpty && title.startsWith('[$category]')) {
        title = title.substring(category.length + 2).trim();
      }
      if (title.isEmpty) continue;

      // 작성자: blockInfo data-name/data-info 가 가장 깨끗하다.
      final blockInfo = lnktb.parent?.querySelector('span.blockInfo');
      final String nickName =
          blockInfo?.attributes['data-name']?.trim() ??
          (lnktb.querySelector('li.list-nick')?.text.trim() ?? '');
      final String userId = blockInfo?.attributes['data-info']?.trim() ?? '';

      // ginfo li 들을 내용 패턴으로 분류.
      var hit = '';
      var like = '';
      var time = '';
      for (final li in lnktb.querySelectorAll('ul.ginfo > li')) {
        final t = li.text.trim();
        if (t.startsWith('조회')) {
          hit = t.replaceAll('조회', '').trim();
        } else if (t.startsWith('추천')) {
          like = t.replaceAll('추천', '').trim();
        } else if (_timeLike.hasMatch(t)) {
          time = t;
        }
      }

      final String reply = lnktb.qText('a.rt span.ct');
      final bool hasImage = lnktb.querySelector('div.thum-img') != null;

      final String parsedTime = formatTimeago(time);
      final String info = BaseParser.parserInfo(false, nickName, parsedTime, hit);

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
          userInfo: UserInfo(id: userId, nickName: nickName, nickImage: ''),
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
    final titleBox = document.querySelector('div.gallview-tit-box');
    if (titleBox == null) {
      return Left(GetDetailFailure(message: 'title box is null'));
    }

    final titleEl = titleBox.querySelector('span.tit');
    titleEl.removeAll('button, span');
    final title = titleEl?.text.trim() ?? '';

    final nickName = titleBox.qText('ul.ginfo2 button.nick');
    var time = '';
    for (final li in titleBox.querySelectorAll('ul.ginfo2 > li')) {
      final t = li.text.trim();
      if (RegExp(r'\d{4}\.\d{2}\.\d{2}').hasMatch(t) ||
          RegExp(r'^\d{1,2}[.:]\d{1,2}').hasMatch(t)) {
        time = t;
        break;
      }
    }

    // 조회/추천/댓글수는 본문 상단 gall-thum-btm 의 ginfo2 에 있다.
    var viewCount = '';
    for (final li in document.querySelectorAll(
      'div.gall-thum-btm ul.ginfo2 > li',
    )) {
      final t = li.text.trim();
      if (t.startsWith('조회')) {
        viewCount = t.replaceAll(RegExp(r'조회수?'), '').trim();
        break;
      }
    }
    final likeCount = document
        .qText('div.gall-thum-btm li.up-add span')
        .trim();

    final bodyEl = document.querySelector('div.thum-txt div.thum-txtin') ??
        document.querySelector('div.thum-txt');
    bodyEl.removeAll('script, style, ins, iframe, .adv-inner');
    // lazy 이미지: data-original → src 치환.
    if (bodyEl != null) {
      for (final img in bodyEl.querySelectorAll('img')) {
        final orig = img.attributes['data-original'];
        if (orig != null && orig.isNotEmpty) {
          img.attributes['src'] = orig;
        }
      }
    }
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final comments = <CommentItem>[];
    for (final li in document.querySelectorAll('li.comment, li.comment-add')) {
      final bool isReply = li.className.contains('comment-add');
      final cNick = li.qText('div.ginfo-area button.nick');
      final bodyP = li.querySelector('p.txt');
      bodyP.removeAll('script, button');
      final cBody = bodyP?.innerHtml.trim() ?? '';
      if (cBody.isEmpty && cNick.isEmpty) continue;
      final cTime = li.qText('span.date');
      final int cId = int.tryParse(li.attributes['no'] ?? '') ?? comments.length;
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
      info: info,
      userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }
}
