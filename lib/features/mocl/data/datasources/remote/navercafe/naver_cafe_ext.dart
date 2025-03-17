part of 'naver_cafe_parser.dart';

extension DetailExt on NaverCafeParser {
  CommentItem? _toComments(dynamic comment, int index) {
    final id = comment['id'] ?? -1;
    final writer = comment['writer'];
    var body = comment['content'].toString();
    final userId = writer['memberKey'].toString();
    final nickImage = ''; //writer['image']['url'] ?? '';
    final nickName = writer['nick'].toString();
    final isReply = comment['isRef'];
    final int time = comment['updateDate'] ?? 0;
    final likeCount = '0';
    final image = comment['image'];
    final sticker = comment['sticker'];

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
    final info = '$nickName ・ $parsedTime';

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
  }

  Details _toDetails(dynamic detail, List<CommentItem> comments) {
    final article = detail['article'];
    final bodyHtml = article['contentHtml'].toString();
    final writer = article['writer'];
    final title = article['subject'].toString().trim();
    // final id = writer['id'] ?? '';
    final nickName = writer['nick'].toString();
    final nickImage = writer['image']['url'].toString();
    final time = article['writeDate'] ?? 0;
    final viewCount = (article['readCount'] ?? 0).toString();
    // final commentCount = writer['commentCount'];
    final likeCount = '';

    String parsedTime = '';
    try {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      parsedTime = timeago.format(dateTime, locale: 'ko');
    } catch (e) {
      parsedTime = time.toString();
    }
    final info = BaseParser.parserInfo(nickName, parsedTime, viewCount);

    return Details(
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
      comments: comments,
      bodyHtml: bodyHtml,
    );
  }
}

extension ListExt on NaverCafeParser {
  ListItem? _toListItem(dynamic article, int lastId, String baseUrl,
      String boardTitle, bool isShowNickImage) {
    final int id = article['articleId'] ?? -1;

    if (id <= 0 || lastId > 0 && id >= lastId) return null;

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
    final info = BaseParser.parserInfo(nickName, parsedTime, hit.toString());

    return ListItem(
        id: id,
        title: title,
        reply: commentCount.toString(),
        category: category,
        time: time.toString(),
        url: '',
        info: info,
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
        isRead: false);
  }
}
