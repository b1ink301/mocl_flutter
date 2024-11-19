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
class ClienParser extends BaseParser {
  @override
  SiteType get siteType => SiteType.clien;

  @override
  String get baseUrl => 'https://m.clien.net';

  @override
  Future<Result> comment(Response response) {
    // TODO: implement comment
    throw UnimplementedError();
  }

  static DateTime parseDateTime(String dateTimeString) {
    var times = dateTimeString.split(' ');

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
  Future<Result> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();

    await Isolate.spawn(_detailIsolate, [responseData, resultPort.sendPort]);

    final result = await resultPort.first as Result;
    return result;
  }

  static void _detailIsolate(List<dynamic> args) {
    final responseData = args[0] as String;
    final sendPort = args[1] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    var document = parse(responseData);
    var index = 0;
    final container =
        document.querySelector('body > div.nav_container > div.content_view');

    var csrf = document
            .querySelector(
                "body > nav.navigation > div.dropdown-menu > form > input[name=_csrf]")
            ?.attributes['value'] ??
        '';
    var title = container
            ?.querySelector("div.post_title > div.post_subject > span")
            ?.text
            .trim() ??
        '';
    var timeElement = container
        ?.querySelector("div.post_information > div.post_time > div.post_date");

    // debugPrint('timeElement = ${timeElement?.outerHtml}');
    timeElement?.querySelectorAll('.fa').forEach((element) => element.remove());
    var time = timeElement?.text.trim() ?? '';
    var tmp = time.split('수정일 :');
    var times = tmp.map((item) => item.trim()).toList();
    time = times.join('|');

    var bodyHtmlElement = container?.querySelector(
        "div.post_view > div.post_content > article > div.post_article");
    bodyHtmlElement
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());
    var bodyHtml = bodyHtmlElement?.outerHtml ?? '';
    var viewCountElement = container?.querySelector(
        "div.post_information > div.post_time > div.view_count");
    viewCountElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    var viewCount = viewCountElement?.text.trim() ?? '';

    var authorIpElement = container
        ?.querySelector("div.post_view > div.post_information > div.author_ip");
    authorIpElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    // var authorIp = authorIpElement?.text.trim() ?? '';
    var user = container
            ?.querySelector(
                "div.post_view > div.post_contact > span.contact_note > div.post_memo > div.memo_box > button.button_input")
            ?.attributes['onclick'] ??
        '';
    var nickName = container
            ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickname")
            ?.text
            .trim() ??
        '';
    var nickImage = container
            ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickimg > img")
            ?.attributes['src'] ??
        '';
    var likeCount = container
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

    var comments = container
            ?.querySelectorAll(
                "div.post_comment > div.comment > div.comment_row")
            .map((element) {
              if (element.innerHtml == "<span>삭제 되었습니다.</span>") {
                return null;
              }
              var id = element.attributes['data-author-id'] ?? '';
              // var sn =
              //     int.tryParse(element.attributes['data-comment-sn'] ?? '-1') ??
              //         -1;
              var isReply = element.classes.contains('re');
              var nickName = element
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
              var timeElement = element.querySelector(
                  "div.comment_info > div.comment_info_area > div.comment_time");
              timeElement?.querySelector("span.timestamp")?.remove();
              var time = timeElement?.text.trim() ?? '';
              var nickImage = element
                      .querySelector(
                          "div.comment_info > div.post_contact > span.contact_name > span.nickimg > img")
                      ?.attributes['src'] ??
                  '';
              var likeCount = element
                      .querySelector(
                          "div.comment_content_symph > button > strong")
                      ?.text
                      .trim() ??
                  '';
              // var bodyElement = element
              //     .querySelector("div.comment_content > div.comment_view");

              var bodyElements = element.querySelectorAll(
                  "div.comment_content, div.comment-img, div.comment-video");
              for (var tmp in bodyElements) {
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
              var info =
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

    var detail = Details(
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
      bodies: [],
      comments: comments,
      bodyHtml: bodyHtml,
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

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    var parsedItems = <Map<String, dynamic>>[];
    var ids = <int>[];

    var document = parse(responseData);
    var elementList = document.querySelectorAll("a.list_item.symph-row");

    for (var element in elementList) {
      var id = int.tryParse(element.attributes['data-board-sn'] ?? '') ?? 0;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      var userId = element.attributes['data-author-id']?.trim() ?? '';
      var tmpUrl = element.attributes['href']?.trim() ?? '';
      final url = BaseParser.covertUrl(baseUrl, tmpUrl);

      var reply = element.attributes['data-comment-count']?.trim() ?? '';

      var board = '';
      var end = url.lastIndexOf('/');
      var start = url.lastIndexOf('/', end - 1);
      try {
        board = url.substring(start + 1, end);
      } catch (e) {
        continue;
      }

      var category = element
              .querySelector(
                  'div.list_infomation > div.list_number > span.category')
              ?.text
              .trim() ??
          '';
      if (category == '공지') continue;

      var title = element
              .querySelector(
                  'div.list_title > div.list_subject > span[data-role=list-title-text]')
              ?.text
              .trim() ??
          '';
      var time = element
              .querySelector(
                  'div.list_infomation > div.list_number > div.list_time > span')
              ?.text
              .trim() ??
          '';
      var nickImage = element
              .querySelector(
                  'div.list_infomation > div.list_author > span.nickimg > img')
              ?.attributes['src'] ??
          '';
      var hit = element
              .querySelector(
                  'div.list_infomation > div.list_number > div.list_hit > span')
              ?.text
              .trim() ??
          '';
      var like = element
              .querySelector('div.list_title > div.list_symph > span')
              ?.text
              .trim() ??
          '';
      var nickName = element
              .querySelector(
                  'div.list_infomation > div.list_author > span.nickname')
              ?.text
              .trim() ??
          '';
      var hasImage =
          element.querySelector('div.list_title > span.fa-picture-o') != null;

      var parsedTime = '';
      try {
        var dateTime = parseDateTime(time);
        parsedTime = timeago.format(dateTime, locale: 'ko');
      } catch (e) {
        parsedTime = time;
      }

      final info = BaseParser.parserInfo(nickName, parsedTime, hit);

      var parsedItem = {
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
    var readStatusResponse = await readStatusPort.first as ReadStatusResponse;
    readStatusPort.close();

    var resultList = parsedItems
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
              isRead: readStatusResponse.statuses[item['id']] ?? false,
            ))
        .toList();

    replyPort.send(resultList);
  }
}
