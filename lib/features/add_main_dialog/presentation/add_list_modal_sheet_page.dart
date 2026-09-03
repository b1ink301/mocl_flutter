import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';

import '../../../core/presentation/widgets/plain_icon_button.dart';
import 'state/add_event_mixin.dart';
import 'state/add_state_mixin.dart';
import 'widgets/board_search_field.dart';

/// 고른 게시판을 어느 즐겨찾기 그룹에 담을지 선택한다.
/// 기본값은 사이트가 속한 카테고리라 그냥 체크만 해도 알아서 정리된다.
class const _GroupSelector() extends ConsumerWidget with AddState, AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FavoriteGroup> groups = favoriteGroups(ref);
    if (groups.isEmpty) return const SizedBox.shrink();

    final String selected = targetGroupId(ref);
    final bool exists = groups.any((group) => group.id == selected);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Text('그룹', style: theme.textTheme.bodySmall),
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: exists ? selected : groups.first.id,
              underline: const SizedBox.shrink(),
              items: [
                for (final FavoriteGroup group in groups)
                  DropdownMenuItem<String>(
                    value: group.id,
                    child: Text(group.name, style: theme.textTheme.bodyMedium),
                  ),
              ],
              onChanged: (value) {
                if (value != null) selectGroup(ref, value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class const AddListBottomSheet({super.key})
    extends ConsumerWidget
    with AddState, AddEvent {
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
        borderRadius: BorderRadiusGeometry.horizontal(
          left: Radius.circular(24),
          right: Radius.circular(24),
        ),
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
                      onPressed: () => apply(ref, context),
                    ),
                  ],
                ),
              ),
            ),
            const PlainDividerWidget(),
            const _GroupSelector(),
            const BoardSearchField(),
            // 콘텐츠
            Expanded(
              child: addState(ref).maybeWhen(
                data: (allData) {
                  final query = searchQuery(ref).trim().toLowerCase();
                  final data = query.isEmpty
                      ? allData
                      : allData
                            .where(
                              (e) =>
                                  e.mainItem.text.toLowerCase().contains(
                                    query,
                                  ) ||
                                  e.mainItem.category.toLowerCase().contains(
                                    query,
                                  ),
                            )
                            .toList();
                  if (data.isEmpty) {
                    return Center(
                      child: Text("'$query' 검색 결과가 없습니다", style: textStyle),
                    );
                  }
                  return ListView.builder(
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
                        // 필터링으로 순서가 바뀌어도 체크 상태가 섞이지 않도록
                        // 항목 고유값을 키로 지정한다.
                        key: ValueKey(item.mainItem.url),
                        text: item.mainItem.text,
                        isChecked: item.isChecked,
                        textStyle: textStyle,
                        onChanged: (isChecked) =>
                            onChanged(ref, isChecked, item.mainItem),
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
                  );
                },
                error: (error, _) => Padding(
                  padding: const .all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(error.toString(), style: textStyle),
                      // 로그인해야 목록을 받아오는 사이트(레딧 · 네이버카페)를 위해
                      // 여기서 바로 로그인으로 넘어갈 수 있게 한다.
                      if (error is NotLoginFailure)
                        TextButton(
                          onPressed: () => loginAndRetry(ref, context),
                          child: const Text('로그인하기'),
                        ),
                    ],
                  ),
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
