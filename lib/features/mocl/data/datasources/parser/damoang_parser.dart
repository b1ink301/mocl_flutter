import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:timeago/timeago.dart' as timeago;

class DamoangParser implements BaseParser {
  const DamoangParser();

  @override
  SiteType get siteType => SiteType.damoang;

  @override
  String get baseUrl => 'https://damoang.net';

  @override
  Either<Failure, List<MainItem>> main(Response response) =>
      throw UnimplementedError('main');

  @override
  Future<Result> comment(Response response) =>
      throw UnimplementedError('comment');

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
    final container = document.querySelector('article[id=bo_v]');
    final title =
        container?.querySelector('header > h1[id=bo_v_title]')?.text.trim() ??
            '';
    final timeElement = container?.querySelector(
        'section[id=bo_v_info] > div.d-flex > div:last-child'); //:first-child, div:nth-child(2)
    timeElement?.querySelector("span.visually-hidden")?.remove();
    final time = timeElement?.text.trim() ?? '';
    final bodyHtml =
        container?.querySelector('section[id=bo_v_atc] > div[id=bo_v_con]');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    final headerElements = container
        ?.querySelectorAll('section[id=bo_v_info] > div.gap-1 > div.pe-2');

    headerElements?.forEach((element) => element
        .querySelectorAll('i, span.visually-hidden')
        .forEach((e) => e.remove()));

    var viewCount = '';
    var likeCount = '';
    if (headerElements?.length == 2) {
      viewCount = headerElements?.elementAtOrNull(0)?.text.trim() ?? '';
      likeCount = headerElements?.elementAtOrNull(1)?.text.trim() ?? '';
    } else if (headerElements?.length == 3) {
      try {
        viewCount = headerElements?.elementAtOrNull(0)?.text.trim() ?? '';
        int.parse(viewCount);
      } catch (e) {
        viewCount = headerElements?.elementAtOrNull(1)?.text.trim() ?? '';
      }
      likeCount = headerElements?.elementAtOrNull(2)?.text.trim() ?? '';
    } else if (headerElements?.length == 4) {
      viewCount = headerElements?.elementAtOrNull(1)?.text.trim() ?? '';
      likeCount = headerElements?.elementAtOrNull(3)?.text.trim() ?? '';
    }

    // final authorIp = container
    //         ?.querySelector('section[id=bo_v_info] > div > div.me-auto')
    //         ?.attributes['data-bs-title'] ??
    //     '';
    final memberElement = container?.querySelector(
        'section[id=bo_v_info] > div.d-flex > div.me-auto > span.d-inline-block > span.sv_wrap > a.sv_member');

    final nickName = memberElement?.text.trim() ?? '';
    final nickImage = memberElement
            ?.querySelector('span.profile_img > img')
            ?.attributes['src'] ??
        '';

    var index = 0;
    final comments = container
            ?.querySelectorAll('div[id=viewcomment] > section > article')
            .map((element) {
              final nickElement = element.querySelector(
                  'div.comment-list-wrap > header > div.d-flex > div.me-2 > span.d-inline-block > span.sv_wrap > a.sv_member');

              final url = nickElement?.attributes['href'] ?? '';
              final uri = Uri.parse(url);
              final id = uri.queryParameters['mb_id'] ?? '-1';
              final nickName = nickElement?.text.trim() ?? '';
              final isReply = element.querySelector(
                      'div.comment-list-wrap > header > div > div.me-2 > i.bi') !=
                  null;
              // final ip = element
              //         .querySelector(
              //             'div.comment_info > div.comment_info_area > div.comment_ip > span.ip_address')
              //         ?.text ??
              //     '';
              final timeElement = element.querySelector(
                  'div.comment-list-wrap > header > div > div.ms-auto');
              timeElement?.querySelector("span.visually-hidden")?.remove();
              final time = timeElement?.text.trim() ?? '';

              final nickImage = nickElement
                      ?.querySelector('span.profile_img > img.mb-photo')
                      ?.attributes['src']
                      ?.trim() ??
                  '';

              final likeCount = element
                      .querySelector(
                          'div.comment-content > div.d-flex > div:last-child > button:last-child > span:first-child')
                      ?.text
                      .trim() ??
                  '';

              final body =
                  element.querySelector('div.comment-content > div.na-convert');
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
              final info = '$nickName ・ $parsedTime';

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: body?.innerHtml ?? '',
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
        ),
      );

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
    // final baseUrl = message.baseUrl;

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
    final elementList = document.querySelectorAll(
        'form[id=fboardlist] > section[id=bo_list] > ul.list-group > li.list-group-item > div.d-flex');

