import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_ext.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:timeago/timeago.dart' as timeago;

class RedditParser implements BaseParser {
  const RedditParser();

  @override
  String get baseUrl => 'https://www.reddit.com';

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();

    await Isolate.spawn(_detailIsolate, [responseData, resultPort.sendPort]);

    return await resultPort.first as Either<Failure, Details>;
  }

  static void _detailIsolate(List<dynamic> args) {
    final json = args[0] as dynamic;
    final sendPort = args[1] as SendPort;

    if (json == null || json.isEmpty == true) {
      final result = Right<Failure, Details>(Details.empty());
      sendPort.send(result);
      return;
    }

    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final htmlUnescape = HtmlUnescape();

    final detailData =
        (json[0]['data']['children'] as List<dynamic>).first['data'];

    final bodyHtml = detailData['selftext_html'].toString();
    final title = detailData['title'].toString();
    final viewCount = '';
    final likeCount = detailData['ups'].toString();
    final nickImage = '';
    final userId = detailData['author_fullname'].toString();
    final nickName = detailData['author'].toString();
    final double created = detailData['created'];
    final int milliseconds = (created * 1000).toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    final parsedTime = timeago.format(date, locale: 'ko');
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final comment = json[1]['data']['children'] as List<dynamic>?;
    final comments =
        comment
            ?.map((element) => _parseComment(element, htmlUnescape))
            .whereType<CommentItem>()
            .toList() ??
        const [];

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: created.toString(),
      info: info,
      userInfo: UserInfo(id: userId, nickName: nickName, nickImage: nickImage),
      comments: comments,
      bodyHtml: htmlUnescape.convert(bodyHtml),
    );

    final result = Right<Failure, Details>(detail);
    sendPort.send(result);
  }

  static CommentItem? _parseComment(
    dynamic element,
    HtmlUnescape htmlUnescape,
  ) {
    final item = element['data'];

    if (item == null) {
      return null;
    }

    final bodyHtml = item['body_html'].toString();
    final id = item['id'].toString();
    final viewCount = '';
    final likeCount = item['ups'].toString();
    final nickImage = '';
    final userId = item['author_fullname'].toString();
    final nickName = item['author'].toString();
    final double created = item['created'];
    final replies = item['replies'];
    final int milliseconds = (created * 1000).toInt();
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds).toLocal();
    final parsedTime = timeago.format(date, locale: 'ko');
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    // if (replies != '') {
    //   debugPrint('replies=$replies');
    // }

    return CommentItem(
      id: id.hashCode,
      isReply: replies != '',
      bodyHtml: htmlUnescape.convert(bodyHtml),
      likeCount: likeCount,
      mediaHtml: '',
      isVideo: false,
      time: created.toString(),
      info: info,
      userInfo: UserInfo(id: userId, nickName: nickName, nickImage: nickImage),
      authorId: '',
    );
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType p1, List<int> p2) isReads,
  ) async {
    final receivePort = ReceivePort();
    final completer = Completer<List<ListItem>>();

    receivePort.listen((message) async {
      if (message is ReadStatusRequest) {
        final statuses = await isReads(siteType, message.ids);
        message.responsePort.send(ReadStatusResponse(statuses));
      } else if (message is List<ListItem>) {
        completer.complete(message);
        receivePort.close();
      }
    });

    try {
      await Isolate.spawn(
        _parseListInIsolate,
        IsolateMessage(
          receivePort.sendPort,
          response.data,
          -1,
          boardTitle,
          baseUrl,
          false,
        ),
      );

      return Right(await completer.future);
    } catch (e) {
      receivePort.close();
      return Left(GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(IsolateMessage message) async {
    final replyPort = message.replyPort;
    final json = message.responseData;
    final boardTitle = message.boardTitle;

    final list = json['data']['children'] as List<dynamic>?;

    if (list == null) {
      replyPort.send(List<ListItem>.empty());
      return;
    }

    final htmlUnescape = HtmlUnescape();
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final items = list
        .map((element) {
          final data = element['data'];
          if (data == null) return null;

          final double created = data['created'];
          final int milliseconds = (created * 1000).toInt();
          final date = DateTime.fromMillisecondsSinceEpoch(
            milliseconds,
          ).toLocal();
          final parsedTime = timeago.format(date, locale: 'ko');
          final hit = '';
          final nickName = data['author'].toString();
          final info = BaseParser.parserInfo(false, nickName, parsedTime, hit);
          final id = data['id'].toString();
          final title = data['title'].toString();
          final category = data['link_flair_text'].toString();
          final reply = data['num_comments'].toString();
          final userId = data['author_fullname'].toString();
          final board = data['subreddit'].toString();

          return ListItem(
            id: id.hashCode,
            title: htmlUnescape.convert(title),
            reply: reply,
            category: category,
            time: milliseconds.toString(),
            url: id,
            info: info,
            board: board,
            boardTitle: boardTitle,
            like: '',
            hit: hit,
            userInfo: UserInfo(id: userId, nickName: nickName, nickImage: ''),
            hasImage: false,
            isRead: false,
          );
        })
        .whereType<ListItem>()
        .toList();

    replyPort.send(items);
  }

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) async {

    final responseData = response.data;

    final document = parse(responseData);
    final container = document.querySelectorAll(
      'div[id=communities_section] > li',
    );

    for (final element in container) {
      debugPrint('container=${element.innerHtml}');
    }


    return Left(GetMainFailure(message: 'test'));
  }

  @override
  SiteType get siteType => SiteType.reddit;

  @override
  String urlByDetail(String url, String board, int id) =>
      'https://www.reddit.com/r/$board/comments/$url.json';

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final sort = sortType.toQuery(siteType);
    final extra = page > 1 ? '&after=t3_${lastId.stringId}' : '';
    return 'https://www.reddit.com/r/$board/$sort/.json?limit=25$extra';
  }

  @override
  String urlByMain() =>
      'https://www.reddit.com/svc/shreddit/left-nav-communities-section';

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) => url;

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) {
    throw UnimplementedError();
  }

  @override
  String urlByComments(String url, String board, int id, int page) {
    throw UnimplementedError();
  }
}
