import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'mocl_user_info.dart';

part 'mocl_list_item.freezed.dart';

@freezed
abstract class ListItem with _$ListItem {
  const factory({
    required int id,
    required String title,
    required String reply,
    required String category,
    required String time,
    required String url,
    required String info,
    required String board,
    required String boardTitle,
    required String like,
    required String hit,
    required UserInfo userInfo,
    required bool hasImage,
    required bool isRead,

    /// 읽은 글에서, 마지막으로 열었을 때보다 늘어난 댓글 수. 파서는 채우지 않고
    /// 앱이 목록을 받은 뒤 로컬 기록과 비교해 넣는다.
    @Default(0) int newReplyCount,
  }) = _ListItem;

  factory empty() => const ListItem(
    id: -1,
    title: '',
    reply: '',
    category: '',
    time: '',
    url: '',
    info: '',
    board: '',
    boardTitle: '',
    like: '',
    hit: '',
    userInfo: UserInfo(id: '', nickName: '', nickImage: ''),
    hasImage: false,
    isRead: false,
  );
}