    for (final element in elementList) {
      var category = element
              .querySelector('div.wr-num > div > span')
              ?.text
              .trim()
              .split(' ')
              .firstOrNull ??
          '';

      if (category == "공지" || category == "홍보") continue;

      final infoElement = element.querySelector('div.flex-grow-1');
      final link = infoElement?.querySelector("div.d-flex > div > a");
      if (link == null) continue;

      final url = link.attributes["href"]?.trim() ?? '';
      final uri = Uri.tryParse(url);
      if (uri == null) continue;
      final idString = uri.pathSegments.lastOrNull ?? '-1';
      final id = int.tryParse(idString) ?? -1;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final metaElement = infoElement?.querySelector(
          'div.da-list-meta > div.d-flex > div.wr-name > span.sv_wrap > a.sv_member');
      final profile = metaElement?.attributes['href'] ?? '';
      final nickName = metaElement?.text.trim() ?? '';
      final userId = Uri.parse(profile).queryParameters['mb_id'] ?? '';

      final reply = infoElement
              ?.querySelectorAll("div.d-flex > div.d-inline-flex > a")
              .map((a) => a.querySelector('span.count-plus')?.text.trim())
              .firstWhere((text) => text != null && text.isNotEmpty,
                  orElse: () => '') ??
          '';

      var board = '';
      final end = url.lastIndexOf("/");
      if (end > 0) {
        final start = url.lastIndexOf("/", end - 1);
        if (start >= 0) {
          board = url.substring(start + 1, end);
        }
      }

      final title = link.text.trim();

      final timeElement =
          infoElement?.querySelector("div > div.d-flex > div.wr-date");

      timeElement
          ?.querySelectorAll("span.visually-hidden, i.bi")
          .forEach((ele) => ele.remove());

      final time = timeElement?.text.trim() ?? '';
      var parsedTime = '';
      try {
        var dateTime = parseDateTime(time);
        parsedTime = timeago.format(dateTime, locale: 'ko');
      } catch (e) {
        parsedTime = time;
      }

      final nickImage = metaElement
              ?.querySelector("span.profile_img > img.mb-photo")
              ?.attributes["src"]
              ?.trim() ??
          '';

      final hitElement =
          infoElement?.querySelector("div > div.d-flex > div.wr-num.order-4");
      hitElement?.querySelector("span.visually-hidden")?.remove();
      final hit = hitElement?.text.trim() ?? '';

      final likeElement =
          infoElement?.querySelector("div.wr-num > div.rcmd-box");
      likeElement
          ?.querySelectorAll("span.visually-hidden, i.bi")
          .forEach((ele) => ele.remove());
      final like = likeElement?.text.trim() ?? '';

      final hasImage = infoElement
              ?.querySelector("div.d-flex > div > span.na-icon")
              ?.hasContent() ??
          false;

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
              isRead: readStatusResponse.statuses.contains(item['id']),
            ))
        .toList();

    replyPort.send(resultList);
  }

  static DateTime parseDateTime(String dateTimeString) {
    if (dateTimeString.contains(' ')) {
      // 년.월.일 형식
      final parts = dateTimeString.split(' ');
      final dateParts = parts[0].split('.');
      final timeParts = parts[1].split(':');
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
      final timeParts = dateTimeString.split(':');
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
