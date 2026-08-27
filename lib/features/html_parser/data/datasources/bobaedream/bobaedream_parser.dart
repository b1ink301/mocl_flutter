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

/// 보배드림(m.bobaedream.co.kr) 파서.
///
/// 리스트 URL: `/board/new_writing/{code}`, 페이지는 `?page=N`.
/// 상세 URL: `/board/bbs_view/{code}/{id}/2/1`. 본문/댓글은 단일 응답에 포함된다.
/// 게시판마다 메타(분류·닉·시간·조회·추천) 노출 항목이 달라 텍스트 패턴으로
/// 분류해 흡수한다.
class const BobaedreamParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.bobaedream;

  @override
  String get baseUrl => 'https://m.bobaedream.co.kr';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://m.bobaedream.co.kr/board/new_writing/best';

  /// 페이지 상단/사이드 네비게이션의 게시판 링크(`/board/new_writing/{code}`)를
  /// 파싱한다. 카테고리는 코드로 휴리스틱 분류(뉴스/스포츠/커뮤니티).
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
    for (final a in document.querySelectorAll(
      'a[href*="/board/new_writing/"]',
    )) {
      final href = a.attributes['href']?.trim() ?? '';
      final name = a.text.trim();
      if (name.isEmpty) continue;
      // 페이지네이션 링크("2","다음" 등)는 게시판이 아니므로 제외.
      if (RegExp(r'^\d+$').hasMatch(name) ||
          const ['처음', '이전', '다음', '끝', '맨끝'].contains(name)) {
        continue;
      }
      final url = href.startsWith('http')
          ? href
          : 'https://m.bobaedream.co.kr$href';

      final match = RegExp(r'/board/new_writing/([a-z]+)').firstMatch(href);
      if (match == null) continue;
      final code = match.group(1)!;
      // sports 는 info3 별로 구분되므로 board 를 info3 까지 포함해 유일화.
      final info3 = _queryParam(url, 'info3');
      final board = info3.isNotEmpty ? '${code}_$info3' : code;
      // board 기준 디듀프(상단/사이드 중복 메뉴, 페이지 링크 정리).
      if (!seen.add(board)) continue;

      items.add(
        MainItem(
          siteType: SiteType.bobaedream,
          board: board,
          text: name,
          url: url,
          orderBy: orderBy++,
          category: _category(code),
        ),
      );
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '게시판 메뉴를 찾지 못했습니다.'));
    }
    return Right(items);
  }

  static String _category(String code) {
    switch (code) {
      case 'best':
        return '베스트';
      case 'cnews':
      case 'nnews':
        return '뉴스';
      case 'sports':
        return '스포츠';
      default:
        return '커뮤니티';
    }
  }

  static String _queryParam(String url, String key) {
    final q = url.contains('?') ? url.split('?').last : '';
    for (final pair in q.split('&')) {
      final kv = pair.split('=');
      if (kv.length == 2 && kv[0] == key) return kv[1];
    }
    return '';
  }

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    // 모바일 보배드림은 `?page=N` 을 무시하고 경로 세그먼트로 페이지를 받는다.
    // 예: `/board/new_writing/freeb/2` (info3 등 쿼리는 그대로 보존).
    final Uri uri = Uri.parse(url);
    final List<String> segments = List<String>.from(uri.pathSegments);
    if (segments.isNotEmpty && int.tryParse(segments.last) != null) {
      segments[segments.length - 1] = '$page';
    } else {
      segments.add('$page');
    }
    return uri.replace(pathSegments: segments).toString();
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    final String code = board.isNotEmpty ? board : 'best';
    return 'https://m.bobaedream.co.kr/search'
        '?app=community&code=$code&keyword=$keyword&page=$page';
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

  static final RegExp _timeLike = RegExp(
    r'^\d{1,4}\s*[:.\-/]\s*\d{1,2}([:.\-/]\d{1,2})?$',
  );

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final rows = document.querySelectorAll('div.info');

    final items = <ListItem>[];
    final seen = <int>{};

    for (final row in rows) {
      final anchor = row.querySelector('a[href*="/board/bbs_view/"]');
      final href = anchor?.attributes['href']?.trim();
      if (anchor == null || href == null) continue;
      final url = href.toUrl(baseUrl);

      // /board/bbs_view/{code}/{id}/2/1
      final segs = url
          .split('?')
          .first
          .split('/')
          .where((e) => e.isNotEmpty)
          .toList();
      final idx = segs.indexOf('bbs_view');
      if (idx < 0 || idx + 2 >= segs.length) continue;
      final String board = segs[idx + 1];
      final int id = int.tryParse(segs[idx + 2]) ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      if (!seen.add(id)) continue;

      final String title = anchor.qText('span.cont');
      if (title.isEmpty) continue;
      final bool hasImage = anchor.querySelector('span.icon_img') != null;
      final String reply = row.qText('div.txt5 span.num');

      // 메타 블록 분류.
      var hit = '';
      var like = '';
      var time = '';
      final rest = <String>[];
      for (final block in anchor.querySelectorAll('div.txt2 span.block')) {
        final t = block.text.trim();
        if (t.isEmpty) continue;
        if (t.startsWith('조회')) {
          hit = t.replaceAll('조회', '').trim();
        } else if (t.startsWith('추천')) {
          like = t.replaceAll('추천', '').trim();
        } else if (_timeLike.hasMatch(t)) {
          time = t;
        } else {
          rest.add(t);
        }
      }
      String category = '';
      String nickName = '';
      if (rest.length >= 2) {
        category = rest[0];
        nickName = rest[1];
      } else if (rest.length == 1) {
        nickName = rest[0];
      }
      if (category == '공지') continue;

      final String parsedTime = formatTimeago(time);
      final String info = BaseParser.parserInfo(parsedTime, hit);

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
    final container = document.querySelector('article.article');
    if (container == null) {
      return Left(GetDetailFailure(message: 'container is null'));
    }

    final title = container.qText('header.article-tit h3.subject');
    final time = container.qText('header.article-tit div.util time');
    final viewCount = container
        .qText('header.article-tit div.util span.data4')
        .replaceAll('조회', '')
        .trim();
    final likeCount = container
        .qText('header.article-tit div.util span.data3')
        .replaceAll('추천', '')
        .trim();
    final nickName = container.qText(
      'header.article-tit div.util2 div.info span',
    );

    final bodyEl = container.querySelector('div.article-body');
    bodyEl.removeAll('script, style, input, button, textarea');
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(parsedTime, viewCount);

    // 댓글 영역(reple_body)은 article 바깥 형제에 위치하므로 문서 전체에서 조회.
    final comments = <CommentItem>[];
    var index = 0;
    for (final element in document.querySelectorAll('div.con_area')) {
      final replyEl = element.querySelector('div.reply');
      if (replyEl == null) continue;
      replyEl.removeAll('script, input, button');
      final cBody = replyEl.innerHtml.trim();

      final cNick = element.qText('div.util span.data4');
      final spans = element.querySelectorAll('div.util > span');
      var cTime = '';
      for (final s in spans) {
        final t = s.text.trim();
        if (s.classes.contains('data4')) continue;
        if (t.isNotEmpty && s.querySelector('a') == null) {
          cTime = t;
          break;
        }
      }
      final cLike = element.qText('div.util2 div.util3 button.good');

      final cParsedTime = formatTimeago(cTime);
      final cInfo = cParsedTime;

      comments.add(
        CommentItem(
          id: index++,
          isReply: false,
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
