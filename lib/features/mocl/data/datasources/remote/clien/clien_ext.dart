part of 'clien_parser.dart';

extension StringExt on String {
  DateTime _toDateTime() {
    final times = split(' ');

    final now = DateTime.now();
    if (times.length == 2) {
      var date = times[0].split('-');

      var year = now.year;
      var month = now.month;
      var day = now.day;
      var hour = now.hour;
      var minute = now.minute;
      var second = now.second;

      if (date.length == 3) {
        year = int.parse(date[0]);
        month = int.parse(date[1]);
        day = int.parse(date[2]);
      } else {
        throw Exception('Error parsing $this');
      }

      var time = times[1].split(':');
      if (time.length == 3) {
        hour = int.parse(time[0]);
        minute = int.parse(time[1]);
        second = int.parse(time[2]);
      } else {
        throw Exception('Error parsing $this');
      }

      return DateTime(year, month, day, hour, minute, second);
    } else {
      var times = split(':');

      if (times.length == 2) {
        final hour = int.parse(times[0]);
        final minute = int.parse(times[1]);
        return DateTime(now.year, now.month, now.day, hour, minute);
      } else {
        times = split('-');
        if (times.length == 3) {
          final year = int.parse(times[0]);
          final tmp = now.year - year;
          final month = int.parse(times[1]);
          final day = int.parse(times[2]);
          return DateTime(year + tmp, month, day, now.hour, now.minute);
        } else {
          throw Exception('Error parsing $this');
        }
      }
    }
  }
}

extension ElementDetailExt on Element {
  Details _toDetails(List<CommentItem> comments) {
    final csrf = querySelector(
                "body > nav.navigation > div.dropdown-menu > form > input[name=_csrf]")
            ?.attributes['value'] ??
        '';
    final title = querySelector("div.post_title > div.post_subject > span")
            ?.text
            .trim() ??
        '';
    final timeElement =
        querySelector("div.post_information > div.post_time > div.post_date");

    // debugPrint('timeElement = ${timeElement?.outerHtml}');
    timeElement?.querySelectorAll('.fa').forEach((element) => element.remove());
    var time = timeElement?.text.trim() ?? '';
    final tmp = time.split('수정일 :');
    final times = tmp.map((item) => item.trim()).toList();
    time = times.join('|');

    final bodyHtmlElement = querySelector(
        "div.post_view > div.post_content > article > div.post_article");
    bodyHtmlElement
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());
    final bodyHtml = bodyHtmlElement?.innerHtml ?? '';
    final viewCountElement =
        querySelector("div.post_information > div.post_time > div.view_count");
    viewCountElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    final viewCount = viewCountElement?.text.trim() ?? '';

    final authorIpElement =
        querySelector("div.post_view > div.post_information > div.author_ip");
    authorIpElement
        ?.querySelectorAll('.fa')
        .forEach((element) => element.remove());
    final user = querySelector(
                "div.post_view > div.post_contact > span.contact_note > div.post_memo > div.memo_box > button.button_input")
            ?.attributes['onclick'] ??
        '';
    final nickName = querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickname")
            ?.text
            .trim() ??
        '';
    final nickImage = querySelector(
                "div.post_view > div.post_contact > span.contact_name > span.nickimg > img")
            ?.attributes['src'] ??
        '';
    final likeCount = querySelector(
                "div.post_button > div.symph_area > button.symph_count > strong")
            ?.text
            .trim() ??
        '';

