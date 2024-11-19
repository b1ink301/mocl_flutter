import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:timeago/timeago.dart' as timeago;

@lazySingleton
class MeecoParser extends BaseParser {
  @override
  SiteType get siteType => SiteType.meeco;

  @override
  String get baseUrl => 'https://meeco.kr';

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
        _detailIsolate, [baseUrl, responseData, resultPort.sendPort]);

    final result = await resultPort.first as Result;
    return result;
  }

  static void _detailIsolate(List<dynamic> args) {
    final baseUrl = args[0] as String;
    final responseData = args[1] as String;
    final sendPort = args[2] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    var document = parse(responseData);
    final container = document.querySelector('article.atc');

    final title =
        container?.querySelector('header.atc_hd > h1 > a')?.text.trim() ?? '';

    final infoElement =
        container?.querySelector('header.atc_hd > div.atc_info');

    final tmpUrl =
        infoElement?.querySelector('span.pf > img.pf_img')?.attributes['src'] ??
            '';
    final nickImage = BaseParser.covertUrl(baseUrl, tmpUrl);
    final nickName =
        infoElement?.querySelector('span.nickname')?.text.trim() ?? '';

    final bodyHtml = container?.querySelector('div.atc_body');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    var time = infoElement?.querySelectorAll('ul > li')[0].text.trim() ?? '';

    var viewCount =
        infoElement?.querySelectorAll('ul > li')[1].text.trim() ?? '0';
    var likeCount = '';

    var index = 0;
    final comments = container
            ?.querySelectorAll(
                'div.cmt > div.cmt_list_parent > div.cmt_list > article')
            .map((element) {
              final headerElement = element.querySelector('header.cmt_hd');

              final profileElement = headerElement
                  ?.querySelector('div.pf_wrap > span.pf > img.pf_img');
              final tmpUrl = profileElement?.attributes['src']?.trim() ?? '';
              final nickImage = BaseParser.covertUrl(baseUrl, tmpUrl);
              final nickName = profileElement?.attributes['alt'] ?? '';
              final isReply = element.querySelector(
                      'div.comment-list-wrap > header > div > div.me-2 > i.bi') !=
                  null;
              // final ip = element
              //         .querySelector(
              //             'div.comment_info > div.comment_info_area > div.comment_ip > span.ip_address')
              //         ?.text ??
              //     '';
              final time =
                  element.querySelector('span.date')?.text.trim() ?? '';
              final likeCount = element
                      .querySelector('div.cmt_vote > span.cmt_vote_up > b.num')
                      ?.text
                      .trim() ??
                  '';

              final body = element.querySelector('div.xe_content');
              body
                  ?.querySelectorAll('input, span.name, button')
                  .forEach((e) => e.remove());

              var parsedTime = '';
              try {
                var dateTime = parseDateTime(time);
                parsedTime = timeago.format(dateTime, locale: 'ko');
              } catch (e) {
                parsedTime = time;
              }
              var info = '$nickName ・ $parsedTime';

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: body?.outerHtml ?? '',
                likeCount: likeCount,
                mediaHtml: '',
                isVideo: false,
                time: time,
                info: info,
                userInfo: UserInfo(
                  id: 'id',
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
    } on Exception {
      parsedTime = time;
    }

    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);

    var detail = Details(
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
      bodies: [],
      comments: comments,
      bodyHtml: bodyHtml?.innerHtml ?? '',
    );

    sendPort.send(ResultSuccess(data: detail));
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
      await Isolate.spawn(
          _parseListInIsolate,
          IsolateMessage<String>(
            receivePort.sendPort,
            response.data,
            lastId,
            boardTitle,
            baseUrl,
          ));

      return await completer.future;
    } catch (e) {
      receivePort.close();
      return ResultFailure(failure: GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(IsolateMessage<String> message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    var parsedItems = <Map<String, dynamic>>[];
    var ids = <int>[];

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    var document = parse(responseData).body;
    if (document == null) {
      return;
    }

    var elementList = document.querySelectorAll(
        'div.wrap > section[id=container] > div > section.ctt > section.neon_board > div[id=list_swipe_area] > div.list_ctt > div.list_document > div.list_d > ul > li');

    for (var element in elementList) {
      var category = element
              .querySelector('span.hot_text, span.notice_text')
              ?.text
              .trim() ??
          '';

      if (category == "공지" || category == "핫글") continue;

      var infoElement = element.querySelector('a.list_link');
      var title = infoElement?.attributes['title']?.trim() ?? '';
      final tmpUrl = infoElement?.attributes['href']?.trim() ?? '';
      final url = BaseParser.covertUrl(baseUrl, tmpUrl);

      var uri = Uri.tryParse(url);
      if (uri == null) continue;
      var idString = uri.pathSegments.lastOrNull ?? '-1';
      var id = int.tryParse(idString) ?? -1;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      var nickName = element
              .querySelector('div.list_info > div:first-child')
              ?.text
              .trim() ??
          ''; //:first-child, div:nth-child(2)
      var userId = nickName;
      var reply = element.querySelector("a.list_cmt")?.text.trim() ?? '';

      var board = '';
      var end = url.lastIndexOf("/");
      if (end > 0) {
        var start = url.lastIndexOf("/", end - 1);
        if (start >= 0) {
          board = url.substring(start + 1, end);
        }
      }

      var time = element
              .querySelector('div.list_info > div:nth-child(1)')
              ?.text
              .trim() ??
          '';
      var parsedTime = time;
      var nickImage = '';
      var hit = element
              .querySelector('div.list_info > div:nth-child(2)')
              ?.text
              .trim() ??
          '';
      var like =
          element.querySelector('div.list_info > div.list_vote')?.text.trim() ??
              '';

      var hasImage = false;
      final info = BaseParser.parserInfo(nickName, parsedTime, hit);

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
      if (dateParts.length == 4) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } else if (dateParts.length == 3) {
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
