import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  Future<Result<Details>> detail(Response response) async {
    final responseData = response.data;
    final resultPort = ReceivePort();

    await Isolate.spawn(
        _detailIsolate, [baseUrl, responseData, resultPort.sendPort]);

    return await resultPort.first as Result<Details>;
  }

  static void _detailIsolate(List<dynamic> args) {
    final baseUrl = args[0] as String;
    final responseData = args[1] as String;
    final sendPort = args[2] as SendPort;

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
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

    final time = infoElement?.querySelectorAll('ul > li')[0].text.trim() ?? '';

    final viewCount =
        infoElement?.querySelectorAll('ul > li')[1].text.trim() ?? '0';
    final likeCount = '';

    var index = 0;
    final comments = container
            ?.querySelectorAll(
                'div.cmt > div.cmt_list_parent > div.cmt_list > article')
            .map((element) {
              final headerElement = element.querySelector('header.cmt_hd');
              final isReply =
                  element.attributes['class']?.contains('reply') ?? false;
              final profileElement = headerElement
                  ?.querySelector('div.pf_wrap > span.pf > img.pf_img');

              debugPrint('headerElement=${headerElement?.innerHtml}');
              final tmpUrl = profileElement?.attributes['src']?.trim() ?? '';
              final nickImage = BaseParser.covertUrl(baseUrl, tmpUrl);
              final nickName = profileElement?.attributes['alt'] ?? '익명';
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
              final info = '$nickName ・ $parsedTime';
              var bodyHtml = body?.innerHtml;

              if (bodyHtml?.startsWith(
                      '<a href="https://meeco.kr/index.php?mid=sticker&') ==
                  true) {
                final atag = HtmlParser(bodyHtml)
                    .parse()
                    .getElementsByTagName('a')
                    .firstOrNull;
                final style = atag?.attributes['style'];
                if (style != null) {
                  final RegExp urlRegex = RegExp(r'url\((https?:\/\/[^)]+)\)');
                  final Match? match = urlRegex.firstMatch(style);

                  if (match != null) {
                    final url = match.group(1)!;
                    bodyHtml = '<img src=$url height="140" width="140">';
                  }
                }
              }

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: bodyHtml ?? '',
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

    sendPort.send(Result.success(detail));
  }

  @override
  Future<Result<List<ListItem>>> list(
    Response response,
    int lastId,
    String boardTitle,
    Future<Map<int, bool>> Function(SiteType, List<int>) isReads,
  ) async {
    final receivePort = ReceivePort();
    final completer = Completer<Result<List<ListItem>>>();

    receivePort.listen((message) async {
      if (message is ReadStatusRequest) {
        final statuses = await isReads(siteType, message.ids);
        message.responsePort.send(ReadStatusResponse(statuses));
      } else if (message is List<ListItem>) {
        completer.complete(Result.success(message));
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
      return Result.failure(GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(IsolateMessage<String> message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData).body;
    if (document == null) {
      return;
    }

    final elementList = document.querySelectorAll(
        'div.wrap > section[id=container] > div > section.ctt > section.neon_board > div[id=list_swipe_area] > div.list_ctt > div.list_document > div.list_d > ul > li');

    for (final element in elementList) {
      final category = element
              .querySelector('span.hot_text, span.notice_text')
              ?.text
              .trim() ??
          '';

      if (category == "공지" || category == "핫글") continue;

      final infoElement = element.querySelector('a.list_link');
      final title = infoElement?.attributes['title']?.trim() ?? '';
      final tmpUrl = infoElement?.attributes['href']?.trim() ?? '';
      final url = BaseParser.covertUrl(baseUrl, tmpUrl);

      final uri = Uri.tryParse(url);
      if (uri == null) continue;
      final idString = uri.pathSegments.lastOrNull ?? '-1';
      final id = int.tryParse(idString) ?? -1;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final nickName = element
              .querySelector('div.list_info > div:first-child')
              ?.text
              .trim() ??
          ''; //:first-child, div:nth-child(2)
      final userId = nickName;
      final reply = element.querySelector("a.list_cmt")?.text.trim() ?? '';

      var board = '';
      final end = url.lastIndexOf("/");
      if (end > 0) {
        final start = url.lastIndexOf("/", end - 1);
        if (start >= 0) {
          board = url.substring(start + 1, end);
        }
      }

      final time = element
              .querySelector('div.list_info > div:nth-child(1)')
              ?.text
              .trim() ??
          '';
      final parsedTime = time;
      final nickImage = '';
      final hit = element
              .querySelector('div.list_info > div:nth-child(2)')
              ?.text
              .trim() ??
          '';
      final like =
          element.querySelector('div.list_info > div.list_vote')?.text.trim() ??
              '';

      final hasImage = false;
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
      final parts = dateTimeString.split(' ');
      final dateParts = parts[0].split('.');
      final timeParts = parts[1].split(':');
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
