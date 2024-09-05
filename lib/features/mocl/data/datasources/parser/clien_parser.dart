import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';

class ClienParser extends BaseParser {
  @override
  SiteType get siteType => SiteType.clien;

  @override
  Future<Result> comment(Response response) {
    // TODO: implement comment
    throw UnimplementedError();
  }

  @override
  Future<Result> detail(Response response) async {
    var document = parse(response.data);
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
    var timeElement = container?.querySelector(
        "div.post_view > div.post_information > div.post_time > div.post_date");
    timeElement?.querySelectorAll('.fa').forEach((element) => element.remove());
    var time = timeElement?.text.trim() ?? '';
    var bodyHtmlElement = container?.querySelector(
        "div.post_view > div.post_content > article > div.post_article");
    bodyHtmlElement
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());
    var bodyHtml = bodyHtmlElement?.outerHtml ?? '';
    var viewCountElement = container?.querySelector(
        "div.post_view > div.post_information > div.post_time > div.view_count");
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
              var time = timeElement?.innerHtml.trim() ?? '';
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
              var bodyElement = element
                  .querySelector("div.comment_content > div.comment_view");
              bodyElement
                  ?.querySelectorAll('input, span.name, button')
                  .forEach((element) => element.remove());
              var body = bodyElement?.outerHtml ?? '';
              var video = element
                      .querySelector("div.comment-video > video > source")
                      ?.attributes['src'] ??
                  '';
              var img = element
                      .querySelector("div.comment-img > img")
                      ?.attributes['src'] ??
                  '';

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: body,
                likeCount: likeCount,
                mediaHtml: img.isEmpty ? video : img,
                isVideo: video.isNotEmpty,
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
      userInfo: UserInfo(
        id: user,
        nickName: nickName,
        nickImage: nickImage,
      ),
      bodies: [],
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return ResultSuccess(data: detail);
  }

  @override
  Future<Result> list(
    Response response,
    int lastId,
    String boardTitle,
    Future<bool> Function(SiteType, int) isRead,
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
          IsolateMessage(
              receivePort.sendPort, response.data, lastId, boardTitle));

      return await completer.future;
    } catch (e) {
      receivePort.close();
      return ResultFailure(failure: GetListFailure(message: e.toString()));
    }
  }

  static void _parseListInIsolate(IsolateMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;

    var parsedItems = <Map<String, dynamic>>[];
    var ids = <int>[];

    var document = parse(responseData);
    var elementList = document.querySelectorAll("a.list_item.symph-row");

    for (var element in elementList) {
      var id = int.tryParse(element.attributes['data-board-sn'] ?? '') ?? 0;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      var url = '';
      var userId = element.attributes['data-author-id']?.trim() ?? '';
      var tmpUrl = element.attributes['href']?.trim() ?? '';
      url = !tmpUrl.startsWith("http") ? 'https://m.clien.net$tmpUrl' : tmpUrl;

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

      var parsedItem = {
        'id': id,
        'title': title,
        'reply': reply,
        'category': category,
        'time': time,
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

    var resultList = parsedItems
        .map((item) => ListItem(
              id: item['id'],
              title: item['title'],
              reply: item['reply'],
              category: item['category'],
              time: item['time'],
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
