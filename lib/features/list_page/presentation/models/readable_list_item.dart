import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';

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
  ValueKey<int> get key => item.key;
}
