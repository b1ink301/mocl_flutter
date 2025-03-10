import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart' as mainitem;
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../domain/entities/mocl_comment_item.dart';
import '../base/base_parser.dart';

class NaverCafeParser implements BaseParser {
  const NaverCafeParser();

  @override
  SiteType get siteType => SiteType.naverCafe;

  @override
  String get baseUrl => 'https://m.cafe.naver.com';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) async {
    final Map<String, dynamic> json = response.data['message'];
    final String status = json['status'];
    if (status != '200') {
      final Map<String, dynamic> error = json['error'];
      final String code = error['code'];
      final String msg = error['msg'];
      if (code == '0004') {
        return Left(NotLoginFailure(message: msg));
      } else {
        return Left(GetMainFailure(message: msg));
      }
    } else {
      final List<dynamic> cafes = json['result']['cafes'];
      var orderBy = 0;
      final List<mainitem.MainItem> data = cafes.map((cafe) {
        Map<String, dynamic> json = {
          'siteType': siteType.name,
          'orderBy': orderBy++,
          'url': cafe['cafeId'].toString(),
          'board': cafe['cafeUrl'],
          'text': cafe['mobileCafeName'],
          'icon': cafe['cafeIconImageUrl'],
          'hasItem': false,
          'type': 0,
        };
        return mainitem.MainItem.fromJson(json);
      }).toList();

      return Right(data.cast<MainItem>());
    }
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) =>
      throw UnimplementedError('comment');

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();
    await Isolate.spawn(
      _detailIsolate,
      [responseData, resultPort.sendPort],
    );
    return await resultPort.first as Either<Failure, Details>;
  }

  static void _detailIsolate(List<dynamic> args) {
    final responseData = args[0] as List<dynamic>;
    final sendPort = args[1] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final detail = responseData.first['result'];
    final article = detail['article'];

    final bodyHtml = article['contentHtml'].toString();
    final writer = article['writer'];
    final title = article['subject'].toString().trim();
    // final id = writer['id'] ?? '';
    final nickName = writer['nick'].toString();
    final nickImage = writer['image']['url'].toString();
    final time = article['writeDate'] ?? 0;
    final viewCount = (article['readCount'] ?? 0).toString();
    // final commentCount = writer['commentCount'];
    final likeCount = '';

    final comment = responseData.last['result'];

    final List<dynamic> comments = comment['comments']['items'];

    final commentItems = comments
        .map((comment) {
          final id = comment['id'] ?? -1;
          final writer = comment['writer'];
          var body = comment['content'].toString();
          final userId = writer['memberKey'].toString();
          final nickImage = ''; //writer['image']['url'] ?? '';
          final nickName = writer['nick'].toString();
          final isReply = comment['isRef'];
          final time = comment['updateDate'] ?? 0;
          final likeCount = '0';
          final image = comment['image'];
          final sticker = comment['sticker'];

          if (image != null) {
            body += '<br><img src=\'${image["url"]}\' width="240" >';
          }

          if (sticker != null) {
            body +=
                '<br><img src=\'${sticker["url"]}?type=${sticker["type"]}\' width="129" >';
          }

          var parsedTime = '';
          try {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
            parsedTime = timeago.format(dateTime, locale: 'ko');
          } catch (e) {
            parsedTime = time.toString();
          }
          final info = '$nickName ・ $parsedTime';

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

    final details = Details(
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
      comments: commentItems,
      bodyHtml: bodyHtml,
    );

    final result = Right<Failure, Details>(details);
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
          lastId.intId,
          boardTitle,
          baseUrl,
        ),
      );

      return Right(await completer.future);
    } catch (e) {
      receivePort.close();
      return Left(GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(
    IsolateMessage<Map<String, dynamic>> message,
  ) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final List<dynamic> articleList = responseData['articleList'];

    for (final Map<String, dynamic> article in articleList) {
      final int id = article['articleId'] ?? -1;

      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final int board = article['cafeId'] ?? -2;
      final String nickName = article['writerNickname'].toString();
      final String category = article['menuName'].toString();
      final String title = article['subject'].toString();
      final String nickImage = article['profileImage'].toString();
      final int hit = article['readCount'] ?? 0;
      final int like = article['likeItCount'] ?? 0;
      final int commentCount = article['commentCount'] ?? 0;
      final int time = article['writeDateTimestamp'] ?? 0;
      final String userId = article['memberKey'].toString();
      final bool hasImage = article['attachImage'] as bool? ?? false;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      final parsedTime = timeago.format(dateTime, locale: 'ko');
      final info = BaseParser.parserInfo(nickName, parsedTime, hit.toString());

      final parsedItem = {
        'id': id,
        'title': parse(title).body?.text,
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
              isRead: readStatusResponse.statuses.contains(item['id']),
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

  @override
  String urlByDetail(
    String url,
    String board,
    int id,
  ) =>
      'https://apis.naver.com/cafe-web/cafe-articleapi/v3/cafes/$board/articles/$id';
  // 'https://apis.naver.com/cafe-web/cafe-articleapi/v2/cafes/$board/articles/$id'; //?query=&useCafeId=true&requestFrom=A

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    // final String sort = sortType.toQuery(siteType);
    return "https://apis.naver.com/cafe-web/cafe2/ArticleListV2dot1.json?"
        "search.clubid=$url"
        "&search.queryType=lastArticle"
        "&search.perPage=20"
        "&ad=false"
        "&uuid=6dd62de1-7279-49f0-b009-6ccc554ac679"
        "&search.page=$page";
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    throw UnimplementedError('urlBySearchList');
  }

  @override
  String urlByMain() =>
      'https://apis.naver.com/cafe-home-web/cafe-home/v1/cafes/join?perPage=100';

  @override
  String urlByComments(String url, String board, int id, int page) {
    // TODO: implement urlByComments
    throw UnimplementedError();
  }
}
