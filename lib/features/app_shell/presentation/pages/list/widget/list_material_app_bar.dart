import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';

import '../list_event_mixin.dart';
import '../list_state_mixin.dart';

class ListMaterialAppBar extends ConsumerWidget with ListState, ListEvent {
  const ListMaterialAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppbarDualTextWidget(
    key: const ValueKey('List-MaterialAppBar'),
    smallTitle: smallTitleState(ref),
    title: titleState(ref),
    automaticallyImplyLeading: Platform.isMacOS,
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => handleShowSearch(ref, context),
      ),
      PopupMenuButton<SortType>(
        icon: const Icon(Icons.sort),
        onSelected: (SortType value) => handleChangeSortType(ref, value),
        itemBuilder: (BuildContext context) => [
          CheckedPopupMenuItem<SortType>(
            value: SortType.recent,
            checked: isRecentState(ref),
            child: Text('최신순'),
          ),
          CheckedPopupMenuItem<SortType>(
            value: SortType.recommend,
            checked: isRecommendState(ref),
            child: Text('추천순'),
          ),
        ],
      ),
      PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (int value) {
          switch (value) {
            case 0:
              handleRefresh(ref);
              break;
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(value: 0, child: Text('새로고침')),
        ],
      ),
    ],
  );
}
