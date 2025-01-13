import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:timeago/timeago.dart' as timeago;

class ClienParser extends BaseParser {
  @override
  SiteType get siteType => SiteType.clien;

  @override
  String get baseUrl => 'https://m.clien.net';

  @override
  Future<Result> comment(Response response) {
    throw UnimplementedError('comment');
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
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();
    await Isolate.spawn(_detailIsolate, [responseData, resultPort.sendPort]);
    return await resultPort.first as Either<Failure, Details>;
  }

  static void _detailIsolate(List<dynamic> args) {
    final responseData = args[0] as String;
    final sendPort = args[1] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
    var index = 0;
    final container =
        document.querySelector('body > div.nav_container > div.content_view');

    final csrf = document
            .querySelector(
                "body > nav.navigation > div.dropdown-menu > form > input[name=_csrf]")
            ?.attributes['value'] ??
        '';
    final title = container
            ?.querySelector("div.post_title > div.post_subject > span")
            ?.text
            .trim() ??
        '';
    final timeElement = container
        ?.querySelector("div.post_information > div.post_time > div.post_date");

    // debugPrint('timeElement = ${timeElement?.outerHtml}');
    timeElement?.querySelectorAll('.fa').forEach((element) => element.remove());
    var time = timeElement?.text.trim() ?? '';
    final tmp = time.split('수정일 :');
    final times = tmp.map((item) => item.trim()).toList();
    time = times.join('|');

    final bodyHtmlElement = container?.querySelector(
        "div.post_view > div.post_content > article > div.post_article");
    bodyHtmlElement
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());
    final bodyHtml = bodyHtmlElement?.innerHtml ?? '';
    final viewCountElement = container?.querySelector(
        "div.post_information > div.post_time > div.view_count");
    viewCountElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    final viewCount = viewCountElement?.text.trim() ?? '';

    final authorIpElement = container
        ?.querySelector("div.post_view > div.post_information > div.author_ip");
    authorIpElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    // var authorIp = authorIpElement?.text.trim() ?? '';
    final user = container
            ?.querySelector(
                "div.post_view > div.post_contact > span.contact_note > div.post_memo > div.memo_box > button.button_input")
            ?.attributes['onclick'] ??
        '';
    final nickName = container
            ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickname")
            ?.text
            .trim() ??
        '';
    final nickImage = container
            ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickimg > img")
            ?.attributes['src'] ??
        '';
    final likeCount = container
            ?.querySelector(
                "div.post_button > div.symph_area > button.symph_count > strong")
            ?.text
            .trim() ??
        '';

    var parsedTime = '';
    try {
      var dateTime = parseDateTime(times.first);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);

    final comments = container
            ?.querySelectorAll(
                "div.post_comment > div.comment > div.comment_row")
            .map((element) {
              if (element.innerHtml == "<span>삭제 되었습니다.</span>") {
                return null;
              }
              final id = element.attributes['data-author-id'] ?? '';
              // var sn =
              //     int.tryParse(element.attributes['data-comment-sn'] ?? '-1') ??
              //         -1;
              final isReply = element.classes.contains('re');
              final nickName = element
                      .querySelector(
                          "div.comment_info > div.post_contact > span.contact_name > span.nickname")
                      ?.text
                      .trim() ??
                  '';
              // var ip = element
              //         .querySelector(
              //             "div.comment_info > div.comment_info_area > div.comment_ip > span.ip_address")
              //         ?.text
              //         .trim() ??
              //     '';
              final timeElement = element.querySelector(
                  "div.comment_info > div.comment_info_area > div.comment_time");
              timeElement?.querySelector("span.timestamp")?.remove();
              final time = timeElement?.text.trim() ?? '';
              final nickImage = element
                      .querySelector(
                          "div.comment_info > div.post_contact > span.contact_name > span.nickimg > img")
                      ?.attributes['src'] ??
                  '';
              final likeCount = element
                      .querySelector(
                          "div.comment_content_symph > button > strong")
                      ?.text
                      .trim() ??
                  '';
              // var bodyElement = element
              //     .querySelector("div.comment_content > div.comment_view");

              final bodyElements = element.querySelectorAll(
                  "div.comment_content, div.comment-img, div.comment-video");
              for (final tmp in bodyElements) {
                tmp
                    .querySelectorAll('input, span.name, button')
                    .forEach((element) => element.remove());
              }

              // bodyElement
              //     ?.querySelectorAll('input, span.name, button')
              //     .forEach((element) => element.remove());

              var body = bodyElements.map((item) => item.innerHtml).join();
              // var body = bodyElement?.outerHtml ?? '';
              // var video = element
              //         .querySelector("div.comment-video > video > source")
              //         ?.attributes['src'] ??
              //     '';
              // var img = element
              //         .querySelector("div.comment-img > img")
              //         ?.attributes['src'] ??
              //     '';

              var parsedTime = '';
              try {
                var dateTime = parseDateTime(time);
                parsedTime = timeago.format(dateTime, locale: 'ko');
              } catch (e) {
                parsedTime = time;
              }
              final info =
                  nickName.isNotEmpty ? '$nickName ・ $parsedTime' : parsedTime;

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: body,
                likeCount: likeCount,
                mediaHtml: '',
                isVideo: false,
                info: info,
                time: time,
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

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: csrf,
      time: time,
      info: info,
      userInfo: UserInfo(
        id: user,
        nickName: nickName,
        nickImage: nickImage,
      ),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    final result = Right<Failure, Details>(detail);
    sendPort.send(result);
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    int lastId,
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
            lastId,
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
    final elementList = document.querySelectorAll("a.list_item.symph-row");

    for (final element in elementList) {
      final id = int.tryParse(element.attributes['data-board-sn'] ?? '') ?? 0;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final userId = element.attributes['data-author-id']?.trim() ?? '';
      final tmpUrl = element.attributes['href']?.trim() ?? '';
      final url = BaseParser.covertUrl(baseUrl, tmpUrl);

      final reply = element.attributes['data-comment-count']?.trim() ?? '';

      var board = '';
      final end = url.lastIndexOf('/');
      final start = url.lastIndexOf('/', end - 1);
      try {
        board = url.substring(start + 1, end);
      } catch (e) {
        continue;
      }

      final category = element
              .querySelector(
                  'div.list_infomation > div.list_number > span.category')
              ?.text
              .trim() ??
          '';
      if (category == '공지') continue;

      final title = element
              .querySelector(
                  'div.list_title > div.list_subject > span[data-role=list-title-text]')
              ?.text
              .trim() ??
          '';
      final time = element
              .querySelector(
                  'div.list_infomation > div.list_number > div.list_time > span')
              ?.text
              .trim() ??
          '';
      final nickImage = element
              .querySelector(
                  'div.list_infomation > div.list_author > span.nickimg > img')
              ?.attributes['src'] ??
          '';
      final hit = element
              .querySelector(
                  'div.list_infomation > div.list_number > div.list_hit > span')
              ?.text
              .trim() ??
          '';
      final like = element
              .querySelector('div.list_title > div.list_symph > span')
              ?.text
              .trim() ??
          '';
      final nickName = element
              .querySelector(
                  'div.list_infomation > div.list_author > span.nickname')
              ?.text
              .trim() ??
          '';
      final hasImage =
          element.querySelector('div.list_title > span.fa-picture-o') != null;

      var parsedTime = '';
      try {
        var dateTime = parseDateTime(time);
        parsedTime = timeago.format(dateTime, locale: 'ko');
      } catch (e) {
        parsedTime = time;
      }

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
}
