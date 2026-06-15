import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';

import '../base/base_parser.dart';

class GeekNewsParser extends BaseParser {
  const GeekNewsParser();

  @override
  SiteType get siteType => SiteType.geekNews;

  @override
  String get baseUrl => 'https://news.hada.io';

  // ──────────────────────────────────────────────────────────────────
  // Detail parsing
  // ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as String;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(String responseData) {
    try {
      final document = html_parser.parse(responseData);

      // Title
      final String title = document.qText('div.topictitle a > h1');

      // External URL
      final String externalUrl = document.qAttr('div.topictitle a', 'href');

      // Points
      final pointsEl = document.querySelector('div.topicinfo span[id^="tp"]');
      final String points = pointsEl?.text.trim() ?? '0';

      // Author
      final String author = document.qText('div.topicinfo a[href^="/@"]');

      // Time - 사이트가 <span title> -> <time class="js-relative-time" title>
      // 로 마이그레이션됨. 폴백 유지.
      final timeEl =
          document.querySelector('div.topicinfo time') ??
          document.querySelector('div.topicinfo span[title]');
      final String timeText = timeEl?.text.trim() ?? '';
      final String timeTitle = timeEl?.attributes['title'] ?? '';

      // Body content
      final bodyEl = document.querySelector('div#topic_contents');
      String bodyHtml = bodyEl?.innerHtml.trim() ?? '';

      // If there's an external URL, prepend it as a link
      if (externalUrl.isNotEmpty && externalUrl.startsWith('http')) {
        bodyHtml = '<p><a href="$externalUrl">$externalUrl</a></p>$bodyHtml';
      }

      // Comments
      final commentRows = document.querySelectorAll('div.comment_row');
      final List<CommentItem> comments = [];
      int commentIdx = 0;

      for (final row in commentRows) {
        final String cAuthor = row.qText('div.commentinfo a[href^="/@"]');

        // 시간 노드는 <time> 으로 바뀜. 기존 a[href^=comment?id=] 폴백 유지.
        final cTimeEl =
            row.querySelector('div.commentinfo time') ??
            row.querySelector('div.commentinfo a[href^="comment?id="]') ??
            row.querySelector('div.commentinfo a[href^="/comment?id="]');
        final String cTime = cTimeEl?.text.trim() ?? '';

        final cBodyEl = row.querySelector('span.comment_contents');
        final String cBody = cBodyEl?.innerHtml.trim() ?? '';

        // Depth from style="--depth:N"
        final String style = row.attributes['style'] ?? '';
        final depthMatch = RegExp(r'--depth:\s*(\d+)').firstMatch(style);
        final int depth = depthMatch != null
            ? int.parse(depthMatch.group(1)!)
            : 0;

        final String cInfo = '$cAuthorㆍ$cTime';

        comments.add(
          CommentItem(
            id: commentIdx++,
            isReply: depth > 0,
            bodyHtml: cBody,
            likeCount: '',
            mediaHtml: '',
            isVideo: false,
            time: cTime,
            info: cInfo,
            userInfo: UserInfo(id: cAuthor, nickName: cAuthor, nickImage: ''),
            authorId: '',
          ),
        );
      }

      final String info = '$authorㆍ$timeTextㆍ${points}P';

      final detail = Details(
        title: title,
        viewCount: '',
        likeCount: points,
        csrf: '',
        time: timeTitle,
        info: info,
        userInfo: UserInfo(id: author, nickName: author, nickImage: ''),
        comments: comments,
        bodyHtml: bodyHtml,
      );

      return Right<Failure, Details>(detail);
    } catch (e) {
      return Left<Failure, Details>(GetDetailFailure(message: e.toString()));
    }
  }

  // ──────────────────────────────────────────────────────────────────
  // List parsing
  // ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response<dynamic> response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    try {
      final responseData = response.data is String
          ? response.data as String
          : response.data.toString();

      final items = await ParserIsolateClient.instance.parseList(
        siteType: siteType,
        responseData: responseData,
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
    final String responseData = message.responseData as String;
    final String boardTitle = message.boardTitle;
    final String baseUrl = message.baseUrl;

    final List<ListItem> items = [];

    try {
      final document = html_parser.parse(responseData);
      final topicRows = document.querySelectorAll('div.topic_row');

      for (final row in topicRows) {
        // Extract topic ID from description link or comments link
        int id = -1;
        final descLink = row.querySelector('div.topicdesc > a');
        if (descLink != null) {
          final href = descLink.attributes['href'] ?? '';
          final idMatch = RegExp(r'topic\?id=(\d+)').firstMatch(href);
          if (idMatch != null) {
            id = int.parse(idMatch.group(1)!);
          }
        }
        if (id <= 0) continue;

        // Title (사이트가 h1 -> h2.topic-title-heading 로 변경됨, 폴백 유지)
        final titleEl =
            row.querySelector('div.topictitle a h2.topic-title-heading') ??
            row.querySelector('div.topictitle a > h2') ??
            row.querySelector('div.topictitle a > h1');
        final String title = titleEl?.text.trim() ?? '';
        if (title.isEmpty) continue;

        // Source domain
        final urlSpan = row.querySelector('span.topicurl');
        final String category = urlSpan?.text.trim() ?? '';

        // Points
        final pointsEl = row.querySelector('div.topicinfo span[id^="tp"]');
        final String points = pointsEl?.text.trim() ?? '0';

        // Author
        final authorEl =
            row.querySelector('div.topicinfo a[href^="/@"]');
        final String author = authorEl?.text.trim() ?? '';

      // Time - <time> 우선, 구버전 span[title] 폴백, 그래도 없으면 텍스트 regex.
      String timeText = '';
      final timeEl =
          row.querySelector('div.topicinfo time') ??
          row.querySelector('div.topicinfo span[title]');
      if (timeEl != null) {
        timeText = timeEl.text.trim();
      } else {
        final infoEl = row.querySelector('div.topicinfo');
        if (infoEl != null) {
          final timeMatch = RegExp(
            r'(\d+(?:일|시간|분|초)전|방금)',
          ).firstMatch(infoEl.text);
          if (timeMatch != null) {
            timeText = timeMatch.group(0)!;
          }
        }
      }

        // Comment count
        final commentLink =
            row.querySelector('div.topicinfo a[href*="go=comments"]') ??
            row.querySelector('div.topicinfo a[href^="topic?id="]');
        String reply = '';
        if (commentLink != null) {
          final commentText = commentLink.text.trim();
          final countMatch = RegExp(r'(\d+)').firstMatch(commentText);
          if (countMatch != null) {
            reply = countMatch.group(1).toString();
          }
        }

        final String url = '$baseUrl/topic?id=$id';
        final String info = '$authorㆍ$timeTextㆍ${points}P';

        items.add(
          ListItem(
            id: id,
            title: title,
            reply: reply,
            category: category,
            time: timeText,
            url: url,
            info: info,
            board: '',
            boardTitle: boardTitle,
            like: points,
            hit: '',
            userInfo: UserInfo(id: author, nickName: author, nickImage: ''),
            hasImage: false,
            isRead: false,
          ),
        );
      }
    } catch (e) {
      // 구조 파손 등 치명 오류는 삼키지 않고 워커 디스패처가
      // ParseListError 로 보고하도록 전파한다.
      MoclLogger.log('[GeekNewsParser] Error parsing list: $e');
      rethrow;
    }

    await sendListWithReadStatus(replyPort, items);
  }

  // ──────────────────────────────────────────────────────────────────
  // URL builders
  // ──────────────────────────────────────────────────────────────────

  @override
  String urlByDetail(String url, String board, int id) =>
      '$baseUrl/topic?id=$id';

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    MoclLogger.log('urlByList = url = $url, board = $board, page = $page');
    // page=1 → 오늘, page=2 → 어제, page=3 → 그저께 ...
    final date = DateTime.now().subtract(Duration(days: page - 1));
    final day = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$baseUrl/$board?day=$day';
  }

}
