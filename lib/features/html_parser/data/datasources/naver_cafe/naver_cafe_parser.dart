import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/domain/entities/board_path.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/util/mocl_logger.dart';
import '../base/base_parser.dart';

class const NaverCafeParser() extends BaseParser {
  @override
  SiteType get siteType => SiteType.naverCafe;

  @override
  String get baseUrl => 'https://m.cafe.naver.com';

  @override
  Future<Either<Failure, List<MainItem>>> main(
    Response<dynamic> response,
  ) async {
    final Map<String, dynamic> json =
        response.data['message'] as Map<String, dynamic>;
    final String status = json['status'] as String;
    if (status != '200') {
      final Map<String, dynamic> error = json['error'] as Map<String, dynamic>;
      final String code = error['code'] as String;
      final String msg = error['msg'] as String;
      if (code == '0004') {
        return Left(NotLoginFailure(message: msg));
      } else {
        return Left(GetMainFailure(message: msg));
      }
    } else {
      final List<dynamic> cafes = json['result']['cafes'] as List<dynamic>;
      var orderBy = 0;
      final List<MainItem> data = cafes.map((cafe) {
        Map<String, dynamic> json = {
          'siteType': siteType.name,
          'orderBy': orderBy++,
          'url': cafe['cafeId'].toString(),
          'board': cafe['cafeUrl'],
          'text': cafe['mobileCafeName'],
          'icon': cafe['cafeIconImageUrl'],
          // 카페는 그 자체가 게시판이 아니라 메뉴(게시판)를 담은 컨테이너다.
          // 추가 화면은 이 값을 보고 '담기' 대신 '들어가기'로 그린다.
          'hasItem': true,
          'type': 0,
        };
        return MainItem.fromJson(json);
      }).toList();

      return Right(data.cast<MainItem>());
    }
  }

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as List<dynamic>;
    try {
      return await Isolate.run(() => _parseDetail(responseData));
    } catch (e, st) {
      // 예상 못 한 응답 형태로 파싱이 깨져도 원시 예외 문구를 화면에 흘리지 않는다.
      MoclLogger.e('[detail] parse error', error: e, stackTrace: st);
      return const Left(GetDetailFailure(message: '글을 불러오지 못했어요.'));
    }
  }

  /// 네이버 카페 오류 응답을 화면에 보여줄 [Failure] 로 바꾼다.
  /// 서버가 주는 `reason` 은 사람이 읽을 수 있는 한국어라 그대로 노출한다.
  /// - `0004`: 로그인 필요
  /// - `4005`: 게시글을 읽기 위한 멤버 레벨 부족
  /// - `9999`: 서버가 사유를 감춘 일반 오류(권한 없는 글의 댓글 API 등)
  static Failure _failureOf(Map<dynamic, dynamic> error, String fallback) {
    final String? code = (error['errorCode'] ?? error['code'])?.toString();
    final String? reason = (error['reason'] ?? error['errorMessage'])
        ?.toString();
    return switch (code) {
      '0004' => NotLoginFailure(message: reason ?? '로그인이 필요해요.'),
      '4005' => PermissionFailure(message: reason ?? '이 글을 읽을 권한이 없어요.'),
      _ => GetDetailFailure(
        message: reason?.isNotEmpty == true ? reason! : fallback,
      ),
    };
  }

  /// 권한이 없는 글의 댓글 API 는 `{"errorCode":"9999"}` 만 돌려준다.
  /// 본문을 읽을 수 있는 상황이라면 댓글이 없는 것으로 보고 본문만 보여준다.
  static List<dynamic> _commentItemsOf(dynamic body) {
    if (body is! Map) return const [];
    final result = body['result'];
    if (result is! Map) return const [];
    final comments = result['comments'];
    if (comments is! Map) return const [];
    final items = comments['items'];
    return items is List ? items : const [];
  }

  static Either<Failure, Details> _parseDetail(List<dynamic> responseData) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final body = responseData.first;
    if (body is! Map) {
      return const Left(GetDetailFailure(message: '글을 불러오지 못했어요.'));
    }
    // 오류 응답은 사유가 result 안(4005 등)에 오기도 하고 최상위(9999)에 오기도 한다.
    final detail = body['result'] is Map ? body['result'] as Map : body;
    final article = detail['article'];
    if (article is! Map) {
      return Left(_failureOf(detail, '글을 불러오지 못했어요.'));
    }

    // contentHtml 은 구형 에디터 글에만 채워진다. 비어 있으면(마켓/플리마켓 글 등)
    // 본문이 다른 필드에 있으므로 글 종류별 폴백으로 본문 HTML 을 만든다.
    final rawBody = article['contentHtml'];
    var bodyHtml = rawBody is String ? rawBody : '';
    if (bodyHtml.isEmpty) {
      bodyHtml = _buildMarketBodyHtml(detail, article);
      if (bodyHtml.isEmpty) {
        MoclLogger.d(
          () =>
              '[detail] empty body. isMarket=${article['isMarket']} '
              'editorVersion=${article['editorVersion']}',
        );
      }
    }
    final writer = article['writer'] as Map? ?? const {};
    final title = article['subject'].toString().trim();
    // final id = writer['id'] ?? '';
    final nickName = writer['nick'].toString();
    final nickImage = ''; //writer['image']['url'].toString();
    final time = article['writeDate'] ?? 0;
    final viewCount = (article['readCount'] ?? 0).toString();
    // final commentCount = writer['commentCount'];
    final likeCount = '';

    final List<dynamic> comments = _commentItemsOf(responseData.last);

    final commentItems = comments
        .map((comment) {
          final id = comment['id'] ?? -1;
          final writer = comment['writer'] as Map? ?? const {};
          final replyMember = comment['replyMember'];
          var body = comment['content'].toString();
          final userId = writer['memberKey'].toString();
          final nickImage = ''; //writer['image']['url'] ?? '';
          final nickName = writer['nick'].toString();
          final isReply = comment['isRef'] ?? false;
          final time = comment['updateDate'] ?? 0;
          final likeCount = '0';
          final image = comment['image'];
          final sticker = comment['sticker'];

          if (replyMember != null) {
            final replyNickName = replyMember['nick'];
            if (replyNickName != null) {
              body = "<strong>@$replyNickName님</strong> $body";
            }
          }
          if (image != null) {
            body += '<br><img src=\'${image["url"]}\' width="240" >';
          }
          if (sticker != null) {
            body +=
                '<br><img src=\'${sticker["url"]}?type=${sticker["type"]}\' width="129" >';
          }

          var parsedTime = '';
          try {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(time as int);
            parsedTime = timeago.format(dateTime, locale: 'ko');
          } catch (e) {
            parsedTime = time.toString();
          }
          final info = parsedTime;

          return CommentItem(
            id: id as int,
            isReply: isReply as bool,
            bodyHtml: body,
            likeCount: likeCount,
            mediaHtml: '',
            isVideo: false,
            time: time.toString(),
            info: info,
            userInfo: UserInfo(
              id: userId,
              nickName: nickName,
              nickImage: nickImage,
            ),
            authorId: '',
          );
        })
        .whereType<CommentItem>()
        .toList();

    String parsedTime = '';

    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time as int);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time.toString();
    }
    final info = BaseParser.parserInfo(parsedTime, viewCount);

    final details = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time.toString(),
      info: info,
      userInfo: UserInfo(
        id: nickName,
        nickName: nickName,
        nickImage: nickImage,
      ),
      comments: commentItems,
      bodyHtml: bodyHtml,
    );

    return Right<Failure, Details>(details);
  }

  /// 중고거래(네이버 플리마켓) 글은 contentHtml/contentElements 가 비어 있고
  /// 본문이 nfleaProduct.saleProduct 에 들어 있다. 가격/설명/사진만 HTML 로 합친다.
  /// nfleaProduct 는 article 이 아니라 result 바로 아래(= article 의 형제)에 온다.
  static String _buildMarketBodyHtml(
    Map<dynamic, dynamic> result,
    Map<dynamic, dynamic> article,
  ) {
    final nflea = result['nfleaProduct'] ?? article['nfleaProduct'];
    if (nflea is! Map) return '';
    final sale = nflea['saleProduct'];
    if (sale is! Map) return '';

    final buffer = StringBuffer();

    final price = sale['price'];
    if (price is num) {
      buffer.write(
        '<p><strong>가격: ${_formatPrice(price.toInt())}원</strong></p>',
      );
    }

    const statusLabels = {
      'ON_SALE': '판매중',
      'SALE': '판매중',
      'RESERVED': '예약중',
      'SOLD_OUT': '판매완료',
      'SOLD': '판매완료',
      'END': '판매완료',
    };
    final status = statusLabels[sale['saleStatus']];
    if (status != null) {
      buffer.write('<p>거래상태: $status</p>');
    }

    final content = sale['content'];
    if (content is String && content.isNotEmpty) {
      final escaped = content
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;')
          .replaceAll('\n', '<br>');
      buffer.write('<p>$escaped</p>');
    }

    for (final url in _marketImageUrls(result, sale)) {
      buffer.write('<img src="$url" width="100%"><br>');
    }

    return buffer.toString();
  }

  /// 사진은 saleProduct.productImages 가 1순위, 없으면 result.attaches 의
  /// 이미지 첨부(type == 'I')를 쓴다.
  static List<String> _marketImageUrls(
    Map<dynamic, dynamic> result,
    Map<dynamic, dynamic> sale,
  ) {
    final urls = <String>[];

    final images = sale['productImages'];
    if (images is List) {
      for (final image in images) {
        final url = image is Map ? image['url'] : null;
        if (url is String && url.isNotEmpty) urls.add(url);
      }
    }
    if (urls.isNotEmpty) return urls;

    final attaches = result['attaches'];
    if (attaches is List) {
      for (final attach in attaches) {
        if (attach is! Map || attach['type'] != 'I') continue;
        final url = attach['url'];
        if (url is String && url.isNotEmpty) urls.add(url);
      }
    }
    return urls;
  }

  static String _formatPrice(int price) {
    final digits = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response<dynamic> response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    try {
      final message = response.data['message'];
      final status = message['status'].toString();
      if (status != "200") {
        throw Exception("status is not 200!");
      }

      final items = await ParserIsolateClient.instance.parseList(
        siteType: siteType,
        responseData: message['result'] as Map<String, dynamic>,
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
    final dynamic responseData = message.responseData;
    final lastId = message.lastId;
    final boardTitle = message.boardTitle;

    final items = <ListItem>[];

    final List<dynamic> articleList =
        responseData['articleList'] as List<dynamic>;

    for (final article in articleList.cast<Map<String, dynamic>>()) {
      final int id = article['articleId'] as int? ?? -1;

      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final int board = article['cafeId'] as int? ?? -2;
      final String nickName = article['writerNickname'].toString();
      final String category = article['menuName'].toString();
      final String title = article['subject'].toString();
      final String nickImage = article['profileImage'].toString();
      final int hit = article['readCount'] as int? ?? 0;
      final int like = article['likeItCount'] as int? ?? 0;
      final int commentCount = article['commentCount'] as int? ?? 0;
      final int time = article['writeDateTimestamp'] as int? ?? 0;
      final String userId = article['memberKey'].toString();
      final bool hasImage = article['attachImage'] as bool? ?? false;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      final parsedTime = timeago.format(dateTime, locale: 'ko');
      final info = BaseParser.parserInfo(parsedTime, hit.toString());

      items.add(
        ListItem(
          id: id,
          title: parse(title).body?.text ?? '',
          reply: commentCount.toString(),
          category: category,
          time: time.toString(),
          info: info,
          url: '',
          board: board.toString(),
          boardTitle: boardTitle,
          like: like.toString(),
          hit: hit.toString(),
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
  String urlByDetail(String url, String board, int id) =>
      'https://apis.naver.com/cafe-web/cafe-articleapi/v3/cafes/$board/articles/$id';

  // 'https://apis.naver.com/cafe-web/cafe-articleapi/v2/cafes/$board/articles/$id'; //?query=&useCafeId=true&requestFrom=A

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) {
    // final String sort = sortType.toQuery(siteType);
    // board 는 카페 전체글이면 cafeUrl, 특정 게시판이면 'cafeUrl/menuId' 합성 키다.
    // menuid 를 붙이면 같은 API 가 그 게시판만 돌려준다.
    final String menuId = splitBoard(board).child ?? '';
    final String menuQuery = menuId.isEmpty ? '' : '&search.menuid=$menuId';
    return "https://apis.naver.com/cafe-web/cafe2/ArticleListV2dot1.json?"
        "search.clubid=$url"
        "&search.queryType=lastArticle"
        "&search.perPage=20"
        "&ad=false"
        "&uuid=6dd62de1-7279-49f0-b009-6ccc554ac679"
        "&search.page=$page"
        "$menuQuery";
  }

  @override
  String urlByMain() =>
      'https://apis.naver.com/cafe-home-web/cafe-home/v1/cafes/join?perPage=100';

  @override
  bool get supportsSubMenu => true;

  @override
  String urlBySubMenu(MainItem parent) =>
      'https://apis.naver.com/cafe-web/cafe2/SideMenuList?cafeId=${parent.url}';

  /// 카페 사이드 메뉴(게시판 목록)를 담을 수 있는 [MainItem] 으로 바꾼다.
  ///
  /// `menuType` 이 섞여 오므로 걸러야 한다.
  /// - `B`  : 게시판 → 담을 수 있는 항목
  /// - `F`  : 폴더 → 항목이 아니라 뒤따르는 게시판들의 섹션 이름([MainItem.category])
  /// - `S`  : 구분선 → 폴더 묶음이 끝났다는 신호
  /// - 그 외(`M` 끝말잇기 · `U` 등업신청현황 · `P` 인기글 · `T` 태그)는 목록 파서가
  ///   없으므로 제외한다.
  ///
  /// 폴더 소속 판정에 `indent` 는 쓰지 않는다. 실제 응답에서 폴더 바로 아래
  /// 게시판이 `indent:false` 로 오는 카페가 있어(예: `qwerty폰`) 소속이 끊긴다.
  /// 대신 '폴더를 만나면 열고, 구분선이나 다음 폴더에서 닫는다'로 묶는다.
  @override
  Future<Either<Failure, List<MainItem>>> subMenu(
    Response<dynamic> response,
    MainItem parent,
  ) async {
    final dynamic data = response.data;
    final dynamic message = data is Map ? data['message'] : null;
    if (message is! Map) {
      return const Left(GetMainFailure(message: '게시판 목록을 불러오지 못했어요.'));
    }

    if (message['status'].toString() != '200') {
      final Map<dynamic, dynamic> error =
          message['error'] is Map ? message['error'] as Map : const {};
      final String code = error['code']?.toString() ?? '';
      final String msg = error['msg']?.toString() ?? '';
      return code == '0004'
          ? Left(NotLoginFailure(message: msg.isNotEmpty ? msg : '로그인이 필요해요.'))
          : Left(
              GetMainFailure(
                message: msg.isNotEmpty ? msg : '게시판 목록을 불러오지 못했어요.',
              ),
            );
    }

    final dynamic result = message['result'];
    final dynamic menus = result is Map ? result['menus'] : null;
    if (menus is! List) return const Right(<MainItem>[]);

    var orderBy = 0;
    // 카페 전체글. board 가 부모와 같아서(합성 키가 아니다) 기존에 담아둔
    // '카페' 즐겨찾기와 키가 일치한다 → 이미 담긴 것으로 그려진다.
    final List<MainItem> items = [
      MainItem(
        siteType: siteType,
        board: parent.board,
        text: '전체글',
        url: parent.url,
        orderBy: orderBy++,
        icon: parent.icon,
        parentBoard: parent.board,
        parentText: parent.text,
      ),
    ];

    var folder = '';
    for (final dynamic menu in menus) {
      if (menu is! Map) continue;
      if (menu['hidden'] == true) continue;

      final String menuType = menu['menuType']?.toString() ?? '';
      // 메뉴 이름에 HTML 엔티티가 그대로 온다(`[OS7&gt;]질문게시판`, `개발관련Q&amp;A`).
      final String name = parse(
        menu['menuName']?.toString() ?? '',
      ).body?.text.trim() ?? '';

      if (menuType == 'S') {
        folder = '';
        continue;
      }
      if (menuType == 'F') {
        folder = name;
        continue;
      }
      if (menuType != 'B' || name.isEmpty) continue;

      final String menuId = menu['menuId']?.toString() ?? '';
      if (menuId.isEmpty) continue;

      items.add(
        MainItem(
          siteType: siteType,
          board: joinBoard(parent.board, menuId),
          text: name,
          url: parent.url,
          orderBy: orderBy++,
          icon: parent.icon,
          category: folder,
          parentBoard: parent.board,
          parentText: parent.text,
        ),
      );
    }

    return Right(items);
  }
}
