import 'dart:async';
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
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';

import '../base/base_parser.dart';

/// 인스티즈(instiz.net) 파서.
///
/// 리스트 URL: `/pt`(일상·유머), 페이지는 `?page=N`(카테고리는 `?category=N`).
/// 상세 URL: `/pt/{id}`. 본문/댓글이 단일 GET 응답에 포함된다.
/// 상대 시각("14:58", "4시간 전")을 그대로 노출한다.
class InstizParser extends BaseParser {
  const InstizParser();

  @override
  SiteType get siteType => SiteType.instiz;

  @override
  String get baseUrl => 'https://www.instiz.net';

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
    final String separator = url.contains('?') ? '&' : '?';
    return '$url${separator}k=$keyword&page=$page';
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

  static final RegExp _idClassRe = RegExp(r'(?:^|\s)r(\d+)(?:\s|$)');
  static final RegExp _idHrefRe = RegExp(r'/pt/(\d+)');

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final items = <ListItem>[];
    final seen = <int>{};

    for (final td in document.querySelectorAll('td.listsubject')) {
      // 공지/베스트(green) 행 제외.
      if (td.querySelector('span.texthead_notice') != null) continue;

      final anchor = td.querySelector('a');
      final href = anchor?.attributes['href']?.trim();
      if (anchor == null || href == null) continue;

      int id = int.tryParse(_idClassRe.firstMatch(td.className)?.group(1) ?? '') ?? 0;
      if (id <= 0) {
        id = int.tryParse(_idHrefRe.firstMatch(href)?.group(1) ?? '') ?? 0;
      }
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      if (!seen.add(id)) continue;

      final url = href.split('?').first.toUrl(baseUrl);

      // 제목: div.sbj 에서 아이콘/댓글수 span 제거 후 텍스트.
      final sbj = td.querySelector('div.sbj') ?? anchor;
      final titleClone = sbj.clone(true);
      titleClone.querySelectorAll('i, span').forEach((e) => e.remove());
      final String title = titleClone.text.trim();
      if (title.isEmpty) continue;

      final String reply =
          td.querySelector('span.cmt2, span.cmt3')?.text.trim() ?? '';

      // 메타: "14:58 l 조회 2755" 형태.
      final String meta =
          td.querySelector('div.listno.regdate')?.text.trim() ?? '';
      final String time = meta.split(RegExp(r'\s*[l|]\s*')).first.trim();
      final hitMatch = RegExp(r'조회\s*([0-9,]+)').firstMatch(meta);
      final String hit = hitMatch?.group(1) ?? '';

      final String info = BaseParser.parserInfo(false, '', time, hit);

      items.add(
        ListItem(
          id: id,
          title: title,
          reply: reply,
          category: '',
          time: time,
          info: info,
          url: url,
          board: 'pt',
          boardTitle: boardTitle,
          like: '',
          hit: hit,
          userInfo: const UserInfo(id: '', nickName: '', nickImage: ''),
          hasImage: td.querySelector('i.fa-image') != null,
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
    final document = parse(responseData);

    final String title =
        document.querySelector('meta[property="og:title"]')?.attributes['content'] ??
        '';

    final bodyEl = document.querySelector('div.memo_content');
    bodyEl.removeAll('script, style, input, button, iframe');
    final String bodyHtml = bodyEl?.innerHtml ?? '';

    final comments = <CommentItem>[];
    var index = 0;
    for (final c in document.querySelectorAll('tr.cmt_view')) {
      final String cNick = c.qText('span.href');
      final lineEl = c.querySelector('div.comment_line');
      final String cTime = lineEl?.querySelector('span.minitext')?.text.trim() ?? '';
      final bodyClone = lineEl?.clone(true);
      bodyClone?.querySelectorAll('span.minitext, script, button').forEach(
        (e) => e.remove(),
      );
      final String cBody = bodyClone?.innerHtml.trim() ?? '';
      if (cBody.isEmpty && cNick.isEmpty) continue;

      final cInfo = cNick.isNotEmpty ? '$cNickㆍ$cTime' : cTime;

      comments.add(
        CommentItem(
          id: index++,
          isReply: false,
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

    final info = BaseParser.parserInfo(false, '', '', '');

    final detail = Details(
      title: title,
      viewCount: '',
      likeCount: '',
      csrf: '',
      time: '',
      info: info,
      userInfo: const UserInfo(id: '', nickName: '', nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }
}
