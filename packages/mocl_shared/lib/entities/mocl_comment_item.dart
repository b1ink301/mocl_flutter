import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';

part 'mocl_comment_item.freezed.dart';

@freezed
abstract class CommentItem with _$CommentItem {
  const factory({
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
    // 사이트가 매긴 댓글 번호. 대댓글을 달 때 부모를 가리키는 데 쓴다.
    // 비어 있으면 그 댓글엔 답글을 달 수 없다.
    @Default('') String commentId,
    // 대댓글이면 위 원댓글의 [commentId]. 한 단계만 받는 사이트(클리앙)는
    // 대댓글에 답글을 달아도 원댓글 아래로 보내야 한다.
    @Default('') String parentCommentId,
  }) = _CommentItem;
}
