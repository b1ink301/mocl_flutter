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
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';
import 'package:timeago/timeago.dart' as timeago;

class TheQooParser extends BaseParser {
  const TheQooParser();

  @override
  SiteType get siteType => SiteType.theqoo;

  @override
  String get baseUrl => 'https://theqoo.net';

  @override
  String urlByMain() => 'https://theqoo.net/';

  @override
  Future<Either<Failure, List<CommentItem>>> comments(
    Response<dynamic> response,
  ) {
    throw UnimplementedError('comments');
  }

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as List<dynamic>;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(List<dynamic> responseData) {

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData.first);
    final container = document.querySelector(
      'html > body > div[id=container] > div.content > section > article',
    );

    final title =
        container?.querySelector('div.title-wrap > h3')?.text.trim() ?? '';
    final infoElement = container?.querySelector(
      'div.title-wrap > div.under-title',
    );
    final nickName = infoElement?.querySelector('span.name')?.text.trim() ?? '';
    final time = infoElement?.querySelector('span.date')?.text.trim() ?? '';
    var viewCount = infoElement?.querySelector('span.hit')?.text.trim() ?? '';
    final bodyHtml = container?.querySelector('div.read-body > div');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    var likeCount = '';
    final nickImage = '';

    final json = responseData.lastOrNull as Map<String, dynamic>?;
    final comments = <CommentItem>[];

    int nowCommentPage = 0;
    if (json != null) {
      nowCommentPage = json['now_comment_page'] as int? ?? 0;
      final addedNumber = json['added_number'];
      // final documentSrl = json['document_srl'];

      MoclLogger.log('nowCommentPage=$nowCommentPage, addedNumber=$addedNumber');

      final List<dynamic> list = json['comment_list'] as List<dynamic>;
      var index = 1;
      for (final element in list) {
        final String body = element['ct']?.toString() ?? '';
        final String time = element['rd']?.toString() ?? '';
        final int id = element['srl'] as int? ?? -1;

        final int commentIndex = (addedNumber as int) + index++;
        final nickName = '$commentIndex. 무명의 더쿠';
        final info = nickName;

        final comment = CommentItem(
          id: id,
          isReply: false,
          bodyHtml: body,
          likeCount: likeCount,
          mediaHtml: '',
          isVideo: false,
          time: time,
          info: info,
          userInfo: UserInfo(
            id: id.toString(),
            nickName: nickName,
            nickImage: '',
          ),
          authorId: '',
        );

        comments.add(comment);
      }
    }

    var parsedTime = '';
    try {
      var dateTime = ParserDateTime.parse(time);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time,
      info: info,
      userInfo: UserInfo(
        id: nickName,
        nickName: nickName,
        nickImage: nickImage,
      ),
      comments: comments,
      bodyHtml: bodyHtml?.innerHtml ?? '',
      extraData: {'nowCommentPage': nowCommentPage},
    );

    return Right<Failure, Details>(detail);
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

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    final document = parse(responseData);
    final elementList = document.querySelectorAll(
      "div[id=container] > div.content > section.flatBoard > div.m-list > ul.list > li",
    );

    for (final element in elementList) {
      final tmpUrl = element.querySelector('a.list-link')?.attributes['href'];
      if (tmpUrl == null) continue;
      final url = tmpUrl.toUrl(baseUrl);

      final tmp = tmpUrl.split('?');
      final pathList = tmp.firstOrNull?.split('/') ?? [];
      final lastPath = pathList.lastOrNull ?? '';
      final id = int.tryParse(lastPath) ?? 0;
      final userId = lastPath;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final board = pathList[1];
      final reply = element.querySelector('a.reply')?.text.trim() ?? '';
      final category =
          element
              .querySelector('ul.list-element > li:last-child')
              ?.text
              .trim() ??
          '';
      if (category == '공지') continue;

      final title =
          element
              .querySelector('ul.list-element > li.title > span.title_span')
              ?.text
              .trim() ??
          '';
      final time =
          element.querySelector('ul.list-element > li.date')?.text.trim() ?? '';
      final nickImage = '';

      final hit =
          element
              .querySelector('ul.list-element > li.hit')
              ?.text
              .trim()
              .split(' ')
              .lastOrNull ??
          '';
      final like =
          element
              .querySelector('div.list_title > div.list_symph > span')
              ?.text
              .trim() ??
          '';

      final nickName = '';
      final hasImage = false;
      // var parsedTime = '';
      // try {
      //   final dateTime = ParserDateTime.parse(time);
      //   parsedTime = timeago.format(dateTime, locale: 'ko');
      // } catch (e) {
      //   parsedTime = time;
      // }

      final info = '$hit 읽음';

      final parsedItem = {
        'id': id,
        'title': title,
        'reply': reply,
        'category': category,
        'time': time,
        'info': info,
        'url': url,
        'board': board,
        'boardTitle': boardTitle,
        'like': like,
        'hit': hit,
        'userInfo': UserInfo(
          id: userId,
          nickName: nickName,
          nickImage: nickImage,
        ),
        'hasImage': hasImage,
      };

      parsedItems.add(parsedItem);
      ids.add(id);
    }

    final readStatusPort = ReceivePort();
    replyPort.send(ReadStatusRequest(ids, readStatusPort.sendPort));
    final readStatusResponse = await readStatusPort.first as ReadStatusResponse;
    readStatusPort.close();

    final resultList = parsedItems
        .map(
          (item) => ListItem(
            id: item['id'] as int,
            title: item['title'] as String,
            reply: item['reply'] as String,
            category: item['category'] as String,
            time: item['time'] as String,
            info: item['info'] as String,
            url: item['url'] as String,
            board: item['board'] as String,
            boardTitle: item['boardTitle'] as String,
            like: item['like'] as String,
            hit: item['hit'] as String,
            userInfo: item['userInfo'] as UserInfo,
            hasImage: item['hasImage'] as bool,
            isRead: readStatusResponse.statuses.contains(item['id']),
          ),
        )
        .toList();

    replyPort.send(resultList);
  }

  @override
  Future<Either<Failure, List<MainItem>>> main(
    Response<dynamic> response,
  ) async {
    final responseData = response.data;
    final document = parse(responseData);
    final container = document.querySelector(
      'html > body > div[id=container] > div.content > div.bd > div[id=cate_index_mobile]',
    );
    if (container == null) {
      return Left(GetMainFailure(message: 'Container is null'));
    }
    final data = container.querySelectorAll('a');
    var orderBy = 0;
    final result = data
        .map((element) {
          final title = element.text;
          final board = element.attributes['href'].toString().substring(1);
          if (element.attributes['class'] != null) return null;

          // print('{\'title\'=\'$title\', \'board\'=\'$board\', \'type\'=0, \'url\'=\'$baseUrl$board\', \'no\'=$orderBy},');

          return MainItem(
            siteType: SiteType.damoang,
            board: board,
            text: title,
            url: baseUrl + board,
            orderBy: orderBy++,
            hasItem: false,
            type: 0,
          );
        })
        .whereType<MainItem>()
        .toList();

    return Right(result);
  }

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}page=$page';
  }

}
