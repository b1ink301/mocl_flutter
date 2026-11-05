import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';

@immutable
class const ReadableListItem({
  required final ListItem item,
  required final ValueNotifier<bool> isRead,
}) extends Equatable {
  void markAsRead() {
    if (isUnread) {
      isRead.value = true;
    }
  }

  bool get isUnread => !isRead.value;

  @override
  List<Object?> get props => [item.id, item.board];
}

extension ReadableListItemExtension on ReadableListItem {
  // 읽음이 바뀌면 다른 행으로 보이도록 id 와 읽음 여부를 함께 키로 쓴다.
  ValueKey<int> get key => ValueKey<int>(Object.hash(item.id, item.isRead));
}
