import 'package:material_ui/material_ui.dart';

import '../../../../config/mocl_text_styles.dart';
import '../../../../core/domain/entities/mocl_list_item.dart';

/// 행에 해당하는 [ListItem] 을 InheritedWidget 으로 전달.
/// MoclListItem 이 `const` 로 유지되면서, item 이 바뀐 행만 리빌드된다.
class const ListItemScope({
  required final ListItem item,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static ListItem of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListItemScope>()!.item;

  @override
  bool updateShouldNotify(ListItemScope oldWidget) =>
      item.id != oldWidget.item.id || item.isRead != oldWidget.item.isRead;
}

class const ListStyleScope({
  required final AppTextStyles styles,
  // 설정 "말머리 보기". 스타일처럼 목록 전체에 같은 값이라 여기서 함께 내린다.
  final bool showCategory = true,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static AppTextStyles of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListStyleScope>()!.styles;

  static bool showCategoryOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ListStyleScope>()!
      .showCategory;

  @override
  bool updateShouldNotify(ListStyleScope oldWidget) =>
      styles != oldWidget.styles || showCategory != oldWidget.showCategory;
}
