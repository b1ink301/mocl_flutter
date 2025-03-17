part of 'meeco_parser.dart';

extension StringExt on String {
  DateTime _toDateTime() {
    if (contains(' ')) {
      // 년.월.일 형식
      final parts = split(' ');
      final dateParts = parts[0].split('.');
      final timeParts = parts[1].split(':');
      if (dateParts.length == 4) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } else if (dateParts.length == 3) {
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
      var timeParts = split(':');
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

extension ElementDetialExt on Element {
  CommentItem? _toComments(String baseUrl, int index) {
    final headerElement = querySelector('header.cmt_hd');
    final isReply = attributes['class']?.contains('reply') ?? false;
    final profileElement =
        headerElement?.querySelector('div.pf_wrap > span.pf > img.pf_img');

    final tmpUrl = profileElement?.attributes['src']?.trim() ?? '';
    final nickImage = tmpUrl.toUrl(baseUrl);
    final nickName = profileElement?.attributes['alt'] ?? '익명';
    final time = querySelector('span.date')?.text.trim() ?? '';
    final likeCount =
        querySelector('div.cmt_vote > span.cmt_vote_up > b.num')?.text.trim() ??
            '';

    final body = querySelector('div.xe_content');
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
    var bodyHtml = body?.innerHtml;

    if (bodyHtml
            ?.startsWith('<a href="https://meeco.kr/index.php?mid=sticker&') ==
        true) {
      final atag =
          HtmlParser(bodyHtml).parse().getElementsByTagName('a').firstOrNull;
      final style = atag?.attributes['style'];
      if (style != null) {
        final RegExp urlRegex = RegExp(r'url\((https?:\/\/[^)]+)\)');
        final Match? match = urlRegex.firstMatch(style);

        if (match != null) {
          final url = match.group(1)!;
          bodyHtml = '<img src=$url height="140" width="140">';
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
  }

  Details _toDetails(String baseUrl, List<CommentItem> comments) {
    final title = querySelector('header.atc_hd > h1 > a')?.text.trim() ?? '';

    final infoElement = querySelector('header.atc_hd > div.atc_info');

    final nickName = querySelector('span.nickname > a > span')?.text.trim() ??
        infoElement?.querySelector('span.nickname')?.text.trim() ??
        '';

    final tmpUrl =
        infoElement?.querySelector('span.pf > img.pf_img')?.attributes['src'] ??
            '';
    final nickImage = tmpUrl.toUrl(baseUrl);
    // final nickName =
    //     infoElement?.querySelector('span.nickname')?.text.trim() ?? '';

    final bodyHtml = querySelector('div.atc_body');
    bodyHtml
        ?.querySelectorAll('input, button')
        .forEach((element) => element.remove());

    final time = infoElement?.querySelectorAll('ul > li')[0].text.trim() ?? '';

    final viewCount =
        infoElement?.querySelectorAll('ul > li')[1].text.trim() ?? '0';
    final likeCount = '';

    var parsedTime = '';
    try {
      var dateTime = time._toDateTime();
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } on Exception {
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
    final category =
        querySelector('span.hot_text, span.notice_text')?.text.trim() ?? '';

    if (category == "공지" || category == "핫글") return null;

    final infoElement = querySelector('a.list_link');
    final title = infoElement?.attributes['title']?.trim() ?? '';
    final tmpUrl = infoElement?.attributes['href']?.trim() ?? '';
    final url = tmpUrl.toUrl(baseUrl);

    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final idString = uri.pathSegments.lastOrNull ?? '-1';
    final id = int.tryParse(idString) ?? -1;
    if (id <= 0 || lastId > 0 && id >= lastId) return null;

    final nickName =
        querySelector('div.list_info > div:first-child')?.text.trim() ??
            ''; //:first-child, div:nth-child(2)
    final userId = nickName;
    final reply = querySelector("a.list_cmt")?.text.trim() ?? '';

    var board = '';
    final end = url.lastIndexOf("/");
    if (end > 0) {
      final start = url.lastIndexOf("/", end - 1);
      if (start >= 0) {
        board = url.substring(start + 1, end);
      }
    }

    final time =
        querySelector('div.list_info > div:nth-child(1)')?.text.trim() ?? '';
    final parsedTime = time;
    final nickImage = '';
    final hit =
        querySelector('div.list_info > div:nth-child(2)')?.text.trim() ?? '';
    final like =
        querySelector('div.list_info > div.list_vote')?.text.trim() ?? '';

    final hasImage = false;
    final info = BaseParser.parserInfo(nickName, parsedTime, hit);
    return ListItem(
        id: id,
        title: title,
        reply: reply,
        category: category,
        time: time,
        url: url,
        info: info,
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
        isRead: false);
  }
}

extension ElementMainExt on Element {
  MainItem? _toMainItem(String baseUrl, int orderBy) {
    throw UnimplementedError('_toMainItem');
  }
}
