import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';

part 'mocl_comment_item.freezed.dart';

@freezed
class CommentItem with _$CommentItem {
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
  }) = _CommentItem;
}