import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class ReadableListItem {
  final ListItem item;
  final ValueNotifier<bool> isRead;

  const ReadableListItem({
    required this.item,
    required this.isRead,
  });

  void markAsRead() => isRead.value = true;
  void markAsUnread() => isRead.value = false;
}


