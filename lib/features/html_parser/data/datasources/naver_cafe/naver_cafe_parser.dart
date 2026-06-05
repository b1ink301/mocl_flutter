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
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../core/util/mocl_logger.dart';
import '../base/base_parser.dart';

class NaverCafeParser implements BaseParser {
  const NaverCafeParser();

  @override
  SiteType get siteType => SiteType.naverCafe;

  @override
  String get baseUrl => 'https://m.cafe.naver.com';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) async {
    final Map<String, dynamic> json = response.data['message'];
    final String status = json['status'];
    if (status != '200') {
      final Map<String, dynamic> error = json['error'];
      final String code = error['code'];
      final String msg = error['msg'];
      if (code == '0004') {
        return Left(NotLoginFailure(message: msg));
      } else {
        return Left(GetMainFailure(message: msg));
      }
    } else {
      final List<dynamic> cafes = json['result']['cafes'];
      var orderBy = 0;
      final List<MainItem> data = cafes.map((cafe) {
        Map<String, dynamic> json = {
          'siteType': siteType.name,
          'orderBy': orderBy++,
          'url': cafe['cafeId'].toString(),
          'board': cafe['cafeUrl'],
          'text': cafe['mobileCafeName'],
          'icon': cafe['cafeIconImageUrl'],
          'hasItem': false,
          'type': 0,
        };
        return MainItem.fromJson(json);
      }).toList();

      return Right(data.cast<MainItem>());
    }
  }

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data as List<dynamic>;
    return Isolate.run(() => _parseDetail(responseData));
  }

  static Either<Failure, Details> _parseDetail(List<dynamic> responseData) {

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final detail = responseData.first['result'];
    final article = detail['article'];
    if (article is! Map) {
      final errorCode = detail['errorCode']?.toString();
      final reason = detail['reason']?.toString() ?? '본문을 불러오지 못했습니다.';
      return errorCode == '0004'
          ? Left(NotLoginFailure(message: reason))
          : Left(GetDetailFailure(message: reason));
    }

    // contentHtml 은 구형 에디터 글에만 채워진다. 비어 있으면(마켓/플리마켓 글 등)
    // 본문이 다른 필드에 있으므로 글 종류별 폴백으로 본문 HTML 을 만든다.
    final rawBody = article['contentHtml'];
    var bodyHtml = rawBody is String ? rawBody : '';
    if (bodyHtml.isEmpty) {
      bodyHtml = _buildMarketBodyHtml(article);
      if (bodyHtml.isEmpty) {
        MoclLogger.log(
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

    final comment = responseData.last['result'];

    final List<dynamic> comments = comment['comments']['items'];

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
            final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
            parsedTime = timeago.format(dateTime, locale: 'ko');
          } catch (e) {
            parsedTime = time.toString();
          }
          final info = '$nickNameㆍ$parsedTime';

          return CommentItem(
            id: id,
            isReply: isReply,
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
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time.toString();
    }
    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

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
  /// 본문이 nfleaProduct.saleProduct 에 들어 있다. 가격/상태/설명/사진을 HTML 로 합친다.
  static String _buildMarketBodyHtml(Map article) {
    final nflea = article['nfleaProduct'];
    if (nflea is! Map) return '';
    final sale = nflea['saleProduct'];
    if (sale is! Map) return '';

    final buffer = StringBuffer();

    final price = sale['price'];
    if (price is num) {
      buffer.write('<p><strong>가격: ${_formatPrice(price.toInt())}원</strong></p>');
    }

    const statusLabels = {
      'SALE': '판매중',
      'RESERVED': '예약중',
      'SOLD_OUT': '판매완료',
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

    final images = sale['productImages'];
    if (images is List) {
      for (final image in images) {
        final url = image is Map ? image['url'] : null;
        if (url is String && url.isNotEmpty) {
          buffer.write('<img src="$url" width="100%"><br>');
        }
      }
    }

    return buffer.toString();
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
    Response response,
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

    final parsedItems = <Map<String, dynamic>>[];
    final ids = <int>[];

    final List<dynamic> articleList = responseData['articleList'];

    for (final Map<String, dynamic> article in articleList) {
      final int id = article['articleId'] ?? -1;

      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      final int board = article['cafeId'] ?? -2;
      final String nickName = article['writerNickname'].toString();
      final String category = article['menuName'].toString();
      final String title = article['subject'].toString();
      final String nickImage = article['profileImage'].toString();
      final int hit = article['readCount'] ?? 0;
      final int like = article['likeItCount'] ?? 0;
      final int commentCount = article['commentCount'] ?? 0;
      final int time = article['writeDateTimestamp'] ?? 0;
      final String userId = article['memberKey'].toString();
      final bool hasImage = article['attachImage'] as bool? ?? false;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      final parsedTime = timeago.format(dateTime, locale: 'ko');
      final info = BaseParser.parserInfo(
        false,
        nickName,
        parsedTime,
        hit.toString(),
      );

      final parsedItem = {
        'id': id,
        'title': parse(title).body?.text,
        'reply': commentCount.toString(),
        'category': category,
        'time': time.toString(),
        'info': info,
        'url': '',
        'board': board.toString(),
        'boardTitle': boardTitle,
        'like': like.toString(),
        'hit': hit.toString(),
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
            isRead: readStatusResponse.statuses.contains(item['id']),
          ),
        )
        .toList();

    replyPort.send(resultList);
  }

  static DateTime parseDateTime(String dateTimeString) {
    if (dateTimeString.contains(' ')) {
      // 년.월.일 형식
      var parts = dateTimeString.split(' ');
      var dateParts = parts[0].split('.');
      var timeParts = parts[1].split(':');
      if (dateParts.length == 3) {
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
    return "https://apis.naver.com/cafe-web/cafe2/ArticleListV2dot1.json?"
        "search.clubid=$url"
        "&search.queryType=lastArticle"
        "&search.perPage=20"
        "&ad=false"
        "&uuid=6dd62de1-7279-49f0-b009-6ccc554ac679"
        "&search.page=$page";
  }

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) {
    throw UnimplementedError('urlBySearchList');
  }

  @override
  String urlByMain() =>
      'https://apis.naver.com/cafe-home-web/cafe-home/v1/cafes/join?perPage=100';

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) {
    // TODO: implement comments
    throw UnimplementedError();
  }

  @override
  String urlByComments(String url, String board, int id, int page) {
    // TODO: implement urlByComments
    throw UnimplementedError();
  }
}
