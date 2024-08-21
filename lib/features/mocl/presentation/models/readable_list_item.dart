import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class ReadableListItem {
  final bool isRead;
  final ListItem item;

  const ReadableListItem({
    required this.item,
    required this.isRead,
  });

  ReadableListItem markAsRead() => ReadableListItem(item: item, isRead: true);
  ReadableListItem markAsUnread() => ReadableListItem(item: item, isRead: false);
}


