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

/// MLBPARK(mlbpark.donga.com) 모바일 파서.
///
/// 리스트 URL: `/mp/b.php?b={board}`, 페이지는 `&p=N`.
/// 상세 URL: `/mp/b.php?id={id}&b={board}&m=view`. 본문은 정적 HTML 에 있으나
/// 댓글은 `&m=reply` 로 별도 로드되므로, API 가 본문+댓글 HTML 을 동시에 받아
/// `[html, replyHtml]` 로 파서에 넘긴다(인벤과 동일한 구조).
class const MlbparkParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.mlbpark;

  @override
  String get baseUrl => 'https://mlbpark.donga.com';

  @override
  String urlByDetail(String url, String board, int id) => url;

  /// 댓글 HTML(`m=reply`) 엔드포인트. API 에서 본문과 동시에 요청한다.
  String urlByReply(String board, int id) =>
      'https://mlbpark.donga.com/mp/b.php?b=$board&id=$id&m=reply';

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
    final String code = board.isNotEmpty ? board : 'bullpen';
    return 'https://mlbpark.donga.com/mp/b.php'
        '?m=search&b=$code&select=spf&query=$keyword&p=$page';
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

  static final RegExp _idRe = RegExp(r'[?&]id=(\d+)');
  static final RegExp _boardRe = RegExp(r'[?&]b=([a-zA-Z0-9_]+)');

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final items = <ListItem>[];
    final seen = <int>{};

    for (final row in document.querySelectorAll('li.items')) {
      // 실제 글 행만 a.txt 를 가진다(상단 베스트/랭킹 위젯은 제외).
      final anchor = row.querySelector('a.txt');
      final href = anchor?.attributes['href']?.trim();
      if (anchor == null || href == null) continue;

      final int id = int.tryParse(_idRe.firstMatch(href)?.group(1) ?? '') ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      if (!seen.add(id)) continue;

      final String board = _boardRe.firstMatch(href)?.group(1) ?? '';
      final String url = href.toUrl(baseUrl);

      final String title =
          anchor.querySelector('span.link_txt')?.text.trim() ??
          anchor.attributes['title']?.trim() ??
          anchor.text.trim();
      if (title.isEmpty) continue;

      final String category = row.qText('a.word');
      final String nickName = row.qText('span.nick');
      final String time = row.qText('span.date');
      final String hit = row.qText('span.hit');
      final String reply = row.qText('span.reply, span.cnt');

      final String info = BaseParser.parserInfo(time, hit);

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
          hasImage: row.querySelector('span.ico_img, img.thumb') != null,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final data = response.data as List<dynamic>;
    final String html = data.isNotEmpty ? data[0]?.toString() ?? '' : '';
    final String replyHtml = data.length > 1 ? data[1]?.toString() ?? '' : '';
    return Isolate.run(() => _parseDetail(html, replyHtml));
  }

  static Either<Failure, Details> _parseDetail(String html, String replyHtml) {
    final document = parse(html);

    final String rawTitle =
        document
            .querySelector('meta[property="og:title"]')
            ?.attributes['content'] ??
        document.qText('.tit');
    final String title = rawTitle
        .replaceFirst(RegExp(r'\s*:\s*MLBPARK.*$'), '')
        .trim();

    final bodyEl =
        document.querySelector('div.ar_txt#contentDetail') ??
        document.querySelector('div.ar_txt');
    bodyEl.removeAll('script, style, input, button, ins, iframe');
    final String bodyHtml = bodyEl?.innerHtml ?? '';

    final String nickName = document.qText('span.nick');
    final String time = document.qText('span.text, span.date');
    final String viewCount = document
        .qText('span.read, span.hit')
        .replaceAll(RegExp(r'[^0-9]'), '');

    final comments = <CommentItem>[];
    if (replyHtml.isNotEmpty) {
      final replyDoc = parse(replyHtml);
      for (final c in replyDoc.querySelectorAll('div.other_con')) {
        final cNick = c.qText('span.name');
        final cTime = c.qText('span.date');
        final bodyNode = c.querySelector('span.re_txt');
        bodyNode.removeAll('script, button');
        final cBody = bodyNode?.innerHtml.trim() ?? '';
        if (cBody.isEmpty && cNick.isEmpty) continue;

        final int cId =
            int.tryParse((c.id).replaceAll(RegExp(r'[^0-9]'), '')) ??
            comments.length;
        final cInfo = cTime;

        comments.add(
          CommentItem(
            id: cId,
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
    }

    final info = BaseParser.parserInfo(time, viewCount);

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
}
