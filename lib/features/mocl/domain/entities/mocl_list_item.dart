import 'dart:core';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'mocl_user_info.dart';

part 'mocl_list_item.freezed.dart';

@freezed
class ListItem with _$ListItem {
  const factory ListItem({
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
  }) = _ListItem;

  factory ListItem.empty() => const ListItem(
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
