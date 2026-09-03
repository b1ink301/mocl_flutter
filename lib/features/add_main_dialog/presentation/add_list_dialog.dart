import 'package:material_ui/material_ui.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_widget.dart';

import 'models/checkable_main_item.dart';
import 'state/add_event_mixin.dart';
import 'state/add_state_mixin.dart';
import 'widgets/board_search_field.dart';

class const AddListDialog({super.key})
    extends ConsumerWidget
    with AddState, AddEvent {
  @Preview(name: 'AddListDialog')
  this;

  static Widget init(BuildContext context) => const AddListDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = addState(ref);
    final size = MediaQuery.sizeOf(context);

    return AlertDialog(
      elevation: 8,
      title: _buildTitle(context),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      content: _buildContent(context, state, size),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;
    return Column(
      children: [
        const SizedBox(height: 20),
        Text('게시판 선택', style: style),
        const SizedBox(height: 20),
        const DividerWidget(thickness: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    AsyncValue<List<CheckableMainItem>> state,
    Size size,
  ) => SizedBox(
    width: size.width * 0.7,
    height: size.height * 0.6,
    child: state.when(
      data: (data) => Column(
        children: [
          const BoardSearchField(),
          Expanded(child: _buildListView(context, data)),
        ],
      ),
      error: (failure, _) => MessageWidget(message: failure.toString()),
      loading: () => const LoadingWidget(),
    ),
  );

  Widget _buildListView(
    BuildContext context,
    List<CheckableMainItem> allItems,
  ) => Consumer(
    builder: (_, ref, _) {
      final titleStyle = ref.watch(
        appTextStylesFontSizeProvider.select((s) => s.titleTextStyle),
      );
      final query = searchQuery(ref).trim().toLowerCase();
      final items = query.isEmpty
          ? allItems
          : allItems
                .where(
                  (e) =>
                      e.mainItem.text.toLowerCase().contains(query) ||
                      e.mainItem.category.toLowerCase().contains(query),
                )
                .toList();
      final headerStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).focusColor,
        fontWeight: FontWeight.bold,
      );
      if (items.isEmpty) {
        return Center(child: Text("'$query' 검색 결과가 없습니다", style: titleStyle));
      }
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final category = item.mainItem.category;
          // 카테고리가 바뀌는 첫 항목 위에 섹션 헤더를 표시.
          final bool showHeader =
              category.isNotEmpty &&
              (index == 0 || items[index - 1].mainItem.category != category);
          final tile = CheckBoxListTitleWidget(
            // 필터링으로 순서가 바뀌어도 체크 상태가 섞이지 않도록
            // 항목 고유값을 키로 지정한다.
            key: ValueKey(item.mainItem.url),
            text: item.mainItem.text,
            isChecked: item.isChecked,
            textStyle: titleStyle,
            onChanged: (isChecked) => onChanged(ref, isChecked, item.mainItem),
          );
          if (!showHeader) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [const DividerWidget(indent: 0, endIndent: 0), tile],
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
                child: Text(category, style: headerStyle),
              ),
              tile,
            ],
          );
        },
      );
    },
  );

  List<Widget> _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final focusColor = theme.focusColor;
    final cancelStyle = theme.textTheme.headlineMedium;
    final applyStyle = cancelStyle?.copyWith(color: focusColor);

    return [
      TextButton(
        onPressed: context.pop,
        child: Text('취소', style: cancelStyle),
      ),
      Consumer(
        builder: (context, ref, _) => TextButton(
          onPressed: () => apply(ref, context),
          child: Text('적용', style: applyStyle),
        ),
      ),
    ];
  }
}
