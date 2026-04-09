import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart' as html_parser;
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

import '../base/base_parser.dart';

class GeekNewsParser implements BaseParser {
  const GeekNewsParser();

  @override
  SiteType get siteType => SiteType.geekNews;

  @override
  String get baseUrl => 'https://news.hada.io';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) =>
      throw UnimplementedError('main');

  // ──────────────────────────────────────────────────────────────────
  // Detail parsing
  // ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data as String;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(String responseData) {
    try {
      final document = html_parser.parse(responseData);

      // Title
      final titleEl = document.querySelector('div.topictitle a > h1');
      final String title = titleEl?.text.trim() ?? '';

      // External URL
      final titleLink = document.querySelector('div.topictitle a');
      final String externalUrl = titleLink?.attributes['href'] ?? '';

      // Points
      final pointsEl = document.querySelector('div.topicinfo span[id^="tp"]');
      final String points = pointsEl?.text.trim() ?? '0';

      // Author
      final authorEl =
          document.querySelector('div.topicinfo a[href^="/user"]');
      final String author = authorEl?.text.trim() ?? '';

      // Time - span with title attribute has exact datetime
      final timeEl = document.querySelector('div.topicinfo span[title]');
      final String timeText = timeEl?.text.trim() ?? '';
      final String timeTitle = timeEl?.attributes['title'] ?? '';

      // Body content
      final bodyEl = document.querySelector('div#topic_contents');
      String bodyHtml = bodyEl?.innerHtml.trim() ?? '';

      // If there's an external URL, prepend it as a link
      if (externalUrl.isNotEmpty && externalUrl.startsWith('http')) {
        bodyHtml =
            '<p><a href="$externalUrl">$externalUrl</a></p>$bodyHtml';
      }

      // Comments
      final commentRows = document.querySelectorAll('div.comment_row');
      final List<CommentItem> comments = [];
      int commentIdx = 0;

      for (final row in commentRows) {
        final cAuthorEl = row.querySelector('div.commentinfo a[href^="/user"]');
        final String cAuthor = cAuthorEl?.text.trim() ?? '';

        final cTimeEl =
            row.querySelector('div.commentinfo a[href^="comment?id="]');
        final String cTime = cTimeEl?.text.trim() ?? '';

        final cBodyEl = row.querySelector('span.comment_contents');
        final String cBody = cBodyEl?.innerHtml.trim() ?? '';

        // Depth from style="--depth:N"
        final String style = row.attributes['style'] ?? '';
        final depthMatch = RegExp(r'--depth:\s*(\d+)').firstMatch(style);
        final int depth =
            depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;

        final String cInfo = '$cAuthorㆍ$cTime';

        comments.add(CommentItem(
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
        ));
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
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final completer = Completer<List<ListItem>>();

    receivePort.listen((message) async {
      if (message is ReadStatusRequest) {
        final statuses = await isReads(siteType, message.ids);
        message.responsePort.send(ReadStatusResponse(statuses));
      } else if (message is List<ListItem>) {
        if (!completer.isCompleted) {
          completer.complete(message);
        }
        receivePort.close();
        errorPort.close();
      }
    });

    errorPort.listen((message) {
      if (!completer.isCompleted) {
        completer.completeError(message);
      }
      receivePort.close();
      errorPort.close();
    });

    try {
      final responseData = response.data is String
          ? response.data as String
          : response.data.toString();

      await Isolate.spawn(
        _parseListInIsolate,
        IsolateMessage<String>(
          receivePort.sendPort,
          responseData,
          lastId.intId,
          boardTitle,
          baseUrl,
          false,
        ),
        onError: errorPort.sendPort,
        onExit: errorPort.sendPort,
      );

      return Right(await completer.future);
    } catch (e) {
      receivePort.close();
      errorPort.close();
      return Left(GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(IsolateMessage<String> message) async {
    final replyPort = message.replyPort;
    final String responseData = message.responseData;
    final String boardTitle = message.boardTitle;
    final String baseUrl = message.baseUrl;

    final List<Map<String, dynamic>> parsedItems = [];
    final List<int> ids = [];

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

        // Title
        final titleEl = row.querySelector('div.topictitle a > h1');
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
            row.querySelector('div.topicinfo a[href^="/user"]');
        final String author = authorEl?.text.trim() ?? '';

        // Time - text content in topicinfo
        final infoEl = row.querySelector('div.topicinfo');
        String timeText = '';
        if (infoEl != null) {
          // Time is a bare text node after author link
          final infoText = infoEl.text;
          final timeMatch = RegExp(r'(\d+[일시분초]전|방금)').firstMatch(infoText);
          if (timeMatch != null) {
            timeText = timeMatch.group(0)!;
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

        parsedItems.add({
          'id': id,
          'title': title,
          'reply': reply,
          'category': category,
          'time': timeText,
          'info': info,
          'url': url,
          'board': '',
          'boardTitle': boardTitle,
          'like': points,
          'hit': '',
          'userInfo': UserInfo(id: author, nickName: author, nickImage: ''),
          'hasImage': false,
        });
        ids.add(id);
      }
    } catch (e) {
      MoclLogger.log('[GeekNewsParser] Error parsing list: $e');
    }

    final ReceivePort readStatusPort = ReceivePort();
    replyPort.send(ReadStatusRequest(ids, readStatusPort.sendPort));
    final ReadStatusResponse readStatusResponse =
        await readStatusPort.first as ReadStatusResponse;
    readStatusPort.close();

    final List<ListItem> resultList = parsedItems
        .map(
          (item) => ListItem(
            id: item['id'],
            title: item['title'],
            reply: item['reply'],
            category: item['category'],
            time: item['time'],
            url: item['url'],
            info: item['info'],
            board: item['board'],
            boardTitle: item['boardTitle'],
            like: item['like'],
            hit: item['hit'],
            userInfo: item['userInfo'],
            hasImage: item['hasImage'],
            isRead: readStatusResponse.statuses.contains(item['id']),
          ),
        )
        .toList();

    replyPort.send(resultList);
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

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) =>
      throw UnimplementedError('urlBySearchList');

  @override
  String urlByMain() => throw UnimplementedError('urlByMain');

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) =>
      throw UnimplementedError();

  @override
  String urlByComments(String url, String board, int id, int page) =>
      throw UnimplementedError();
}