    var parsedTime = '';
    try {
      var dateTime = times.first._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);
    return Details(
      title: title,
      viewCount: viewCount,
      likeCount: likeCount,
      csrf: csrf,
      time: time,
      info: info,
      userInfo: UserInfo(
        id: user,
        nickName: nickName,
        nickImage: nickImage,
      ),
      comments: comments,
      bodyHtml: bodyHtml,
    );
  }

  CommentItem? _toComments(int index) {
    if (innerHtml == "<span>삭제 되었습니다.</span>") {
      return null;
    }
    final id = attributes['data-author-id'] ?? '';
    final isReply = classes.contains('re');
    final nickName = querySelector(
                "div.comment_info > div.post_contact > span.contact_name > span.nickname")
            ?.text
            .trim() ??
        '';
    final timeElement = querySelector(
        "div.comment_info > div.comment_info_area > div.comment_time");
    timeElement?.querySelector("span.timestamp")?.remove();
    final time = timeElement?.text.trim() ?? '';
    final nickImage = querySelector(
                "div.comment_info > div.post_contact > span.contact_name > span.nickimg > img")
            ?.attributes['src'] ??
        '';
    final likeCount =
        querySelector("div.comment_content_symph > button > strong")
                ?.text
                .trim() ??
            '';

    final bodyElements = querySelectorAll(
        "div.comment_content, div.comment-img, div.comment-video");
    for (final tmp in bodyElements) {
      tmp
          .querySelectorAll('input, span.name, button')
          .forEach((element) => element.remove());
    }

    final body = bodyElements.map((item) => item.innerHtml).join();
    var parsedTime = '';
    try {
      final dateTime = time._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }
    final info = nickName.isNotEmpty ? '$nickName ・ $parsedTime' : parsedTime;

    return CommentItem(
      id: index,
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
    );
  }
}

extension ElementListExt on Element {
  ListItem? _toListItem(
    int lastId,
    String baseUrl,
    String boardTitle,
  ) {
    final id = int.tryParse(attributes['data-board-sn'] ?? '') ?? 0;
    if (id <= 0 || lastId > 0 && id >= lastId) return null;

    final userId = attributes['data-author-id']?.trim() ?? '';
    final tmpUrl = attributes['href']?.trim() ?? '';
    final url = tmpUrl.toUrl(baseUrl);

    final reply = attributes['data-comment-count']?.trim() ?? '';

    var board = '';
    final end = url.lastIndexOf('/');
    final start = url.lastIndexOf('/', end - 1);
    try {
      board = url.substring(start + 1, end);
    } catch (e) {
      return null;
    }

    final category =
        querySelector('div.list_infomation > div.list_number > span.category')
                ?.text
                .trim() ??
            '';
    if (category == '공지') return null;

    final title = querySelector(
                'div.list_title > div.list_subject > span[data-role=list-title-text]')
            ?.text
            .trim() ??
        '';
    final time = querySelector(
                'div.list_infomation > div.list_number > div.list_time > span')
            ?.text
            .trim() ??
        '';
    final nickImage = querySelector(
                'div.list_infomation > div.list_author > span.nickimg > img')
            ?.attributes['src'] ??
        '';

    final hit = querySelector(
                'div.list_infomation > div.list_number > div.list_hit > span')
            ?.text
            .trim() ??
        '';
    final like =
        querySelector('div.list_title > div.list_symph > span')?.text.trim() ??
            '';
    final nickName =
        querySelector('div.list_infomation > div.list_author > span.nickname')
                ?.text
                .trim() ??
            '';
    final hasImage =
        querySelector('div.list_title > span.fa-picture-o') != null;

    var parsedTime = '';
    try {
      final dateTime = time._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time;
    }

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

extension ElementMainExt on Element {
  MainItem? _toMainItem(String baseUrl, int orderBy) {
    final urlElement = querySelector('a');
    if (urlElement == null) {
      return null;
    }
    final String href = urlElement.attributes['href'] ?? '';
    final String title = urlElement.attributes['title'] ?? '';
    final int type = urlElement.classes.contains('somoim') ? 1 : 0;
    final String url = baseUrl + href;
    final Uri uri = Uri.parse(url);
    final String board = uri.pathSegments.last;

    return MainItem(
        siteType: SiteType.clien,
        board: board,
        text: title,
        url: url,
        orderBy: orderBy,
        type: type);
  }
}
