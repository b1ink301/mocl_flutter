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
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

class ClienParser implements BaseParser {
  final bool isShowNickImage;

  const ClienParser(this.isShowNickImage);

  @override
  SiteType get siteType => SiteType.clien;

  @override
  String get baseUrl => 'https://m.clien.net';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response<dynamic> response) =>
      throw UnimplementedError('main');

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as String;
    final showNickImage = isShowNickImage;
    return Isolate.run(() => _parseDetail(responseData, showNickImage));
  }

  static Either<Failure, Details> _parseDetail(
    String responseData,
    bool isShowNickImage,
  ) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
    var index = 0;
    final container = document.querySelector(
      'body > div.nav_container > div.content_view',
    );
    // document.querySelector('body > div.nav_container > div.nav_body > div.nav_content > div.content_view');

    final csrf =
        document
            .querySelector(
              "body > nav.navigation > div.dropdown-menu > form > input[name=_csrf]",
            )
            ?.attributes['value'] ??
        '';
    final title =
        container
            ?.querySelector("div.post_title > div.post_subject > span")
            ?.text
            .trim() ??
        '';
    final timeElement = container?.querySelector(
      "div.post_information > div.post_time > div.post_date",
    );

    // MoclLogger.log('timeElement = ${timeElement?.outerHtml}');
    timeElement?.querySelectorAll('.fa').forEach((element) => element.remove());
    var time = timeElement?.text.trim() ?? '';
    final tmp = time.split('수정일 :');
    final times = tmp.map((item) => item.trim()).toList();
    time = times.join('|');

    final bodyHtmlElement = container?.querySelector(
      "div.post_view > div.post_content > article > div.post_article",
    );
    bodyHtmlElement
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());
    final linkHtml =
        container
            ?.querySelector("div.post_view > div.attached_link > div.link_list")
            ?.innerHtml ??
        '';

    final marketHtmlElement = container?.querySelector(
      "div.post_view > div.market_product",
    );

    marketHtmlElement
        ?.querySelectorAll('div.product_address')
        .forEach((element) => element.remove());

    final recentsElement = container?.querySelector("div.writer_board");

    MoclLogger.log('recentsElement=${recentsElement?.innerHtml}');

    final recentsWritersElement = container?.querySelector("div.writer_menu");

    MoclLogger.log('recentsWritersElement=${recentsWritersElement?.innerHtml}');

    final bodyHtml = bodyHtmlElement?.innerHtml ?? '';
    final viewCountElement = container?.querySelector(
      "div.post_information > div.post_time > div.view_count",
    );
    viewCountElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    final viewCount = viewCountElement?.text.trim() ?? '';

    final authorIpElement = container?.querySelector(
      "div.post_view > div.post_information > div.author_ip",
    );
    authorIpElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());

    final user =
        container
            ?.querySelector(
              "div.post_view > div.post_contact > span.contact_note > div.post_memo > div.memo_box > button.button_input",
            )
            ?.attributes['onclick'] ??
        '';
    var nickName = '';
    var nickImage = '';
    if (isShowNickImage) {
      nickName =
          container
              ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickname",
              )
              ?.text
              .trim() ??
          '';
      nickImage =
          container
              ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickimg > img",
              )
              ?.attributes['src'] ??
          '';
    } else {
      nickName =
          container
              ?.querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickname",
              )
              ?.text
              .trim() ??
          '';
      if (nickName.isEmpty) {
        nickName =
            container
                ?.querySelector(
                  "div.post_view > div.post_contact > span.contact_name > span.nickimg > img",
                )
                ?.attributes['alt'] ??
            '';
      }
    }
    final likeCount =
        container
            ?.querySelector(
              "div.post_button > div.symph_area > button.symph_count > strong",
            )
            ?.text
            .trim() ??
        '';

    var parsedTime = '';
    try {
      var dateTime = ParserDateTime.parse(times.first);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = BaseParser.parserInfo(
      nickImage.isNotEmpty,
      nickName,
      parsedTime,
      viewCount,
    );

    final comments =
        container
            ?.querySelectorAll(
              "div.post_comment > div.comment > div.comment_row",
            )
            .map((element) {
              if (element.innerHtml == "<span>삭제 되었습니다.</span>") {
                return null;
              }
              final id = element.attributes['data-author-id'] ?? '';
              final isReply = element.classes.contains('re');

              final timeElement = element.querySelector(
                "div.comment_info > div.comment_info_area > div.comment_time",
              );
              timeElement?.querySelector("span.timestamp")?.remove();
              final time = timeElement?.text.trim() ?? '';

              var nickName = '';
              var nickImage = '';

              if (isShowNickImage) {
                nickName =
                    element
                        .querySelector(
                          "div.comment_info > div.post_contact > span.contact_name > span.nickname",
                        )
                        ?.text
                        .trim() ??
                    '';
                nickImage =
                    element
                        .querySelector(
                          "div.comment_info > div.post_contact > span.contact_name > span.nickimg > img",
                        )
                        ?.attributes['src'] ??
                    '';
              } else {
                nickName =
                    element
                        .querySelector(
                          "div.comment_info > div.post_contact > span.contact_name > span.nickname",
                        )
                        ?.text
                        .trim() ??
                    '';
                if (nickName.isEmpty) {
                  nickName =
                      element
                          .querySelector(
                            "div.comment_info > div.post_contact > span.contact_name > span.nickimg > img",
                          )
                          ?.attributes['alt'] ??
                      '';
                }
              }

              final likeCount =
                  element
                      .querySelector(
                        "div.comment_content_symph > button > strong",
                      )
                      ?.text
                      .trim() ??
                  '';
              final bodyElements = element.querySelectorAll(
                "div.comment_content > div.comment_view, div.comment-img, div.comment-video",
              );
              for (final tmp in bodyElements) {
                tmp
                    .querySelectorAll('input, span.name, button')
                    .forEach((element) => element.remove());
              }

              final body = bodyElements
                  .map((item) => item.innerHtml.trim())
                  .join();
              var parsedTime = '';
              try {
                var dateTime = ParserDateTime.parse(time);
                parsedTime = timeago.format(dateTime, locale: 'ko');
              } catch (e) {
                parsedTime = time;
              }
              final info = nickName.isNotEmpty
                  ? '$nickNameㆍ$parsedTime'
                  : parsedTime;

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

    var marketHtml = marketHtmlElement?.innerHtml ?? '';
    var newBodyHtml = '';
    if (marketHtml.isNotEmpty) {
      marketHtml = marketHtml.replaceAll(
        '</span>',
        '&nbsp;&nbsp;&nbsp;</span>',
      );
      newBodyHtml = '$marketHtml</br>$bodyHtml';
    }
    if (linkHtml.isNotEmpty) {
      newBodyHtml += '$bodyHtml</br>$linkHtml';
    }
    if (newBodyHtml.isEmpty) {
      newBodyHtml = bodyHtml;
    }

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: csrf,
      time: time,
      info: info,
      userInfo: UserInfo(id: user, nickName: nickName, nickImage: nickImage),
      comments: comments,
      bodyHtml: newBodyHtml,
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
        isShowNickImage: isShowNickImage,
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
    final isShowNickImage = message.isShowNickImage;

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    final document = parse(responseData);
    final elementList = document.querySelectorAll("a.list_item.symph-row");

    for (final element in elementList) {
      final id = int.tryParse(element.attributes['data-board-sn'] ?? '') ?? 0;
      if (id <= 0 || lastId > 0 && id >= lastId) {
        MoclLogger.log('[SKIP] id=$id, lastId=$lastId');
        continue;
      }

      final userId = element.attributes['data-author-id']?.trim() ?? '';
      final tmpUrl = element.attributes['href']?.trim() ?? '';
      final url = tmpUrl.toUrl(baseUrl);

      final reply = element.attributes['data-comment-count']?.trim() ?? '';

      var board = '';
      final end = url.lastIndexOf('/');
      final start = url.lastIndexOf('/', end - 1);
      try {
        board = url.substring(start + 1, end);
      } catch (e) {
        continue;
      }

      final category =
          element
              .querySelector(
                'div.list_infomation > div.list_number > span.category',
              )
              ?.text
              .trim() ??
          '';
      if (category == '공지') continue;

      final title =
          element
              .querySelector(
                'div.list_title > div.list_subject > span[data-role=list-title-text]',
              )
              ?.text
              .trim() ??
          '';
      final time =
          element
              .querySelector(
                'div.list_infomation > div.list_number > div.list_time > span',
              )
              ?.text
              .trim() ??
          '';

      final hit =
          element
              .querySelector(
                'div.list_infomation > div.list_number > div.list_hit > span',
              )
              ?.text
              .trim() ??
          '';
      final like =
          element
              .querySelector('div.list_title > div.list_symph > span')
              ?.text
              .trim() ??
          '';
      final author = element.querySelector(
        'div.list_infomation > div.list_author',
      );
      final nickImg = author?.querySelector('span.nickimg > img');
      final nickName =
          author?.querySelector('span.nickname')?.text.trim() ??
          nickImg?.attributes['alt'] ??
          '';
      final nickImage = isShowNickImage ? nickImg?.attributes['src'] ?? '' : '';

      final hasImage =
          element.querySelector('div.list_title > span.fa-picture-o') != null;

      var parsedTime = '';
      try {
        final dateTime = ParserDateTime.parse(time);
        parsedTime = timeago.format(dateTime, locale: 'ko');
      } catch (e) {
        parsedTime = time;
      }

      final info = BaseParser.parserInfo(
        nickImage.isNotEmpty,
        nickName,
        parsedTime,
        hit,
      );

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
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final String sort = sortType.toQuery(siteType);
    return board == "recommend"
        ? url
        : 'https://m.clien.net/service/api/board/under/list?category=0&boardSn=0&po=$page$sort&boardCd=$board';
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    final String searchUrl = url.replaceFirst('board', 'search/board');
    return '$searchUrl?sk=title&sv=$keyword&po=$page';
  }

  @override
  String urlByMain() {
    throw UnimplementedError('urlByMain');
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response<dynamic> response) {
    throw UnimplementedError();
  }

  @override
  String urlByComments(String url, String board, int id, int page) {
    throw UnimplementedError();
  }
}
