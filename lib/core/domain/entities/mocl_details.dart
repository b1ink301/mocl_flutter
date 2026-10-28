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
    // 상세에서 찾은 말머리. 비어 있으면 목록 아이템의 말머리를 쓴다.
    @Default('') String category,
    Map<String, dynamic>? extraData,
    // 상세를 받을 때 사이트가 로그인 상태로 응답했는지. 댓글 쓰기 버튼에 쓴다.
    @Default(false) bool isLoggedIn,
    // 댓글 쓰기에 필요한 사이트별 값(게시판 코드 · 글쓴이 id · 토큰 등).
    // 화면에는 보이지 않고 API 가 그대로 돌려받아 쓴다.
    @Default(<String, String>{}) Map<String, String> commentParams,
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
