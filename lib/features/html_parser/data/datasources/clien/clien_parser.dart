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

class ClienParser extends BaseParser {
  final bool isShowNickImage;

  const ClienParser(this.isShowNickImage);

  @override
  SiteType get siteType => SiteType.clien;

  @override
  String get baseUrl => 'https://m.clien.net';

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

    final csrf = document.qAttr(
      "body > nav.navigation > div.dropdown-menu > form > input[name=_csrf]",
      'value',
    );
    final title = container.qText(
      "div.post_title > div.post_subject > span",
    );
    final timeElement = container?.querySelector(
      "div.post_information > div.post_time > div.post_date",
    );

    // MoclLogger.log('timeElement = ${timeElement?.outerHtml}');
    timeElement.removeAll('.fa');
    var time = timeElement?.text.trim() ?? '';
    final tmp = time.split('수정일 :');
    final times = tmp.map((item) => item.trim()).toList();
    time = times.join('|');

    final bodyHtmlElement = container?.querySelector(
      "div.post_view > div.post_content > article > div.post_article",
    );
    bodyHtmlElement.removeAll('input, button');
    final linkHtml =
        container
            ?.querySelector("div.post_view > div.attached_link > div.link_list")
            ?.innerHtml ??
        '';

    final marketHtmlElement = container?.querySelector(
      "div.post_view > div.market_product",
    );

    marketHtmlElement.removeAll('div.product_address');

    final recentsElement = container?.querySelector("div.writer_board");

    MoclLogger.log('recentsElement=${recentsElement?.innerHtml}');

    final recentsWritersElement = container?.querySelector("div.writer_menu");

    MoclLogger.log('recentsWritersElement=${recentsWritersElement?.innerHtml}');

    final bodyHtml = bodyHtmlElement?.innerHtml ?? '';
    final viewCountElement = container?.querySelector(
      "div.post_information > div.post_time > div.view_count",
    );
    viewCountElement.removeAll('.fa');
    final viewCount = viewCountElement?.text.trim() ?? '';

    final authorIpElement = container?.querySelector(
      "div.post_view > div.post_information > div.author_ip",
    );
    authorIpElement.removeAll('.fa');

    final user = container.qAttr(
      "div.post_view > div.post_contact > span.contact_note > div.post_memo > div.memo_box > button.button_input",
      'onclick',
    );
    const nickNameSel =
        "div.post_view > div.post_contact > span.contact_name > span.nickname";
    const nickImgSel =
        "div.post_view > div.post_contact > span.contact_name > span.nickimg > img";
    var nickName = container.qText(nickNameSel);
    var nickImage = '';
    if (isShowNickImage) {
      nickImage = container.qAttr(nickImgSel, 'src');
    } else if (nickName.isEmpty) {
      nickName = container.qAttr(nickImgSel, 'alt');
    }
    final likeCount = container.qText(
      "div.post_button > div.symph_area > button.symph_count > strong",
    );

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

              const nickNameSel =
                  "div.comment_info > div.post_contact > span.contact_name > span.nickname";
              const nickImgSel =
                  "div.comment_info > div.post_contact > span.contact_name > span.nickimg > img";
              var nickName = element.qText(nickNameSel);
              var nickImage = '';
              if (isShowNickImage) {
                nickImage = element.qAttr(nickImgSel, 'src');
              } else if (nickName.isEmpty) {
                nickName = element.qAttr(nickImgSel, 'alt');
              }

              final likeCount = element.qText(
                "div.comment_content_symph > button > strong",
              );
              final bodyElements = element.querySelectorAll(
                "div.comment_content > div.comment_view, div.comment-img, div.comment-video",
              );
              for (final tmp in bodyElements) {
                tmp.removeAll('input, span.name, button');
              }

              final body = bodyElements
                  .map((item) => item.innerHtml.trim())
                  .join();
              final parsedTime = formatTimeago(time);
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

    final document = parse(responseData);
    final elementList = document.querySelectorAll("a.list_item.symph-row");

    final items = <ListItem>[];

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

      final category = element.qText(
        'div.list_infomation > div.list_number > span.category',
      );
      if (category == '공지') continue;

      final title = element.qText(
        'div.list_title > div.list_subject > span[data-role=list-title-text]',
      );
      final time = element.qText(
        'div.list_infomation > div.list_number > div.list_time > span',
      );
      final hit = element.qText(
        'div.list_infomation > div.list_number > div.list_hit > span',
      );
      final like = element.qText('div.list_title > div.list_symph > span');

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

      final parsedTime = formatTimeago(time);
      final info = BaseParser.parserInfo(
        nickImage.isNotEmpty,
        nickName,
        parsedTime,
        hit,
      );

      items.add(
        ListItem(
          id: id,
          title: title,
          reply: reply,
          category: category,
          time: time,
          info: info,
          url: url,
          board: board,
          boardTitle: boardTitle,
          like: like,
          hit: hit,
          userInfo: UserInfo(
            id: userId,
            nickName: nickName,
            nickImage: nickImage,
          ),
          hasImage: hasImage,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://m.clien.net/service';

  /// `/service` 좌측 메뉴(`div.navmenu_group`)를 카테고리(`a.navmenu_title`) +
  /// 게시판(`a.navmenu_menu`) 단위로 파싱한다.
  @override
  Future<Either<Failure, List<MainItem>>> main(Response<dynamic> response) {
    final responseData = response.data as String;
    return Isolate.run(() => _parseMain(responseData));
  }

  static Either<Failure, List<MainItem>> _parseMain(String responseData) {
    final document = parse(responseData);
    final items = <MainItem>[];
    final seen = <String>{};
    var orderBy = 0;
    for (final group in document.querySelectorAll('div.navmenu_group')) {
      final category = group.qText('a.navmenu_title');
      for (final a in group.querySelectorAll('a.navmenu_menu')) {
        final href = a.attributes['href']?.trim() ?? '';
        final match = RegExp(r'/service/board/([a-zA-Z0-9_]+)').firstMatch(href);
        if (match == null) continue;
        final board = match.group(1)!;
        if (!seen.add(board)) continue;
        final name = a.text.trim();
        if (name.isEmpty) continue;
        items.add(
          MainItem(
            siteType: SiteType.clien,
            board: board,
            text: name,
            url: 'https://m.clien.net/service/board/$board',
            orderBy: orderBy++,
            category: category,
          ),
        );
      }
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '게시판 메뉴를 찾지 못했습니다.'));
    }
    return Right(items);
  }

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

}
