import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';

part 'mocl_comment_item.freezed.dart';

@freezed
abstract class CommentItem with _$CommentItem {
  const factory CommentItem({
    required int id,
    required String bodyHtml,
    required String mediaHtml,
    required bool isVideo,
    required String time,
    required String info,
    required String likeCount,
    required UserInfo userInfo,
    required String authorId,
    required bool isReply,
    @Default([]) List<CommentItem> replies,
  }) = _CommentItem;

  factory CommentItem.fromJson(
    Map<String, dynamic> json,
    String Function(String bodyHtml) htmlUnescape,
    String Function(double created, String nickName) buildInfo,
  ) {
    // 실제 데이터는 'data' 키 내부에 있습니다.
    final data = json['data'] as Map<String, dynamic>;
    final bodyHtml = data['body_html'].toString();
    final id = data['id'].toString();
    final likeCount = data['ups'].toString();
    final nickImage = '';
    final userId = data['author_fullname'].toString();
    final nickName = data['author'].toString();
    final double created = data['created'];
    final int depth = data['depth'];
    final replies = data['replies'];

    List<CommentItem> repliesList = [];

    if (replies is Map<String, dynamic>) {
      final repliesData = replies['data']['children'] as List;
      repliesList = repliesData
          .map(
            (replyJson) =>
                CommentItem.fromJson(replyJson, htmlUnescape, buildInfo),
          )
          .toList();
    }

    return CommentItem(
      id: id.hashCode,
      isReply: depth > 0,
      bodyHtml: htmlUnescape(bodyHtml),
      likeCount: likeCount,
      mediaHtml: '',
      isVideo: false,
      time: created.toString(),
      info: buildInfo.call(created, nickName),
      userInfo: UserInfo(id: userId, nickName: nickName, nickImage: nickImage),
      authorId: '',
      replies: repliesList,
    );
  }
}
