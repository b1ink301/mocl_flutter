import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
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

/// 인벤(m.inven.co.kr) 파서.
///
/// 게시판 URL 형식: `/board/{slug}/{boardId}[/{articleId}]`, 페이지는 `?p=N`.
/// 댓글은 PwCMT 가 `comment.json.php` 로 비동기 로드하므로, [InvenApi] 가
/// 본문 HTML 과 댓글 JSON 을 함께 받아 `[html, json]` 리스트로 넘긴다.
class InvenParser extends BaseParser {
  const InvenParser();

  @override
  SiteType get siteType => SiteType.inven;

  @override
  String get baseUrl => 'https://m.inven.co.kr';

  @override
  String urlByDetail(String url, String board, int id) => url;

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
    final String id = board.isNotEmpty ? board : _boardId(url);
    return 'https://m.inven.co.kr/board/powerbbs.php'
        '?come_idx=$id&stype=subject&svalue=$keyword&p=$page';
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
    final elementList = document.querySelectorAll('li.list');

    final items = <ListItem>[];

    for (final element in elementList) {
      final anchor = element.querySelector('a.contentLink');
      final href = anchor?.attributes['href']?.trim();
      if (anchor == null || href == null || href.isEmpty) continue;
      final url = href.toUrl(baseUrl);

      final int id = _articleId(url);
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      final String board = _boardId(url);

      final String category = element.qText('span.in-cate');
      if (category == '공지') continue;

      final String title = element.qText('span.subject');
      if (title.isEmpty) continue;

      final String nickName = element.qText('span.nick span.layerNickName');
      final String hit = element
          .qText('span.view')
          .replaceAll('조회', '')
          .trim();
      final String time = element.qText('span.time');
      final String reply = element.qText('a.com-btn span.num');

      final bool hasImage =
          element.querySelector('span.icon_mt, .hasImage') != null;

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
          like: '',
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
    final dynamic data = response.data;
    return Isolate.run(() => _parseDetail(data));
  }

  static Either<Failure, Details> _parseDetail(dynamic responseData) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    // [html, commentJson] 또는 html String 단독 모두 지원.
    String html;
    Object? commentJson;
    if (responseData is List) {
      html = responseData.first as String;
      commentJson = responseData.length > 1 ? responseData[1] : null;
    } else {
      html = responseData as String;
    }

    final document = parse(html);
    final container = document.querySelector('section.mo-board-view') ??
        document.querySelector('#articleView');
    if (container == null) {
      return Left(GetDetailFailure(message: 'container is null'));
    }

    final subjectEl = container.querySelector('#articleSubject');
    final category = subjectEl.qText('span.in-cate');
    subjectEl.removeAll('span');
    final title = subjectEl?.text.trim() ?? '';

    final nickName = container.qText('#article-writer');
    final viewCount = container.qText('div.hit span');
    final time = container.qText('div.date');

    final bodyEl = container.querySelector('.articleContent');
    bodyEl.removeAll('script, input, button, .ad, .adArea');
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final comments = _parseComments(commentJson);

    final detail = Details(
      title: title.isNotEmpty ? title : category,
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

  /// comment.json.php 응답에서 댓글 목록을 파싱한다.
  /// 구조: `{ commentlist: [ { __attr__, list: [ {o_name,o_date,o_comment,
  /// o_recommend, __attr__:{cmtidx,cmtpidx}} ] } ] }`.
  /// `cmtpidx != cmtidx` 이면 대댓글.
  static List<CommentItem> _parseComments(Object? raw) {
    if (raw == null) return const <CommentItem>[];
    Map<String, dynamic>? json;
    if (raw is Map<String, dynamic>) {
      json = raw;
    } else if (raw is String && raw.trim().isNotEmpty) {
      try {
        json = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        return const <CommentItem>[];
      }
    }
    // commentlist 는 [{__attr__, list:[...]}] 형태(또는 {list:[...]}).
    final commentList = json?['commentlist'];
    Object? wrapper;
    if (commentList is List && commentList.isNotEmpty) {
      wrapper = commentList.first;
    } else if (commentList is Map) {
      wrapper = commentList;
    }
    final list = wrapper is Map ? wrapper['list'] : null;
    if (list is! List) return const <CommentItem>[];

    final comments = <CommentItem>[];
    for (final item in list) {
      if (item is! Map) continue;
      final attr = item['__attr__'];
      final int cmtidx = (attr is Map ? attr['cmtidx'] : null) as int? ?? 0;
      final int cmtpidx = (attr is Map ? attr['cmtpidx'] : null) as int? ?? cmtidx;
      final bool isReply = cmtpidx != cmtidx;

      final String nick = item['o_name']?.toString() ?? '';
      final String body = _unescapeOnce(item['o_comment']?.toString() ?? '');
      final String time = item['o_date']?.toString() ?? '';
      final String like = (item['o_recommend'] ?? '').toString();
      if (body.isEmpty && nick.isEmpty) continue;

      final String parsedTime = formatTimeago(time);
      final String info = nick.isNotEmpty ? '$nickㆍ$parsedTime' : parsedTime;

      comments.add(
        CommentItem(
          id: cmtidx,
          isReply: isReply,
          bodyHtml: body,
          likeCount: like == '0' ? '' : like,
          mediaHtml: '',
          isVideo: false,
          info: info,
          time: time,
          userInfo: UserInfo(id: nick, nickName: nick, nickImage: ''),
          authorId: '',
        ),
      );
    }
    return comments;
  }

  /// inven 댓글 본문은 엔티티가 한 번 더 이스케이프돼 있어(`&lt;a&gt;`,
  /// `&amp;nbsp;`) 한 단계만 디코딩하면 실제 HTML 이 된다.
  static String _unescapeOnce(String s) => s
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&');

  /// `/board/{slug}/{boardId}/{articleId}` 에서 articleId(마지막 숫자) 추출.
  static int _articleId(String url) {
    final path = url.split('?').first;
    final segs = path.split('/').where((e) => e.isNotEmpty).toList();
    return int.tryParse(segs.isNotEmpty ? segs.last : '') ?? 0;
  }

  /// `/board/{slug}/{boardId}/...` 에서 boardId 추출.
  static String _boardId(String url) {
    final match = RegExp(r'/board/[a-z0-9]+/(\d+)').firstMatch(url);
    return match?.group(1) ?? '';
  }
}
