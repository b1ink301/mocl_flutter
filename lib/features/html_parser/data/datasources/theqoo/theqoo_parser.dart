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
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';
import 'package:timeago/timeago.dart' as timeago;

class const TheQooParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.theqoo;

  @override
  String get baseUrl => 'https://theqoo.net';

  @override
  String urlByMain() => 'https://theqoo.net/';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as List<dynamic>;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(List<dynamic> responseData) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData.first);
    final container = document.querySelector(
      'html > body > div[id=container] > div.content > section > article',
    );

    final title = container.qText('div.title-wrap > h3');
    final infoElement = container?.querySelector(
      'div.title-wrap > div.under-title',
    );
    final nickName = infoElement.qText('span.name');
    final time = infoElement.qText('span.date');
    final viewCount = infoElement.qText('span.hit');
    final bodyHtml = container?.querySelector('div.read-body > div');
    bodyHtml.removeAll('input, button');

    var likeCount = '';
    final nickImage = '';

    final json = responseData.lastOrNull as Map<String, dynamic>?;
    final comments = <CommentItem>[];

    int nowCommentPage = 0;
    if (json != null) {
      nowCommentPage = json['now_comment_page'] as int? ?? 0;
      final addedNumber = json['added_number'];
      // final documentSrl = json['document_srl'];

      MoclLogger.log(
        'nowCommentPage=$nowCommentPage, addedNumber=$addedNumber',
      );

      final List<dynamic> list = json['comment_list'] as List<dynamic>;
      var index = 1;
      for (final element in list) {
        final String body = element['ct']?.toString() ?? '';
        final String time = element['rd']?.toString() ?? '';
        final int id = element['srl'] as int? ?? -1;

        final int commentIndex = (addedNumber as int) + index++;
        final nickName = '$commentIndex. 무명의 더쿠';
        final info = nickName;

        final comment = CommentItem(
          id: id,
          isReply: false,
          bodyHtml: body,
          likeCount: likeCount,
          mediaHtml: '',
          isVideo: false,
          time: time,
          info: info,
          userInfo: UserInfo(
            id: id.toString(),
            nickName: nickName,
            nickImage: '',
          ),
          authorId: '',
        );

        comments.add(comment);
      }
    }

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(parsedTime, viewCount);

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
      extraData: {'nowCommentPage': nowCommentPage},
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
        isShowNickImage: false,
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

    final document = parse(responseData);
    final elementList = document.querySelectorAll(
      "div[id=container] > div.content > section.flatBoard > div.m-list > ul.list > li",
    );

    final items = <ListItem>[];

    for (final element in elementList) {
      final tmpUrl = element.querySelector('a.list-link')?.attributes['href'];
      if (tmpUrl == null) continue;
      final url = tmpUrl.toUrl(baseUrl);

      final tmp = tmpUrl.split('?');
      final pathList = tmp.firstOrNull?.split('/') ?? [];
      final lastPath = pathList.lastOrNull ?? '';
      final id = int.tryParse(lastPath) ?? 0;
      final userId = lastPath;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final board = pathList[1];
      final reply = element.qText('a.reply');
      final category = element.qText('ul.list-element > li:last-child');
      if (category == '공지') continue;

      final title = element.qText(
        'ul.list-element > li.title > span.title_span',
      );
      final time = element.qText('ul.list-element > li.date');

      final hit =
          element
              .querySelector('ul.list-element > li.hit')
              ?.text
              .trim()
              .split(' ')
              .lastOrNull ??
          '';
      final like = element.qText('div.list_title > div.list_symph > span');

      final info = '$hit 읽음';

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
          userInfo: UserInfo(id: userId, nickName: '', nickImage: ''),
          hasImage: false,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  @override
  Future<Either<Failure, List<MainItem>>> main(
    Response<dynamic> response,
  ) async {
    final responseData = response.data;
    final document = parse(responseData);
    final container = document.querySelector('div[id=cate_index_mobile]');
    if (container == null) {
      return Left(GetMainFailure(message: 'Container is null'));
    }
    // blockquote 단위로 카테고리(p.header) + 게시판(a) 구성.
    var orderBy = 0;
    final result = <MainItem>[];
    final seen = <String>{};
    for (final block in container.querySelectorAll('blockquote')) {
      final category = block.qText('p.header');
      for (final element in block.querySelectorAll('a')) {
        if (element.attributes['class'] != null) continue;
        final href = element.attributes['href']?.toString() ?? '';
        if (!href.startsWith('#') && !href.startsWith('/')) continue;
        final board = href.startsWith('#') ? href.substring(1) : href;
        if (board.isEmpty || !seen.add(board)) continue;
        final title = element.text.trim();
        if (title.isEmpty) continue;
        result.add(
          MainItem(
            siteType: SiteType.theqoo,
            board: board,
            text: title,
            url: baseUrl + board,
            orderBy: orderBy++,
            category: category,
          ),
        );
      }
    }
    if (result.isEmpty) {
      return Left(GetMainFailure(message: '게시판 목록을 찾지 못했습니다.'));
    }
    return Right(result);
  }

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}page=$page';
  }

  // Rhymix 표준 검색: 게시판 URL 에 제목 검색 파라미터를 붙인다. 결과 페이지는
  // 일반 목록과 동일한 레이아웃이라 [list] 파서가 그대로 파싱한다.
  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    final separator = url.contains('?') ? '&' : '?';
    return '$url${separator}_filter=search'
        '&search_target=title&search_keyword=$keyword&page=$page';
  }
}
