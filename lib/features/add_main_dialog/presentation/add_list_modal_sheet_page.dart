import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';

import '../../../core/presentation/widgets/plain_icon_button.dart';
import 'state/add_event_mixin.dart';
import 'state/add_state_mixin.dart';

class AddListBottomSheet extends ConsumerWidget with AddState, AddEvent {
  const AddListBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = theme.scaffoldBackgroundColor;
    final textStyle = theme.textTheme.bodyMedium;
    final headerStyle = theme.textTheme.titleSmall?.copyWith(
      color: theme.focusColor,
      fontWeight: FontWeight.bold,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      // ListTile 이 ink/배경을 가장 가까운 Material 에 그리므로, 배경색은
      // Container 가 아니라 Material 에 줘서 assertion(배경/잉크 가림)을 막는다.
      builder: (context, scrollController) => Material(
        color: color,
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const .symmetric(horizontal: 4),
              child: SizedBox(
                height: 62,
                child: Row(
                  children: [
                    PlainIconButton(
                      padding: const .all(10),
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(child: Center(child: Text('게시판 선택'))),
                    PlainIconButton(
                      padding: const .all(10),
                      icon: const Icon(Icons.check),
                      onPressed: () => pop(ref, context),
                    ),
                  ],
                ),
              ),
            ),
            const PlainDividerWidget(),
            // 콘텐츠
            Expanded(
              child: addState(ref).maybeWhen(
                data: (data) => ListView.builder(
                  controller: scrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final category = item.mainItem.category;
                    // 카테고리가 바뀌는 첫 항목 위에 섹션 헤더 표시.
                    final bool showHeader =
                        category.isNotEmpty &&
                        (index == 0 ||
                            data[index - 1].mainItem.category != category);
                    final tile = CheckBoxListTitleWidget(
                      text: item.mainItem.text,
                      isChecked: item.isChecked,
                      textStyle: textStyle,
                      onChanged: (isChecked) =>
                          onChanged(ref, isChecked, index),
                    );
                    if (!showHeader) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [const PlainDividerWidget(), tile],
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                          child: Text(category, style: headerStyle),
                        ),
                        tile,
                      ],
                    );
                  },
                ),
                error: (error, _) => Padding(
                  padding: const .all(8.0),
                  child: Text(error.toString()),
                ),
                orElse: () => const LoadingWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
