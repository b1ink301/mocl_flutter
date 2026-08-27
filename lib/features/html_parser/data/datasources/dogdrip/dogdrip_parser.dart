import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';

import '../base/base_parser.dart';

/// 개드립(dogdrip.net) 파서. Rhymix 기반이지만 커스텀 스킨을 쓴다.
///
/// 리스트 URL: `/{board}` (예: `/dogdrip` 베스트), 페이지는 `?page=N`.
/// 상세 URL: `/{document_srl}`. 본문/댓글이 단일 GET 응답에 모두 포함된다.
/// 상대 시각("1 시간 전")을 그대로 노출하므로 별도 날짜 파싱은 하지 않는다.
class const DogdripParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.dogdrip;

  @override
  String get baseUrl => 'https://www.dogdrip.net';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://www.dogdrip.net/';

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    final String separator = url.contains('?') ? '&' : '?';
    return '$url${separator}page=$page';
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    final String separator = url.contains('?') ? '&' : '?';
    return '$url${separator}search_target=title_content&search_keyword=$keyword&page=$page';
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
    final items = <ListItem>[];
    final seen = <int>{};

    for (final anchor in document.querySelectorAll('a.title-link')) {
      final int id =
          int.tryParse(anchor.attributes['data-document-srl'] ?? '') ?? 0;
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      if (!seen.add(id)) continue;

      final String href = anchor.attributes['href']?.trim() ?? '';
      if (href.isEmpty) continue;
      final String url = href.split('?').first.toUrl(baseUrl);

      // `/{board}/{srl}` 형태면 board 슬러그 추출(`/{srl}` 형태면 빈 값).
      final segs = Uri.tryParse(url)?.pathSegments ?? const [];
      final String board = segs.length >= 2 ? segs[segs.length - 2] : '';

      // 행(li) 조상을 찾아 메타를 읽는다.
      Element? row = anchor;
      for (var k = 0; k < 6 && row != null; k++) {
        if (row.localName == 'li') break;
        row = row.parent;
      }

      final String category =
          row?.querySelector('span.badge')?.text.trim() ?? '';
      if (category.contains('공지')) continue;

      final String title = anchor.text.trim();
      if (title.isEmpty) continue;

      // 제목 옆 댓글 수: <span class="text-primary text-xxsmall">N</span>
      final String reply =
          anchor.parent?.querySelector('span.text-primary')?.text.trim() ?? '';

      final String like =
          row?.querySelector('i.fa-thumbs-up')?.parent?.text.trim() ?? '';
      final String time =
          row?.querySelector('i.fa-clock')?.parent?.text.trim() ?? '';
      final String nickName =
          row?.querySelector('a[class*="member_"]')?.text.trim() ?? '';
      final bool hasImage = row?.querySelector('img.webzine-thumbnail') != null;

      final String info = BaseParser.parserInfo(time, like);

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
          hit: '',
          userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
          hasImage: hasImage,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
  }

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as String;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(String responseData) {
    final document = parse(responseData);

    final String rawTitle =
        document
            .querySelector('meta[property="og:title"]')
            ?.attributes['content'] ??
        '';
    final String title = rawTitle
        .replaceFirst(RegExp(r'\s*-\s*DogDrip\.Net.*$'), '')
        .trim();

    // 본문: class 에 `document_` 토큰이 있는 .xe_content (댓글의 comment_ 와 구분).
    Element? bodyEl;
    for (final e in document.querySelectorAll('.xe_content')) {
      if (e.className.contains('document_')) {
        bodyEl = e;
        break;
      }
    }
    bodyEl.removeAll('script, style, input, button');
    final String bodyHtml = bodyEl?.innerHtml ?? '';

    final headerNick =
        document.querySelector('.ed.document-header a[class*="member_"]') ??
        document.querySelector('.document_header a[class*="member_"]');
    final String nickName = headerNick?.text.trim() ?? '';

    final comments = <CommentItem>[];
    var index = 0;
    for (final c in document.querySelectorAll('.comment-item')) {
      final bool isReply = c.className.contains('depth');

      final nickEl = c.querySelector('.comment-bar a[class*="member_"]');
      nickEl?.querySelectorAll('img').forEach((e) => e.remove());
      final String cNick = nickEl?.text.trim() ?? '';
      final String cTime =
          c.querySelector('.comment-bar .text-muted')?.text.trim() ?? '';

      Element? cBody;
      for (final e in c.querySelectorAll('.xe_content')) {
        if (e.className.contains('comment_')) {
          cBody = e;
          break;
        }
      }
      cBody.removeAll('script, button');
      final String body = cBody?.innerHtml.trim() ?? '';
      if (body.isEmpty && cNick.isEmpty) continue;

      final cInfo = cTime;

      comments.add(
        CommentItem(
          id: index++,
          isReply: isReply,
          bodyHtml: body,
          likeCount: '',
          mediaHtml: '',
          isVideo: false,
          info: cInfo,
          time: cTime,
          userInfo: UserInfo(id: cNick, nickName: cNick, nickImage: ''),
          authorId: '',
        ),
      );
    }

    final info = BaseParser.parserInfo('', '');

    final detail = Details(
      title: title,
      viewCount: '',
      likeCount: '',
      csrf: '',
      time: '',
      info: info,
      userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }
}
