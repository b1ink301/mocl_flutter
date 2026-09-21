import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import '../../../../core/presentation/widgets/appbar_actions_icon_theme.dart';
import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../../core/presentation/widgets/plain_popup_menu_button.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/list_state_mixin.dart';
import 'list_scope.dart';

class const ListAppBar({super.key}) extends ConsumerWidget with ListState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final styleScope = ListStyleScope.of(context);
    final smallTitleStyle = styleScope.smallTextStyle.copyWith(
      color: primaryColor,
    );
    final titleStyle = styleScope.titleTextStyle.copyWith(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      height: 1.15,
    );

    return SliverAppBar(
      leading: AppbarFixedIconTheme(
        child: Center(
          child: PlainIconButton(
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            icon: const PlainIcon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      ),
      expandedHeight: 100,
      automaticallyImplyLeading: false,
      title: PlainText(smallTitleState(ref), style: smallTitleStyle),
      titleSpacing: -14,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16, bottom: 4, end: 4),
            child: PlainText(
              titleState(ref),
              style: titleStyle,
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ),
        ),
      ),
      floating: true,
      pinned: false,
      centerTitle: false,
      actions: const [
        AppbarActionsIconTheme(
          children: [_SearchButton(), _SortButton(), _MoreButton()],
        ),
      ],
    );
  }
}

// 2. 검색 버튼 분리 (Theme/IconTheme 의존 없는 PlainIconButton 사용)
class const _SearchButton() extends ConsumerWidget with ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) => PlainIconButton(
    icon: const PlainIcon(Icons.search),
    onPressed: () => handleShowSearch(ref, context),
  );
}

// 3. 정렬 버튼 분리 (상태 변화에만 반응하도록 함)
class const _SortButton() extends ConsumerWidget with ListState, ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      PlainPopupMenuButton<SortType>(
        icon: const PlainIcon(Icons.sort),
        onSelected: (SortType value) => handleChangeSortType(ref, value),
        itemBuilder: (BuildContext context) => [
          CheckedPopupMenuItem<SortType>(
            value: SortType.recent,
            checked: isRecentState(ref), // 이 상태가 변할 때만 이 위젯이 리빌드됨
            child: const Text('최신순'),
          ),
          CheckedPopupMenuItem<SortType>(
            value: SortType.recommend,
            checked: isRecommendState(ref),
            child: const Text('추천순'),
          ),
        ],
      );
}

// 4. 더보기 버튼 분리 (PlainPopupMenuButton 사용)
class const _MoreButton() extends ConsumerWidget with ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      PlainPopupMenuButton<int>(
        icon: const PlainIcon(Icons.more_vert),
        onSelected: (int value) {
          if (value == 0) handleRefresh(ref);
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(value: 0, child: Text('새로고침')),
        ],
      );
}
