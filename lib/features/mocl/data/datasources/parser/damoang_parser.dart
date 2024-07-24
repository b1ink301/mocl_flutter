import 'dart:developer';

import 'package:html/dom.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';

import '../../../domain/entities/mocl_details.dart';
import 'base_parser.dart';

class DamoangParser extends BaseParser {
  @override
  Future<Result> comment(Document document) {
    // TODO: implement comment
    throw UnimplementedError();
  }

  @override
  Future<Result> detail(Document document) async {
    final container = document.querySelector('article[id=bo_v]');
    final title =
        container?.querySelector('header > h1[id=bo_v_title]')?.text ?? '';
    final timeElement = container?.querySelector(
        'section[id=bo_v_info] > div.d-flex > div > span.orangered');
    final time = timeElement?.text.trim() ??
        container
            ?.querySelectorAll('section[id=bo_v_info] > div.d-flex > div')
            .elementAt(1)
            .text
            .trim() ??
        '';
    final Element? bodyHtml =
        container?.querySelector('section[id=bo_v_atc] > div[id=bo_v_con]');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    final headerElements = container
        ?.querySelectorAll('section[id=bo_v_info] > div.gap-1 > div.pe-2');
    headerElements?.forEach((element) => element
        .querySelectorAll('i, span.visually-hidden')
        .forEach((e) => e.remove()));
    final viewCount = headerElements?.first.text ?? '';
    final authorIp = container
            ?.querySelector('section[id=bo_v_info] > div > div.me-auto')
            ?.attributes['data-bs-title'] ??
        '';
    final user = container
            ?.querySelector(
                'section[id=bo_v_info] > div > div.me-auto > span.sv_wrap > a.sv_member')
            ?.text
            .trim() ??
        '';
    final nickName = user;
    final nickImage = container
            ?.querySelector(
                'div.post_view > div.post_contact > span.contact_name > span.nickimg > img')
            ?.attributes['src'] ??
        '';
    final likeCount = headerElements?.elementAtOrNull(2)?.text.trim() ?? '';

    var index = 0;
    final comments = container
            ?.querySelectorAll('div[id=viewcomment] > section > article')
            .map((element) {
              final nickElement = element.querySelector(
                  'div.comment-list-wrap > header > div.d-flex > div.me-2 > span.d-inline-block > span.sv_wrap > a.sv_member');
              final url = nickElement?.attributes['href'] ?? '';
              final uri = Uri.parse(url);
              final id = uri.queryParameters['mb_id'] ?? '-1';
              final nickName = nickElement?.text.trim() ?? '';
              final isReply = element.querySelector(
                      'div.comment-list-wrap > header > div > div.me-2 > i.bi') !=
                  null;
              final ip = element
                      .querySelector(
                          'div.comment_info > div.comment_info_area > div.comment_ip > span.ip_address')
                      ?.text ??
                  '';
              final time =
                  element.querySelector('div.ms-auto > span.orangered')?.text ??
                      '';
              final nickImage = nickElement
                      ?.querySelector('span.profile_img > img.mb-photo')
                      ?.attributes['src'] ??
                  '';
              final likeCount = element
                      .querySelector(
                          'div.comment-content > div > button > span')
                      ?.text ??
                  '';
              final body =
                  element.querySelector('div.comment-content > div.na-convert');
              body
                  ?.querySelectorAll('input, span.name, button')
                  .forEach((e) => e.remove());
              final video = element
                      .querySelector('div.comment-video > video > source')
                      ?.attributes['src'] ??
                  '';
              final img = element
                      .querySelector('div.comment-img > img')
                      ?.attributes['src'] ??
                  '';

              return CommentItem(
                id: index++,
                isReply: isReply,
                bodyHtml: body?.outerHtml ?? '',
                likeCount: likeCount,
                mediaHtml: img.isEmpty ? video : img,
                isVideo: video.isNotEmpty,
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

    var detail = Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: '',
      time: time,
      userInfo: UserInfo(
        id: user,
        nickName: nickName,
        nickImage: nickImage,
      ),
      bodies: [],
      comments: comments,
      bodyHtml: bodyHtml?.outerHtml ?? '',
    );

    return ResultSuccess(data: detail);
  }

  @override
  Future<Result> list(
    Document document,
    int lastIndex,
    String boardTitle,
    Future<bool> Function(int) isRead,
  ) async {
    log('DamoangParser list');
    var elementList = document.querySelectorAll(
        'form[id=fboardlist] > section[id=bo_list] > ul.list-group > li.list-group-item > div.d-flex');

    var resultList = await Future.wait(elementList.map((element) async {
      var category = element
              .querySelector('div.wr-num > div > span')
              ?.text
              .trim()
              .split(' ')
              .firstOrNull ??
          '';

      if (category == "공지" || category == "홍보") return null;

      var infoElement = element.querySelector('div.flex-grow-1');
      var link = infoElement?.querySelector("div.d-flex > div > a");
      if (link == null) return null;

      var url = link.attributes["href"]?.trim() ?? '';
      var uri = Uri.parse(url);
      var idString = uri.pathSegments.lastOrNull ?? '-1';
      var id = int.tryParse(idString) ?? -1; // int 파싱 오류 처리

      if (id > 0 && id <= lastIndex) {
        return null;
      }

      var metaElement = infoElement?.querySelector(
          'div.da-list-meta > div.d-flex > div.wr-name > span.sv_wrap > a.sv_member');
      var profile = metaElement?.attributes['href'] ?? '';
      var nickName = metaElement?.text.trim() ?? '';
      var userId = Uri.parse(profile).queryParameters['mb_id'] ?? '';
      var reply = infoElement
              ?.querySelector("div.d-flex > div > span.count-plus")
              ?.text
              .trim() ??
          '';

      var board = '';
      var end = url.lastIndexOf("/");
      if (end > 0) {
        var start = url.lastIndexOf("/", end - 1);
        try {
          board = url.substring(start + 1, end);
        } on RangeError {
          // 범위 오류 처리
        }
      }

      var title = link.text.trim();

      var timeElement = infoElement
          ?.querySelector("div > div.d-flex > div.wr-date > span.da-list-date");
      timeElement?.querySelector("span.visually-hidden")?.remove();
      var time = timeElement?.text.trim() ?? '';

      var nickImage = metaElement
              ?.querySelector("span.profile_img > img.mb-photo")
              ?.attributes["src"]?.trim() ??
          '';
      var hitElement =
          infoElement?.querySelector("div > div.d-flex > div.wr-num.order-4");
      hitElement?.querySelector("span.visually-hidden")?.remove();
      var hit = hitElement?.text.trim() ?? '';

      var likeElement =
          infoElement?.querySelector("div > div.d-flex > div.wr-num.order-3");
      likeElement?.querySelector("span.visually-hidden")?.remove();
      var like = likeElement?.text.trim() ?? '';

      var hasImage = infoElement
              ?.querySelector("div.d-flex > div > span.na-icon")
              ?.hasContent() ??
          false;

      UserInfo userInfo = UserInfo(
        id: userId,
        nickName: nickName,
        nickImage: nickImage,
      );
      ListItem item = ListItem(
        id: id,
        title: title,
        reply: reply,
        category: category,
        time: time,
        url: url,
        board: board,
        boardTitle: boardTitle,
        like: like,
        hit: hit,
        userInfo: userInfo,
        hasImage: hasImage,
        isRead: await isRead(id),
      );

      return item;
    }));

    var data =
        resultList.where((item) => item != null).cast<ListItem>().toList();

    return ResultSuccess<List<ListItem>>(data: data);
  }
}
