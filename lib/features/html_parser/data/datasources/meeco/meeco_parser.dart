import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_date_time.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

class MeecoParser extends BaseParser {
  final bool isShowNickImage;

  const MeecoParser(this.isShowNickImage);

  @override
  SiteType get siteType => SiteType.meeco;

  @override
  String get baseUrl => 'https://meeco.kr';

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
    final responseData = response.data as String;
    final url = baseUrl;
    final showNickImage = isShowNickImage;
    return Isolate.run(() => _parseDetail(url, responseData, showNickImage));
  }

  static Either<Failure, Details> _parseDetail(
    String baseUrl,
    String responseData,
    bool isShowNickImage,
  ) {

    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final document = parse(responseData);
    final container = document.querySelector('article.atc');

    final title = container.qText('header.atc_hd > h1 > a');

    final infoElement = container?.querySelector(
      'header.atc_hd > div.atc_info',
    );

    final nickName =
        container?.querySelector('span.nickname > a > span')?.text.trim() ??
        infoElement?.querySelector('span.nickname')?.text.trim() ??
        '';

    final tmpUrl = infoElement.qAttr('span.pf > img.pf_img', 'src');
    final nickImage = isShowNickImage ? tmpUrl.toUrl(baseUrl) : '';
    // final nickName =
    //     infoElement?.querySelector('span.nickname')?.text.trim() ?? '';

    final bodyHtml = container?.querySelector('div.atc_body');
    bodyHtml.removeAll('input, button');

    final time = infoElement?.querySelectorAll('ul > li')[0].text.trim() ?? '';

    final viewCount =
        infoElement?.querySelectorAll('ul > li')[1].text.trim() ?? '0';
    final likeCount = '';

    var index = 0;
    final List<CommentItem> comments =
        container
            ?.querySelectorAll(
              'div.cmt > div.cmt_list_parent > div.cmt_list > article',
            )
            .map((element) {
              final headerElement = element.querySelector('header.cmt_hd');

              final isReply =
                  element.attributes['class']?.contains('reply') ?? false;
              final profileElement = headerElement?.querySelector(
                'div.pf_wrap > span.pf > img.pf_img',
              );

              MoclLogger.log('element=${element.innerHtml}');

              final tmpUrl = profileElement?.attributes['src']?.trim() ?? '';
              final nickImage = isShowNickImage ? tmpUrl.toUrl(baseUrl) : '';

              final time = element.qText('span.date');
              final likeCount = element.qText(
                'div.cmt_vote > span.cmt_vote_up > b.num',
              );

              final cmtTo = headerElement.qText('div.cmt_to');
              
              final body = element.querySelector('div.xe_content');
              body.removeAll('input, span.name, button');

              final parsedTime = formatTimeago(time);

              final isSecret =
                  element.querySelector('div.cmt_secret_ctn') != null;

              MoclLogger.log(
                'isSecret=$isSecret, headerElement=${headerElement?.innerHtml}',
              );

              final nickNameElement = headerElement?.children.firstWhere(
                (child) => child.localName == 'spanclass="bt_cmt_ctrl3',
              );
              nickNameElement
                  ?.querySelectorAll('span, i, div')
                  .forEach((element) => element.remove());
              final nickName = nickNameElement?.text.trim() ?? '';

              final info = '$nickNameㆍ$parsedTime';
              var bodyHtml = isSecret ? '비밀글입니다.' : body?.innerHtml;

              if (cmtTo.isNotEmpty) {
                bodyHtml = '@$cmtTo\n$bodyHtml';
              }

              if (bodyHtml?.startsWith(
                    '<a href="https://meeco.kr/index.php?mid=sticker&',
                  ) ==
                  true) {
                final atag = HtmlParser(
                  bodyHtml,
                ).parse().getElementsByTagName('a').firstOrNull;
                final style = atag?.attributes['style'];
                if (style != null) {
                  final RegExp urlRegex = RegExp(r'url\((https?://[^)]+)\)');
                  final Match? match = urlRegex.firstMatch(style);

                  if (match != null) {
                    final url = match.group(1)!;
                    bodyHtml = '<img src=$url height="140" width="140">\n$bodyHtml';
                  }
                }
              }

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: bodyHtml ?? '',
                likeCount: likeCount,
                mediaHtml: '',
                isVideo: false,
                time: time,
                info: info,
                userInfo: UserInfo(
                  id: 'id',
                  nickName: nickName,
                  nickImage: nickImage,
                ),
                authorId: '',
              );
            })
            .whereType<CommentItem>()
            .toList() ??
        [];

    final parsedTime = formatTimeago(time);

    final info = BaseParser.parserInfo(false, nickName, parsedTime, viewCount);

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
    // final isShowNickImage = message.isShowNickImage;

    final document = parse(responseData).body;
    if (document == null) {
      return;
    }

    final elementList = document.querySelectorAll(
      'div.wrap > section[id=container] > div > section.ctt > section.neon_board > div[id=list_swipe_area] > div.list_ctt > div.list_document > div.list_d > ul > li',
    );

    final items = <ListItem>[];

    for (final element in elementList) {
      final category = element.qText('span.hot_text, span.notice_text');

      if (category == "공지" || category == "핫글") continue;

      final infoElement = element.querySelector('a.list_link');
      final title = infoElement?.attributes['title']?.trim() ?? '';
      final tmpUrl = infoElement?.attributes['href']?.trim() ?? '';
      final url = tmpUrl.toUrl(baseUrl);

      final uri = Uri.tryParse(url);
      if (uri == null) continue;
      final idString = uri.pathSegments.lastOrNull ?? '-1';
      final id = int.tryParse(idString) ?? -1;
      if (id <= 0 || lastId > 0 && id >= lastId) continue;

      //:first-child, div:nth-child(2)
      final nickName = element.qText('div.list_info > div:first-child');
      final userId = nickName;
      final reply = element.qText("a.list_cmt");

      var board = '';
      final end = url.lastIndexOf("/");
      if (end > 0) {
        final start = url.lastIndexOf("/", end - 1);
        if (start >= 0) {
          board = url.substring(start + 1, end);
        }
      }

      final time = element.qText('div.list_info > div:nth-child(1)');
      final parsedTime = time;
      final hit = element.qText('div.list_info > div:nth-child(2)');
      final like = element.qText('div.list_info > div.list_vote');

      final info = BaseParser.parserInfo(false, nickName, parsedTime, hit);

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
          hasImage: false,
          isRead: false,
        ),
      );
    }

    await sendListWithReadStatus(replyPort, items);
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
  ) => '$url?page=$page${sortType.toQuery(siteType)}';

}
