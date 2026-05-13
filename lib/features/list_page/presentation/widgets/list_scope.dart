import 'package:flutter/material.dart';

import '../../../../config/mocl_text_styles.dart';
import '../../../../core/domain/entities/mocl_list_item.dart';

/// 행에 해당하는 [ListItem] 을 InheritedWidget 으로 전달.
/// MoclListItem 이 `const` 로 유지되면서, item 이 바뀐 행만 리빌드된다.
class ListItemScope extends InheritedWidget {
  final ListItem item;

  const ListItemScope({required this.item, required super.child, super.key});

  static ListItem of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListItemScope>()!.item;

  @override
  bool updateShouldNotify(ListItemScope oldWidget) =>
      item.id != oldWidget.item.id || item.isRead != oldWidget.item.isRead;
}

class ListStyleScope extends InheritedWidget {
  final AppTextStyles styles;

  const ListStyleScope({required this.styles, required super.child, super.key});

  static AppTextStyles of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListStyleScope>()!.styles;

  @override
  bool updateShouldNotify(ListStyleScope oldWidget) =>
      styles != oldWidget.styles;
}
