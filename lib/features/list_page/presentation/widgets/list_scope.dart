import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/list_page/domain/list_density.dart';

import '../../../../config/mocl_text_styles.dart';

import 'package:mocl_shared/entities/mocl_list_item.dart';

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
      item.id != oldWidget.item.id ||
      item.isRead != oldWidget.item.isRead ||
      item.newReplyCount != oldWidget.item.newReplyCount;
}

class const ListStyleScope({
  required final AppTextStyles styles,
  // 설정 "말머리 보기". 스타일처럼 목록 전체에 같은 값이라 여기서 함께 내린다.
  final bool showCategory = true,
  // 설정 "목록 밀도" 가 컴팩트면 그 여백(화면 높이에 맞춤), 기본이면 null.
  // 스크롤 중엔 바뀌지 않는다(바꾸면 행을 한 번 다시 그린다).
  final CompactSpacing? compact,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static AppTextStyles of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListStyleScope>()!.styles;

  static bool showCategoryOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ListStyleScope>()!
      .showCategory;

  static CompactSpacing? compactOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListStyleScope>()!.compact;

  @override
  bool updateShouldNotify(ListStyleScope oldWidget) =>
      styles != oldWidget.styles ||
      showCategory != oldWidget.showCategory ||
      compact != oldWidget.compact;
}

/// 검색 결과 목록에서 제목에 강조할 검색어. 일반 목록에는 없다(빈 문자열).
class const SearchHighlightScope({
  required final String query,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static String of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SearchHighlightScope>()
          ?.query ??
      '';

  @override
  bool updateShouldNotify(SearchHighlightScope oldWidget) =>
      query != oldWidget.query;
}
