import 'dart:async';
import 'dart:convert';
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
import 'package:mocl_flutter/core/util/mocl_logger.dart';
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
class const PpomppuParser() extends BaseParser {
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
      final match = RegExp(r'[?&]id=([a-zA-Z0-9_]+)')
          .firstMatch(a.attributes['href'] ?? '');
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
    final info = BaseParser.parserInfo(parsedTime, viewCount);

    // 2026년 개편 이후 코멘트는 서버가 DOM 으로 내려주지 않는다. 먼저 JSON 을
    // 읽고, 못 찾았을 때만 예전 DOM 구조로 폴백한다.
    final comments = _parseJsonComments(responseData);
    if (comments.isEmpty) {
      comments.addAll(_parseDomComments(container));
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

  // ──────────────────────────────────────────────────────────────────
  // 코멘트
  // ──────────────────────────────────────────────────────────────────

  /// 상세 HTML 에 인라인으로 박혀 있는 코멘트 JSON 의 시작 지점.
  ///
  /// 뽐뿌는 2026년 개편으로 코멘트를 서버 렌더링에서 클라이언트 렌더링으로
  /// 바꿨다. `<div id="cmList">` 는 빈 채로 오고, 실제 데이터는
  /// `var initialCommentData = {...};` 에 담겨 `board_comment.js` 가 그린다.
  /// 앱에는 그 스크립트가 없어 예전 `div.sect-cmt` 셀렉터가 0건이 됐고,
  /// 상세 화면에 코멘트가 통째로 사라졌다.
  static const String _kCommentDataMarker = 'var initialCommentData';

  /// [marker] 뒤 첫 `{` 부터 짝이 맞는 `}` 까지를 잘라낸다.
  ///
  /// 코멘트 본문에 `};` 가 들어갈 수 있어 정규식으로는 안전하게 못 자른다.
  /// 문자열 리터럴과 이스케이프를 구분하며 중괄호 깊이를 센다.
  static String? _extractJsonObject(String source, String marker) {
    final markerIndex = source.indexOf(marker);
    if (markerIndex < 0) return null;
    final start = source.indexOf('{', markerIndex);
    if (start < 0) return null;

    var depth = 0;
    var inString = false;
    var escaped = false;

    for (var i = start; i < source.length; i++) {
      final ch = source[i];
      if (inString) {
        if (escaped) {
          escaped = false;
        } else if (ch == r'\') {
          escaped = true;
        } else if (ch == '"') {
          inString = false;
        }
        continue;
      }
      switch (ch) {
        case '"':
          inString = true;
        case '{':
          depth++;
        case '}':
          depth--;
          if (depth == 0) return source.substring(start, i + 1);
      }
    }
    return null;
  }

  /// `name` / `image` 처럼 HTML 조각으로 오는 값에서 글자만 뽑는다.
  static String _htmlText(String html) =>
      html.isEmpty ? '' : parseFragment(html).text?.trim() ?? '';

  static List<CommentItem> _parseJsonComments(String responseData) {
    final raw = _extractJsonObject(responseData, _kCommentDataMarker);
    if (raw == null) return <CommentItem>[];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return <CommentItem>[];
      final rawComments = decoded['comments'];
      if (rawComments is! List) return <CommentItem>[];

      // 게시판 설정에 따라 서버가 최신순(sort_desc)으로 내려주기도 하므로,
      // 앱에서는 항상 작성순으로 맞추고 답글을 부모 밑에 붙인다.
      final nodes = <int, _CommentNode>{};
      final order = <int>[];
      for (final raw in rawComments) {
        if (raw is! Map) continue;
        final node = _CommentNode.fromJson(raw, fallbackId: order.length);
        if (node == null) continue;
        nodes[node.id] = node;
        order.add(node.id);
      }
      if (nodes.isEmpty) return <CommentItem>[];

      final childIds = <int, List<int>>{};
      final rootIds = <int>[];
      for (final id in order) {
        final parent = nodes[id]!.parentId;
        if (parent != 0 && parent != id && nodes.containsKey(parent)) {
          childIds.putIfAbsent(parent, () => <int>[]).add(id);
        } else {
          rootIds.add(id);
        }
      }

      final comments = <CommentItem>[];
      void append(int id, bool isReply) {
        comments.add(nodes[id]!.toCommentItem(isReply: isReply));
        final children = childIds[id];
        if (children == null) return;
        children.sort();
        for (final childId in children) {
          append(childId, true);
        }
      }

      rootIds.sort();
      for (final id in rootIds) {
        append(id, nodes[id]!.depth > 0);
      }
      return comments;
    } catch (e, st) {
      MoclLogger.e('[PpomppuParser] 코멘트 JSON 파싱 실패', error: e, stackTrace: st);
      return <CommentItem>[];
    }
  }

  /// 개편 전(서버 렌더링) 구조용 폴백.
  static List<CommentItem> _parseDomComments(Element container) {
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

      comments.add(
        CommentItem(
          id: cId,
          isReply: isReply,
          bodyHtml: cBody,
          likeCount: cLike,
          mediaHtml: '',
          isVideo: false,
          info: formatTimeago(cTime),
          time: cTime,
          userInfo: UserInfo(id: cNick, nickName: cNick, nickImage: ''),
          authorId: '',
        ),
      );
    }
    return comments;
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

/// `initialCommentData.comments[]` 한 건. 트리 정렬 뒤 [CommentItem] 으로 바꾼다.
class const _CommentNode({
  required final int id,
  required final int parentId,
  required final int depth,
  required final String nickName,
  required final String bodyHtml,
  required final String time,
  required final String likeCount,
}) {
  static int _asInt(dynamic value) => switch (value) {
    final int v => v,
    final String v => int.tryParse(v) ?? 0,
    _ => 0,
  };

  static _CommentNode? fromJson(
    Map<dynamic, dynamic> json, {
    required int fallbackId,
  }) {
    final meta = json['meta'];
    final blockStatus = json['block_status'];
    final voteBtn = json['vote_btn'];

    final String nickName = PpomppuParser._htmlText(
      (json['name'] ?? '').toString(),
    );
    String bodyHtml = (json['memo'] ?? '').toString().trim();

    // 차단/신고된 코멘트는 memo 가 비고 안내 문구만 온다. 웹과 같은 자리를
    // 남겨야 답글 구조가 어긋나지 않는다.
    if (bodyHtml.isEmpty && blockStatus is Map) {
      final String message = (blockStatus['block_message'] ?? '').toString();
      if (message.isNotEmpty) bodyHtml = message;
    }
    if (bodyHtml.isEmpty && nickName.isEmpty) return null;

    final int id = _asInt(json['no']);
    final int voteCount = voteBtn is Map ? _asInt(voteBtn['vote_count']) : 0;
    final String time = meta is Map
        ? (meta['time_display'] ?? '').toString()
        : '';

    return _CommentNode(
      id: id != 0 ? id : fallbackId,
      parentId: _asInt(json['parent']),
      depth: _asInt(json['depth']),
      nickName: nickName,
      bodyHtml: bodyHtml,
      time: time,
      likeCount: voteCount > 0 ? voteCount.toString() : '',
    );
  }

  CommentItem toCommentItem({required bool isReply}) => CommentItem(
    id: id,
    isReply: isReply,
    bodyHtml: bodyHtml,
    likeCount: likeCount,
    mediaHtml: '',
    isVideo: false,
    info: formatTimeago(time),
    time: time,
    userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
    authorId: '',
  );
}
