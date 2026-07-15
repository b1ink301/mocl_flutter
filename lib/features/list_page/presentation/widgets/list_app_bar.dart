import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../../core/presentation/widgets/plain_popup_menu_button.dart';
import '../state/list_state_mixin.dart';
import 'list_scope.dart';

class ListAppBar extends ConsumerWidget with ListState {
  const ListAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = ListStyleScope.of(
      context,
    ).titleTextStyle.copyWith(fontWeight: FontWeight.w800);
    final smallTitleStyle = Theme.of(context).textTheme.labelSmall!;

    return AppbarDualTextWidget(
      title: titleState(ref),
      smallTitle: smallTitleState(ref),
      titleStyle: titleStyle,
      smallTitleStyle: smallTitleStyle,
      automaticallyImplyLeading: Platform.isMacOS,
      // 1. 하위 위젯들을 const로 선언하여 부모 리빌드 시 영향을 받지 않도록 합니다.
      actions: const [_SearchButton(), _SortButton(), _MoreButton()],
    );
  }
}

// 2. 검색 버튼 분리 (Theme/IconTheme 의존 없는 PlainIconButton 사용)
class _SearchButton extends ConsumerWidget with ListEvent {
  const _SearchButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) => PlainIconButton(
    icon: const PlainIcon(Icons.search),
    onPressed: () => handleShowSearch(ref, context),
  );
}

// 3. 정렬 버튼 분리 (상태 변화에만 반응하도록 함)
class _SortButton extends ConsumerWidget with ListState, ListEvent {
  const _SortButton();

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
class _MoreButton extends ConsumerWidget with ListEvent {
  const _MoreButton();

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
