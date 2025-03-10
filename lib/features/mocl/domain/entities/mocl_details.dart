import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';

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
    dynamic extraData,
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
