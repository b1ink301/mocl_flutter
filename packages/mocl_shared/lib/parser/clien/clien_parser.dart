import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_comment_item.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_shared/error/failures.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:mocl_shared/parser/base/base_ext.dart';
import 'package:mocl_shared/parser/base/parser_date_time.dart';
import 'package:mocl_shared/parser/base/parser_isolate_client.dart';
import 'package:mocl_shared/parser/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

class const ClienParser(final bool isShowNickImage) extends BaseParser {
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

  static final RegExp _kCsrfPattern = RegExp(
    r'''setRequestHeader\(\s*["']X-CSRF-TOKEN["']\s*,\s*["']([^"']+)["']''',
  );
  static final RegExp _kIsLoginPattern = RegExp(
    r'\bIS_LOGIN\s*=\s*(true|false)\b',
  );
  static final RegExp _kSessionUserPattern = RegExp(
    r'''\bsessionUserId\s*=\s*["']([^"']*)["']''',
  );

  /// 페이지 스크립트로 로그인 여부를 판단한다.
  ///
  /// 클리앙은 `let IS_LOGIN = false;` 로 선언한 뒤 로그인 사용자에게만
  /// `IS_LOGIN = true; sessionUserId = "...";` 를 다시 대입한다(서버 템플릿이
  /// 그려 주므로 JS 를 실행하지 않아도 HTML 에 그대로 있다). 그래서 첫 값이
  /// 아니라 **마지막** 대입을 보고, 세션 사용자 id 가 채워졌는지도 함께 본다.
  ///
  /// 셋 다 비어 있다면 파싱이 아니라 요청에 세션 쿠키(`CLIEN_SESSION`,
  /// `Path=/service`)가 실리지 않은 것이다.
  static bool _parseIsLoggedIn(String html) {
    final String? lastIsLogin = _kIsLoginPattern
        .allMatches(html)
        .lastOrNull
        ?.group(1);

    MoclLogger.d(() => 'lastIsLogin = $lastIsLogin');

    if (lastIsLogin == 'true') return true;
    final String sessionUserId =
        _kSessionUserPattern.allMatches(html).lastOrNull?.group(1) ?? '';

    MoclLogger.d(() => 'sessionUserId = $sessionUserId');

    return sessionUserId.isNotEmpty;
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

    // 댓글 쓰기 등 POST 에 붙일 CSRF. 페이지의 `$.ajaxSetup` 이 넣는 값을 쓴다
    // (로그아웃 폼 값은 비로그인이면 없다).
    final csrfMatch = _kCsrfPattern.firstMatch(responseData);
    final csrf =
        csrfMatch?.group(1) ??
        document.qAttr(
          "body > nav.navigation > div.dropdown-menu > form > input[name=_csrf]",
          'value',
        );

    // 서버가 로그인 사용자에게만 채워 주는 값이라 스크립트 판단의 보조로 쓴다.
    final isLoggedIn =
        _parseIsLoggedIn(responseData) ||
        document.qAttr('input#loginUserId', 'value').isNotEmpty;
    final commentParams = <String, String>{
      for (final key in const ['boardCd', 'boardSn', 'writer'])
        key: document.qAttr('input#$key', 'value'),
    };
    final title = container.qText("div.post_title > div.post_subject > span");
    final timeElement = container?.querySelector(
      "div.post_information > div.post_time > div.post_date",
    );

    // MoclLogger.d(() => 'timeElement = ${timeElement?.outerHtml}');
    timeElement.removeAll('.fa');
    var time = timeElement?.text.trim() ?? '';
    final tmp = time.split('수정일 :');
    final times = tmp.map((item) => item.trim()).toList();
    time = times.join('|');

    final bodyHtmlElement = container?.querySelector(
      "div.post_view > div.post_content > article > div.post_article",
    );
    bodyHtmlElement.removeAll('script, style, ins, input, button');
    final linkHtml =
        container
            ?.querySelector("div.post_view > div.attached_link > div.link_list")
            ?.innerHtml ??
        '';

    final marketHtmlElement = container?.querySelector(
      "div.post_view > div.market_product",
    );

    marketHtmlElement.removeAll('div.product_address');

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
    final info = BaseParser.parserInfo(parsedTime, viewCount);

    // 대댓글은 한 단계만 받으므로, 대댓글에 답글을 달 때는 바로 위 원댓글을
    // 부모로 보낸다(웹도 같다).
    var rootCommentSn = '';
    final comments =
        container
            ?.querySelectorAll(
              "div.post_comment > div.comment > div.comment_row",
            )
            .map((element) {
              final commentSn = element.attributes['data-comment-sn'] ?? '';
              final isReply = element.classes.contains('re');
              if (!isReply) rootCommentSn = commentSn;
              if (element.innerHtml == "<span>삭제 되었습니다.</span>") {
                return null;
              }
              final id = element.attributes['data-author-id'] ?? '';

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
              final info = parsedTime;

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
                commentId: commentSn,
                parentCommentId: isReply ? rootCommentSn : '',
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
      isLoggedIn: isLoggedIn,
      commentParams: commentParams,
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
        MoclLogger.d(() => '[SKIP] id=$id, lastId=$lastId');
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
      final nickImage = isShowNickImage ? nickImg?.attributes['src'] ?? '' : '';
      var nickName = '';
      if (nickImage.isEmpty) {
        nickName =
            author?.querySelector('span.nickname')?.text.trim() ??
            nickImg?.attributes['alt'] ??
            '';
      }

      final hasImage =
          element.querySelector('div.list_title > span.fa-picture-o') != null;

      final parsedTime = formatTimeago(time);
      final info = BaseParser.parserInfo(parsedTime, hit);

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
        final match = RegExp(r'/service/board/([a-zA-Z0-9_]+)')
            .firstMatch(href);
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
    // 최신순은 boardSn 커서 페이징 사용. offset(po)만 쓰면 활성 게시판에서
    // 새 글 유입으로 페이지가 밀려 직전 페이지와 겹치고, 파서의 lastId 중복
    // 필터가 페이지 전체를 걸러 빈 페이지 → 페이징 조기 종료가 발생한다.
    // boardSn 에 마지막 글 sn 을 넘기면 서버가 그 이후 글만 반환해 겹침이 없다.
    // 추천순은 sn 순서가 아니므로 커서를 쓰지 않는다.
    // (추천순에서는 파서의 `id >= lastId` 필터도 오동작 소지가 있으나 별도 과제)
    final int boardSn = sortType == SortType.recent && lastId.intId > 0
        ? lastId.intId
        : 0;
    return 'https://m.clien.net/service/api/board/under/list?category=0&boardSn=$boardSn&po=$page$sort&boardCd=$board';
  }

  @override
  bool get supportsSearch => true;

  @override
  int get firstSearchPage => 0;

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    // 옛 `/service/search/board/{board}?sk=title&sv=` 는 404 다. 지금 검색은
    // 게시판 한정 통합 검색이고, 결과 행이 목록과 같은 `a.list_item` 이다.
    return 'https://m.clien.net/service/search'
        '?q=$keyword&sort=recency&boardCd=$board&isBoard=true&p=$page';
  }
}
