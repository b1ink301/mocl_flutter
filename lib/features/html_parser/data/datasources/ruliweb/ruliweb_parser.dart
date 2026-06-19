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
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

/// 루리웹(m.ruliweb.com) 파서.
///
/// `/best/{slug}` (베스트 모음) 과 `/community/board/{id}` (일반 게시판) 의
/// 리스트는 모두 `tr.table_body.blocktarget` 행 구조를 공유하므로 하나의
/// 워커로 처리한다. 상세/댓글은 단일 GET 응답 안에 모두 포함된다.
class RuliwebParser extends BaseParser {
  const RuliwebParser();

  @override
  SiteType get siteType => SiteType.ruliweb;

  @override
  String get baseUrl => 'https://m.ruliweb.com';

  @override
  String urlByDetail(String url, String board, int id) => url;

  @override
  String urlByMain() => 'https://www.ruliweb.com/';

  /// PC 홈(서버 렌더)의 게시판 링크(`/board/{id}`)를 파싱해 모바일 커뮤니티
  /// 게시판 URL 로 변환한다.
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
    for (final a in document.querySelectorAll('a[href*="/board/"]')) {
      final match = RegExp(
        r'/board/(\d+)',
      ).firstMatch(a.attributes['href'] ?? '');
      if (match == null) continue;
      final board = match.group(1)!;
      if (!seen.add(board)) continue;
      final name = a.text.trim();
      // '+', '더보기', 숫자만 등 비-게시판 텍스트 제외.
      if (name.isEmpty ||
          name.length > 20 ||
          RegExp(r'^[\d+\s]+$').hasMatch(name) ||
          name.contains('더보기')) {
        continue;
      }
      items.add(
        MainItem(
          siteType: SiteType.ruliweb,
          board: board,
          text: name,
          url: 'https://m.ruliweb.com/community/board/$board',
          orderBy: orderBy++,
        ),
      );
    }
    if (items.isEmpty) {
      return Left(GetMainFailure(message: '게시판 목록을 찾지 못했습니다.'));
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
    return '$url${separator}search_type=subject_content&search_key=$keyword&page=$page';
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
    final elementList = document.querySelectorAll('tr.table_body.blocktarget');

    final items = <ListItem>[];

    for (final element in elementList) {
      // 인기글(베스트) 미리보기 행은 작성자/시간/조회 컬럼 없이 렌더되는 중복
      // 행이라(아래 일반 목록에 다시 등장) 스킵해 메타 없는 항목을 거른다.
      if (element.className.contains('best')) continue;

      final anchor = element.querySelector('a.subject_link');
      final tmpUrl = anchor?.attributes['href']?.trim();
      if (anchor == null || tmpUrl == null || tmpUrl.isEmpty) continue;
      final url = tmpUrl.toUrl(baseUrl);

      // .../board/{boardId}/read/{articleId}?...
      final int id = _readId(url);
      if (id <= 0 || (lastId > 0 && id >= lastId)) continue;
      final String board = _boardId(url);

      // 댓글 수는 베스트 리스트에선 제목 앵커 안에, 일반 게시판에선 info 행에
      // 위치하므로 앵커를 정리하기 전에 먼저 읽는다.
      final String reply = element.qText('span.replycount span.num');

      // 제목 텍스트만 남기고 댓글 수 뱃지/아이콘만 제거.
      // 일부 게시판(정보/모바일)은 제목을 `<span class="deco">` 로 감싸므로
      // span 전체를 지우면 제목이 사라진다 → 댓글수/아이콘 span 만 선택 제거한다.
      anchor.removeAll('span.num_reply, span.replycount, i');
      final String title = anchor.text.trim();

      final String category = element
          .qText('a.cate_label')
          .replaceAll(RegExp(r'[\[\]]'), '')
          .trim();
      final String like = element.qText('span.recomd');
      final String hit = element.qText('span.hit');
      final String time = element.qText('span.time');

      final writerEl = element.querySelector('span.writer');
      writerEl.removeAll('input');
      final String nickName = writerEl?.text.trim() ?? '';
      final String userId =
          element.querySelector('input.member_srl')?.attributes['value'] ?? '';

      final bool hasImage = element.querySelector('i.icon-picture') != null;

      final String parsedTime = formatTimeago(time);
      final String info = BaseParser.parserInfo(false, nickName, parsedTime, hit);

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
          userInfo: UserInfo(id: userId, nickName: nickName, nickImage: ''),
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
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);

    final title = document.qText('span.subject_text span.subject_inner_text');

    final userView = document.querySelector('div.user_view');
    final nickName = userView.qText('a.nick');
    final viewCount = userView.qText('span.hit');
    final likeCount = userView.qText('span.recomd');
    final rawTime = userView.qText('span.regdate');
    final time = _normalizeDate(rawTime);

    final bodyEl = document.querySelector('div.view_content');
    bodyEl.removeAll('input, button, script');
    final bodyHtml = bodyEl?.innerHtml ?? '';

    final parsedTime = formatTimeago(time);
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

    final commentEls = document.querySelectorAll('tr.comment_element');
    final comments = <CommentItem>[];
    var index = 0;
    for (final element in commentEls) {
      final bool isReply = element.classes.contains('child');

      final bodyWrappers = element.querySelectorAll('div.text_wrapper');
      for (final w in bodyWrappers) {
        w.removeAll('input, button');
      }
      final body = bodyWrappers.map((w) => w.innerHtml.trim()).join();
      if (body.isEmpty) continue;

      final cNick = element.qText('strong.nick');
      final cTime = _normalizeDate(
        element.qText('span.time').replaceFirst('|', '').trim(),
      );
      final cLike = element.qText('button.btn_like span.num');
      final cMember =
          element.querySelector('input.member_srl')?.attributes['value'] ?? '';
      final int cId =
          int.tryParse(element.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? index;
      index++;

      final cParsedTime = formatTimeago(cTime);
      final cInfo = cNick.isNotEmpty ? '$cNickㆍ$cParsedTime' : cParsedTime;

      comments.add(
        CommentItem(
          id: cId,
          isReply: isReply,
          bodyHtml: body,
          likeCount: cLike,
          mediaHtml: '',
          isVideo: false,
          info: cInfo,
          time: cTime,
          userInfo: UserInfo(id: cMember, nickName: cNick, nickImage: ''),
          authorId: '',
        ),
      );
    }

    final detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time,
      info: info,
      userInfo: UserInfo(id: nickName, nickName: nickName, nickImage: ''),
      comments: comments,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(detail);
  }

  /// `.../board/{boardId}/read/{articleId}?...` 에서 articleId 추출.
  static int _readId(String url) {
    final match = RegExp(r'/read/(\d+)').firstMatch(url);
    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }

  /// `.../board/{boardId}/...` 에서 boardId 추출.
  static String _boardId(String url) {
    final match = RegExp(r'/board/(\d+)').firstMatch(url);
    return match?.group(1) ?? '';
  }

  /// 루리웹은 `26.06.16 (13:30:13)` 처럼 2자리 연도/괄호를 쓰므로
  /// `2026.06.16 13:30:13` 형태로 정규화해 ParserDateTime 이 인식하게 한다.
  static String _normalizeDate(String raw) {
    var s = raw.replaceAll('(', ' ').replaceAll(')', ' ').trim();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    // 선두 2자리 연도(예: 26.06.16) → 4자리(2026.06.16)
    s = s.replaceFirstMapped(
      RegExp(r'^(\d{2})([.\-]\d{1,2}[.\-]\d{1,2})'),
      (m) => '20${m.group(1)}${m.group(2)}',
    );
    return s;
  }
}
