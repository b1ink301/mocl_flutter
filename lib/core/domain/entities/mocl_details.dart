import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_recents.dart';

import 'mocl_user_info.dart';

part 'mocl_details.freezed.dart';

@freezed
abstract class Details with _$Details {
  const factory({
    required String title,
    required String time,
    required String viewCount,
    required String likeCount,
    required String bodyHtml,
    required String info,
    required UserInfo userInfo,
    required List<CommentItem> comments,
    @Default(null) Recents? recents,
    @Default('') String csrf,
    Map<String, dynamic>? extraData,
  }) = _Details;

  factory empty() => const Details(
    title: '',
    time: '',
    viewCount: '',
    likeCount: '',
    bodyHtml: '',
    csrf: '',
    info: '',
    userInfo: UserInfo(id: 'id', nickName: 'nickName', nickImage: 'nickImage'),
    comments: [],
  );
}
