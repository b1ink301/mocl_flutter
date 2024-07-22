import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

class ListItemWrapper {
  final ValueNotifier<bool> isReadNotifier;
  final ListItem item;

  ListItemWrapper({
    required this.item,
    required this.isReadNotifier,
  });

  ListItemWrapper copyWith({
    bool? isRead,
  }) {
    return ListItemWrapper(
      item: item,
      isReadNotifier: isRead != null ? ValueNotifier(isRead) : isReadNotifier,
    );
  }
}
