import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class ReadableListItem extends Equatable {
  final ListItem item;
  final ValueNotifier<bool> isRead;

  const ReadableListItem({
    required this.item,
    required this.isRead,
  });

  void markAsRead() {
    if (isUnread) {
      isRead.value = true;
    }
  }

  bool get isUnread => !isRead.value;

  int get key => item.id;

  @override
  List<Object?> get props => [item.id, item.board];
}
