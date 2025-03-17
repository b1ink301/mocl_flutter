part of 'damoang_parser.dart';

extension StringExt on String {
  DateTime _toDateTime() {
    if (contains(' ')) {
      // 년.월.일 형식
      final parts = split(' ');
      final dateParts = parts[0].split('.');
      final timeParts = parts[1].split(':');
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
        throw Exception('Error parsing $this');
      }
    } else if (contains(':')) {
      final now = DateTime.now();
      // 시:분 형식
      final timeParts = split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } else if (this == '어제') {
      final now = DateTime.now();
      return now.subtract(const Duration(days: 1));
    } else {
      throw Exception('Error parsing $this');
    }
  }
}

extension ElementDetailExt on Element {
  CommentItem? _toComment(int index, bool isShowNickImage) {
    final nickElement = querySelector(
        'div.comment-list-wrap > header > div.d-flex > div.me-2 > span.d-inline-block > span.sv_wrap > a.sv_member');

    final url = nickElement?.attributes['href'] ?? '';
    final uri = Uri.parse(url);
    final id = uri.queryParameters['mb_id'] ?? '-1';
    final nickName = nickElement?.text.trim() ?? '';
    final isReply = querySelector(
            'div.comment-list-wrap > header > div > div.me-2 > i.bi') !=
        null;
    final timeElement =
        querySelector('div.comment-list-wrap > header > div > div.ms-auto');
    timeElement?.querySelector("span.visually-hidden")?.remove();
    final time = timeElement?.text.trim() ?? '';

    final nickImage = isShowNickImage
        ? nickElement
                ?.querySelector('span.profile_img > img.mb-photo')
                ?.attributes['src']
                ?.trim() ??
            ''
        : '';

    final likeCount = querySelector(
                'div.comment-content > div.d-flex > div:last-child > button:last-child > span:first-child')
            ?.text
            .trim() ??
        '';

    final body = querySelector('div.comment-content > div.na-convert');
    body
        ?.querySelectorAll('input, span.name, button')
        .forEach((e) => e.remove());

    var parsedTime = '';
    try {
      var dateTime = time._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = '$nickName ・ $parsedTime';

    return CommentItem(
      id: index++,
      isReply: isReply,
      bodyHtml: body?.innerHtml ?? '',
      likeCount: likeCount,
      mediaHtml: '',
      isVideo: false,
      time: time,
      info: info,
      userInfo: UserInfo(
        id: id,
        nickName: nickName,
        nickImage: nickImage,
      ),
      authorId: '',
    );
  }

  Details _toDetails(List<CommentItem> comments) {
    final title =
        querySelector('header > h1[id=bo_v_title]')?.text.trim() ?? '';
    final timeElement = querySelector(
        'section[id=bo_v_info] > div.d-flex > div:last-child'); //:first-child, div:nth-child(2)
    timeElement?.querySelector("span.visually-hidden")?.remove();
    final time = timeElement?.text.trim() ?? '';
    final bodyHtml = querySelector('section[id=bo_v_atc] > div[id=bo_v_con]');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    final headerElements =
        querySelectorAll('section[id=bo_v_info] > div.gap-1 > div.pe-2');

    for (final element in headerElements) {
      element
        .querySelectorAll('i, span.visually-hidden')
        .forEach((e) => e.remove());
    }

    var viewCount = '';
    var likeCount = '';
    if (headerElements.length == 2) {
      viewCount = headerElements.elementAtOrNull(0)?.text.trim() ?? '';
      likeCount = headerElements.elementAtOrNull(1)?.text.trim() ?? '';
    } else if (headerElements.length == 3) {
      try {
        viewCount = headerElements.elementAtOrNull(0)?.text.trim() ?? '';
        int.parse(viewCount);
      } catch (e) {
        viewCount = headerElements.elementAtOrNull(1)?.text.trim() ?? '';
      }
      likeCount = headerElements.elementAtOrNull(2)?.text.trim() ?? '';
    } else if (headerElements.length == 4) {
      viewCount = headerElements.elementAtOrNull(1)?.text.trim() ?? '';
      likeCount = headerElements.elementAtOrNull(3)?.text.trim() ?? '';
    }
    final memberElement = querySelector(
        'section[id=bo_v_info] > div.d-flex > div.me-auto > span.d-inline-block > span.sv_wrap > a.sv_member');

    final nickName = memberElement?.text.trim() ?? '';
    final nickImage = memberElement
            ?.querySelector('span.profile_img > img')
            ?.attributes['src'] ??
        '';

    var parsedTime = '';
    try {
      var dateTime = time._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);

    return Details(
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
  }
}

extension ElementListExt on Element {
  ListItem? _toListItem(
      int lastId, String baseUrl, String boardTitle, bool isShowNickImage) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    final test =
        querySelector('div.wr-num > div.rcmd-box > span.orangered > img');
    final category = test?.attributes['alt'] ?? '';

    if (category == "공지" || category == "홍보" || category == "추천") return null;

    final infoElement = querySelector('div.flex-grow-1');
    final link = infoElement?.querySelector("div.d-flex > div > a");
    if (link == null) return null;

    final url = link.attributes["href"]?.trim() ?? '';
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final idString = uri.pathSegments.lastOrNull ?? '-1';
    final id = int.tryParse(idString) ?? -1;
    if (id <= 0 || lastId > 0 && id >= lastId) {
      return null;
    }

    final metaElement = infoElement?.querySelector(
        'div.da-list-meta > div.d-flex > div.wr-name > span.sv_wrap > a.sv_member');
    final profile = metaElement?.attributes['href'] ?? '';
    final userId = Uri.parse(profile).queryParameters['mb_id'] ?? '';

    final reply = infoElement
            ?.querySelectorAll("div.d-flex > div.d-inline-flex > a")
            .map((a) => a.querySelector('span.count-plus')?.text.trim())
            .firstWhere((text) => text != null && text.isNotEmpty,
                orElse: () => '') ??
        '';

    var board = '';
    final end = url.lastIndexOf("/");
    if (end > 0) {
      final start = url.lastIndexOf("/", end - 1);
      if (start >= 0) {
        board = url.substring(start + 1, end);
      }
    }

    final title = link.text.trim();

    final timeElement =
        infoElement?.querySelector("div > div.d-flex > div.wr-date");

    timeElement
        ?.querySelectorAll("span.visually-hidden, i.bi")
        .forEach((ele) => ele.remove());

    final time = timeElement?.text.trim() ?? '';
    var parsedTime = '';
    try {
      var dateTime = time._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }

    final nickImage = isShowNickImage
        ? metaElement
                ?.querySelector("span.profile_img > img.mb-photo")
                ?.attributes["src"]
                ?.trim() ??
            ''
        : '';

    final nickName =
        metaElement?.querySelector("span.sv_name")?.text.trim() ?? '';

    final hitElement =
        infoElement?.querySelector("div > div.d-flex > div.wr-num.order-4");
    hitElement?.querySelector("span.visually-hidden")?.remove();
    final hit = hitElement?.text.trim() ?? '';

    final likeElement = infoElement?.querySelector("div.wr-num > div.rcmd-box");
    likeElement
        ?.querySelectorAll("span.visually-hidden, i.bi")
        .forEach((ele) => ele.remove());
    final like = likeElement?.text.trim() ?? '';

    final hasImage = infoElement
            ?.querySelector("div.d-flex > div > span.na-icon")
            ?.hasContent() ??
        false;

    final info = BaseParser.parserInfo(nickName, parsedTime, hit);

    return ListItem(
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
    );
  }
}

// extension ElementMainExt on Element {
//   MainItem? _toMainItem(String baseUrl, int orderBy) {
//     throw UnimplementedError('_toMainItem');
//   }
// }
