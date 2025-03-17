import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_ext.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:timeago/timeago.dart' as timeago;

class TheQoo extends BaseParser {
  const TheQoo();

  @override
  String get baseUrl => 'https://theqoo.net';

  @override
  String urlByMain() => 'https://theqoo.net/';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();

    await Isolate.spawn(_detailIsolate, [responseData, resultPort.sendPort]);

    return await resultPort.first as Either<Failure, Details>;
  }

  static void _detailIsolate(List<dynamic> args) {
    final responseData = args[0] as List<dynamic>;
    ;
    final sendPort = args[1] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData.first);
    final container = document.querySelector(
        'html > body > div[id=container] > div.content > section > article');

    final commentContainer = container?.querySelector('div[id=comment]');

    final title =
        container?.querySelector('div.title-wrap > h3')?.text.trim() ?? '';
    final infoElement =
        container?.querySelector('div.title-wrap > div.under-title');
    final nickName = infoElement?.querySelector('span.name')?.text.trim() ?? '';
    final time = infoElement?.querySelector('span.date')?.text.trim() ?? '';
    var viewCount = infoElement?.querySelector('span.hit')?.text.trim() ?? '';
    final bodyHtml = container?.querySelector('div.read-body > div');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    var likeCount = '';
    final nickImage = '';

    var index = 0;
    final comments = commentContainer
            ?.querySelectorAll('ul.list > li')
            .map((element) {
              final nickName = '';

              final id = '-1';
              final isReply = false;
              final time = element
                      .querySelector('ul.list-element > li.date')
                      ?.text
                      .trim() ??
                  '';

              final nickImage = '';
              final likeCount = '';

              final body = element
                      .querySelector('ul.list-element > li.title')
                      ?.innerHtml ??
                  '';

              var parsedTime = '';
              try {
                var dateTime = parseDateTime(time);
                parsedTime = timeago.format(dateTime, locale: 'ko');
              } catch (e) {
                parsedTime = time;
              }
              final info = '$nickName ・ $parsedTime';

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: body,
                likeCount: likeCount,
                mediaHtml: '',
                isVideo: false,
                time: time,
                info: info,
                userInfo: UserInfo(
                  id: id,
                  nickName: nickName,
                  nickImage: nickImage,
                ),
                authorId: '',
              );
            })
            .whereType<CommentItem>()
            .toList() ??
        [];

    var parsedTime = '';
    try {
      var dateTime = parseDateTime(time);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);

    // debugPrint('bodyHtml=${bodyHtml?.innerHtml}');

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
    );

    final result = Right<Failure, Details>(detail);
    sendPort.send(result);
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
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
          IsolateMessage<String>(
            receivePort.sendPort,
            response.data,
            lastId.intId,
            boardTitle,
            baseUrl,
          ));

      return Right(await completer.future);
    } catch (e) {
      receivePort.close();
      return Left(GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(IsolateMessage<String> message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    final document = parse(responseData);
    final elementList = document.querySelectorAll(
        "div[id=container] > div.content > section.flatBoard > div.m-list > ul.list > li");

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
      final category = element
              .querySelector('ul.list-element > li:last-child')
              ?.text
              .trim() ??
          '';
      if (category == '공지') continue;

      final title = element
              .querySelector('ul.list-element > li.title > span.title_span')
              ?.text
              .trim() ??
          '';
      final time =
          element.querySelector('ul.list-element > li.date')?.text.trim() ?? '';
      final nickImage = '';

      final hit = element
              .querySelector('ul.list-element > li.hit')
              ?.text
              .trim()
              .split(' ')
              .lastOrNull ??
          '';
      final like = element
              .querySelector('div.list_title > div.list_symph > span')
              ?.text
              .trim() ??
          '';

      final nickName = '';
      final hasImage = false;
      var parsedTime = '';
      try {
        final dateTime = parseDateTime(time);
        parsedTime = timeago.format(dateTime, locale: 'ko');
      } catch (e) {
        parsedTime = time;
      }

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
        .map((item) => ListItem(
              id: item['id'],
              title: item['title'],
              reply: item['reply'],
              category: item['category'],
              time: item['time'],
              info: item['info'],
              url: item['url'],
              board: item['board'],
              boardTitle: item['boardTitle'],
              like: item['like'],
              hit: item['hit'],
              userInfo: item['userInfo'],
              hasImage: item['hasImage'],
              isRead: readStatusResponse.statuses.contains(item['id']),
            ))
        .toList();

    replyPort.send(resultList);
  }

  @override
  Future<Either<Failure, List<MainItem>>> main(
    Response response,
  ) async {
    final responseData = response.data;
    final document = parse(responseData);
    final container = document.querySelector(
        'html > body > div[id=container] > div.content > div.bd > div[id=cate_index_mobile]');
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
  SiteType get siteType => SiteType.theqoo;

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    // final String sort = sortType.toQuery(siteType);
    return '$url&page=$page';
  }

  static DateTime parseDateTime(String dateTimeString) {
    final times = dateTimeString.split(' ');

    final now = DateTime.now();
    if (times.length == 2) {
      var date = times[0].split('-');

      var year = now.year;
      var month = now.month;
      var day = now.day;
      var hour = now.hour;
      var minute = now.minute;
      var second = now.second;

      if (date.length == 3) {
        year = int.parse(date[0]);
        month = int.parse(date[1]);
        day = int.parse(date[2]);
      } else {
        throw Exception('Error parsing $dateTimeString');
      }

      var time = times[1].split(':');
      if (time.length == 3) {
        hour = int.parse(time[0]);
        minute = int.parse(time[1]);
        second = int.parse(time[2]);
      } else {
        throw Exception('Error parsing $dateTimeString');
      }

      return DateTime(year, month, day, hour, minute, second);
    } else {
      var times = dateTimeString.split(':');

      if (times.length == 2) {
        final hour = int.parse(times[0]);
        final minute = int.parse(times[1]);
        return DateTime(now.year, now.month, now.day, hour, minute);
      } else {
        times = dateTimeString.split('-');
        if (times.length == 3) {
          final year = int.parse(times[0]);
          final tmp = now.year - year;
          final month = int.parse(times[1]);
          final day = int.parse(times[2]);
          return DateTime(year + tmp, month, day, now.hour, now.minute);
        } else {
          throw Exception('Error parsing $dateTimeString');
        }
      }
    }
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) {
    // TODO: implement comments
    throw UnimplementedError();
  }
}
