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

/// 네이트판(pann.nate.com) 파서.
///
/// 리스트는 실시간 인기톡 랭킹(`/talk/ranking`)을 사용한다. 랭킹은 고정 top-N
/// 목록이라 페이지네이션이 없으므로 단일 페이지 게시판으로 처리한다
/// (list_providers 의 _isSinglePageBoard 참고).
/// 상세 URL: `/talk/{id}`. 본문/베스트 댓글이 단일 GET 응답에 포함된다.
class const NateParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.nate;

  // 리스트/상세 모두 모바일(m.pann) 마크업 기준으로 파싱한다. 데스크톱(pann)은
  // 마크업이 다르고 today/talker 등 일부 게시판은 모바일에만 존재한다.
  @override
  String get baseUrl => 'https://m.pann.nate.com';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) => url; // 랭킹은 단일 페이지.

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) => 'https://pann.nate.com/search/talk?q=$keyword&page=$page';

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

  static final RegExp _idRe = RegExp(r'/talk/(\d+)');

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final responseData = message.responseData as String;
    final boardTitle = message.boardTitle;
    final baseUrl = message.baseUrl;

    final document = parse(responseData);
    final items = <ListItem>[];
    final seen = <int>{};

    // 모바일(m.pann) 리스트 마크업: 항목마다
    //   <a class="cnbox" href="/talk/{id}...">
    //     <span class="thumb"><img></span>
    //     <span class="tit"><h2>제목</h2><span class="count">(3)</span></span>
    //     <span class="sub">조회 <span class="num">N</span> 추천 <span class="num">M</span></span>
    for (final a in document.querySelectorAll('a.cnbox')) {
      final href = a.attributes['href']?.trim() ?? '';
      final int id = int.tryParse(_idRe.firstMatch(href)?.group(1) ?? '') ?? 0;
      if (id <= 0 || !seen.add(id)) continue;

      // 게시판마다 tit/h2 중첩이 반대다:
      //   today  : <span class="tit"><h2>제목</h2><span class="count">(3)</span></span>
      //   ranking: <h2><span class="tit">제목</span></h2><span class="count">(211)</span>
      // span.tit 안에 h2 가 있으면 그 텍스트, 없으면 span.tit 텍스트를 쓴다.
      final String title =
          (a.querySelector('span.tit h2')?.text ?? a.qText('span.tit')).trim();
      if (title.isEmpty) continue;

      // 댓글수 span.count 는 tit 안/밖이 게시판마다 다르므로 anchor 기준 첫 항목.
      final String reply = a
          .qText('span.count')
          .replaceAll(RegExp(r'[^0-9]'), '');
      final nums = a
          .querySelectorAll('span.sub span.num')
          .map((e) => e.text.trim())
          .toList();
      final String hit = nums.isNotEmpty ? nums[0] : '';
      final String like = nums.length > 1 ? nums[1] : '';
      final String url = '$baseUrl/talk/$id';

      final String info = BaseParser.parserInfo('', hit);

      items.add(
        ListItem(
          id: id,
          title: title,
          reply: reply,
          category: '',
          time: '',
          info: info,
          url: url,
          board: 'ranking',
          boardTitle: boardTitle,
          like: like,
          hit: hit,
          userInfo: const UserInfo(id: '', nickName: '', nickImage: ''),
          hasImage: a.querySelector('span.thumb img') != null,
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

    final String title = document.qText('h1.view-tit').isNotEmpty
        ? document.qText('h1.view-tit')
        : (document
                      .querySelector('meta[property="og:title"]')
                      ?.attributes['content'] ??
                  '')
              .replaceFirst(RegExp(r'\s*\|\s*네이트.*$'), '')
              .trim();

    final String nickName = document.qText('div.writer span.nick');
    final String likeCount = document
        .qText('div.updown div.btnbox.up span.count')
        .replaceAll(RegExp(r'[^0-9]'), '');

    final bodyEl = document.querySelector('#pann-content');
    bodyEl.removeAll('script, style, ins, iframe, .adv');
    final String bodyHtml = bodyEl?.innerHtml ?? '';

    final comments = <CommentItem>[];
    var index = 0;
    for (final dl in document.querySelectorAll('div.reply-list dl')) {
      final dd = dl.querySelector('dd.userText');
      if (dd == null) continue;
      final dt = dl.querySelector('dt');

      String cNick = '';
      for (final s in dt?.querySelectorAll('span') ?? const <Element>[]) {
        if (!s.classes.contains('bar')) {
          cNick = s.text.trim();
          break;
        }
      }
      String cTime = '';
      for (final e in dt?.querySelectorAll('em') ?? const <Element>[]) {
        if (!e.classes.contains('best')) cTime = e.text.trim();
      }
      final bool isBest = dl.classes.contains('best');
      dd.removeAll('script, button');
      final String body = dd.text.trim();
      if (body.isEmpty) continue;

      final cInfo = '${isBest ? '[베플] ' : ''}$cTime';

      comments.add(
        CommentItem(
          id: index++,
          isReply: false,
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
      likeCount: likeCount,
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
