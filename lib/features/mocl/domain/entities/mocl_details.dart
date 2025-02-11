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
    required String info,
    required UserInfo userInfo,
    required List<CommentItem> comments,
  }) = _Details;

  factory Details.empty() => const Details(
        title: '',
        time: '',
        viewCount: '',
        likeCount: '',
        bodyHtml: '',
        csrf: '',
        info: '',
        userInfo:
            UserInfo(id: 'id', nickName: 'nickName', nickImage: 'nickImage'),
        comments: [],
      );
}

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
