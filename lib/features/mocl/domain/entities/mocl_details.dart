import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'mocl_user_info.dart';

part 'mocl_details.freezed.dart';

@freezed
class Details with _$Details {
  const factory Details({
    required String title,
    required String time,
    required String viewCount,
    required String likeCount,
    required String bodyHtml,
    required String csrf,
    required UserInfo userInfo,
    required List<DetailItem> bodies,
    required List<CommentItem> comments,
  }) = _Details;
}

class DetailItem {}

class CommentItem {
  final int id;
  final String bodyHtml;
  final String mediaHtml;
  final bool isVideo;
  final String time;
  final String likeCount;
  final UserInfo userInfo;
  final String authorId;
  final bool isReply;

  CommentItem({
    required this.id,
    required this.bodyHtml,
    required this.mediaHtml,
    required this.isVideo,
    required this.time,
    required this.likeCount,
    required this.userInfo,
    required this.authorId,
    required this.isReply,
  });
}
