import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:timeago/timeago.dart' as timeago;

@lazySingleton
class NaverCafeParser extends BaseParser {
  @override
  SiteType get siteType => SiteType.naverCafe;

  @override
  String get baseUrl => 'https://m.cafe.naver.com';

  @override
  FutureOr<Result> main(Response response) {
    final Map<String, dynamic> json = response.data['message'];
    final String status = json['status'];
    if (status != '200') {
      final Map<String, dynamic> error = json['error'];
      final String code = error['code'];
      final String msg = error['msg'];
      if (code == '0004') {
        return ResultFailure(failure: NotLoginFailure(message: msg));
      } else {
        return ResultFailure(failure: GetMainFailure(message: msg));
      }
    } else {
      final List<dynamic> cafes = json['result']['cafes'];
      var orderBy = 0;
      final data = cafes.map((cafe) {
        Map<String, dynamic> json = {
          'siteType': siteType.name,
          'orderBy': orderBy,
          'url': cafe['cafeId'].toString(),
          'board': cafe['cafeUrl'],
          'text': cafe['mobileCafeName'],
          'icon': cafe['cafeIconImageUrl'],
          'hasItem': false,
          'type': 0,
        };
        return MainItem.fromJson(json);
      }).toList();

      return ResultSuccess<List<MainItem>>(data: data);
    }
  }

  @override
  Future<Result> comment(Response response) {
    // TODO: implement comment
    throw UnimplementedError();
  }

  @override
  Future<Result> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();
    await Isolate.spawn(
      _detailIsolate,
      [responseData, resultPort.sendPort],
    );
    return await resultPort.first as Result;
  }

  static void _detailIsolate(List<dynamic> args) {
    final responseData = args[0] as List<dynamic>;
    final sendPort = args[1] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final detail = responseData.first['result'];
    final article = detail['article'];

    final bodyHtml = article['contentHtml'] ?? '';
    final writer = article['writer'];
    final title = article['subject'] ?? '';
    // final id = writer['id'] ?? '';
    final nickName = writer['nick'] ?? '';
    final nickImage = writer['image']['url'] ?? '';
    final time = article['writeDate'] ?? 0;
    final viewCount = (article['readCount'] ?? 0).toString();
    // final commentCount = writer['commentCount'];
    final likeCount = '';

    final comment = responseData.last['result'];
    // log('[detail] comment=$comment');

    final List<dynamic> comments = comment['comments']['items'];

    final commentItems = comments
        .map((comment) {
          final id = comment['id'] ?? 'id';
          final writer = comment['writer'];
          final body = comment['content'] ?? '';
          final userId = writer['id'];
          final nickImage = ''; //writer['image']['url'] ?? '';
          final nickName = writer['nick'] ?? '';
          final isReply = false;
          final time = comment['updateDate'] ?? 0;
          final likeCount = '0';

          var parsedTime = '';
          try {
            var dateTime = DateTime.fromMillisecondsSinceEpoch(time);
            parsedTime = timeago.format(dateTime, locale: 'ko');
          } catch (e) {
            parsedTime = time.toString();
          }
          var info = '$nickName ・ $parsedTime';

          return CommentItem(
            id: id,
            isReply: isReply,
            bodyHtml: body,
            likeCount: likeCount,
            mediaHtml: '',
            isVideo: false,
            time: time.toString(),
            info: info,
            userInfo: UserInfo(
              id: userId,
              nickName: nickName,
              nickImage: nickImage,
            ),
            authorId: '',
          );
        })
        .whereType<CommentItem>()
        .toList();

    String parsedTime = '';

    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time.toString();
    }
    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);

    var details = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time.toString(),
      info: info,
      userInfo: UserInfo(
        id: nickName,
        nickName: nickName,
        nickImage: nickImage,
      ),
      bodies: [],
      comments: commentItems,
      bodyHtml: bodyHtml,
    );

    sendPort.send(ResultSuccess(data: details));
  }

  @override
  Future<Result> list(
    Response response,
    int lastId,
    String boardTitle,
    Future<Map<int, bool>> Function(SiteType, List<int>) isReads,
  ) async {
    final receivePort = ReceivePort();
    final completer = Completer<Result>();

    receivePort.listen((message) async {
      if (message is ReadStatusRequest) {
        final statuses = await isReads(siteType, message.ids);
        message.responsePort.send(ReadStatusResponse(statuses));
      } else if (message is List<ListItem>) {
        completer.complete(ResultSuccess<List<ListItem>>(data: message));
        receivePort.close();
      }
    });

    try {
      final message = response.data['message'];
      final status = message['status'].toString();
      if (status != "200") {
        throw Exception("status is not 200!");
      }

      await Isolate.spawn(
        _parseListInIsolate,
        IsolateMessage<Map<String, dynamic>>(
          receivePort.sendPort,
          message['result'],
          lastId,
          boardTitle,
          baseUrl,
        ),
      );

      return await completer.future;
    } catch (e) {
      receivePort.close();
      return ResultFailure(failure: GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(
    IsolateMessage<Map<String, dynamic>> message,
  ) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;

    var parsedItems = <Map<String, dynamic>>[];
    var ids = <int>[];

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final List<dynamic> articleList = responseData['articleList'];

    for (var article in articleList) {
      final String type = article['type'];
      if (type == 'AD') {
        continue;
      }

      final Map<String, dynamic> item = article['item'];
      final int id = item['articleId'] ?? -1;

      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final int board = item['cafeId'] ?? -2;
      final String nickName = item['writerNickname'] ?? '-';
      final String category = item['menuName'] ?? '-';
      final String title = item['subject'] ?? '-';
      final String nickImage = item['profileImage'] ?? '-';
      final int hit = item['readCount'] ?? 0;
      final int like = item['likeItCount'] ?? 0;
      final int commentCount = item['commentCount'] ?? 0;
      final int time = item['writeDateTimestamp'] ?? 0;
      final String userId = item['memberKey'] ?? '-';
      final bool hasImage = item['attachImage'] as bool? ?? false;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      final parsedTime = timeago.format(dateTime, locale: 'ko');
      final info = BaseParser.parserInfo(nickName, parsedTime, hit.toString());

      final parsedItem = {
        'id': id,
        'title': title,
        'reply': commentCount.toString(),
        'category': category,
        'time': time.toString(),
        'info': info,
        'url': '',
        'board': board.toString(),
        'boardTitle': boardTitle,
        'like': like.toString(),
        'hit': hit.toString(),
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
              url: item['url'],
              info: item['info'],
              board: item['board'],
              boardTitle: item['boardTitle'],
              like: item['like'],
              hit: item['hit'],
              userInfo: item['userInfo'],
              hasImage: item['hasImage'],
              isRead: readStatusResponse.statuses[item['id']] ?? false,
            ))
        .toList();

    replyPort.send(resultList);
  }

  static DateTime parseDateTime(String dateTimeString) {
    if (dateTimeString.contains(' ')) {
// 년.월.일 형식
      var parts = dateTimeString.split(' ');
      var dateParts = parts[0].split('.');
      var timeParts = parts[1].split(':');
      if (dateParts.length == 3) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } else if (dateParts.length == 2) {
        final now = DateTime.now();
        return DateTime(
          now.year,
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } else {
        throw Exception('Error parsing $dateTimeString');
      }
    } else if (dateTimeString.contains(':')) {
      final now = DateTime.now();
// 시:분 형식
      var timeParts = dateTimeString.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } else if (dateTimeString == '어제') {
      final now = DateTime.now();
      return now.subtract(const Duration(days: 1));
    } else {
      throw Exception('Error parsing $dateTimeString');
    }
  }
}
