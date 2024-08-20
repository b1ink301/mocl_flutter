import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class ReadableListItem {
  final ValueNotifier<bool> readNotifier;
  final ListItem item;

  const ReadableListItem({
    required this.item,
    required this.readNotifier,
  });

  void markAsRead() => readNotifier.value = true;
  void markAsUnread() => readNotifier.value = false;
}


