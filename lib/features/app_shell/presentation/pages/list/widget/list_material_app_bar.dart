import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/list_search_delegate.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';

class ListMaterialAppBar extends ConsumerWidget {
  const ListMaterialAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AppbarDualTextWidget(
    key: const ValueKey('List-MaterialAppBar'),
    smallTitle: ref.watch(listSmallTitleProvider),
    title: ref.watch(listTitleProvider),
    automaticallyImplyLeading: Platform.isMacOS,
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => showSearch(
          context: context,
          delegate: ListSearchDelegate(item: ref.watch(mainItemProvider)),
        ),
      ),
      PopupMenuButton<SortType>(
        icon: const Icon(Icons.sort),
        onSelected: (SortType value) {
          ref.read(sortTypeProvider.notifier).changeSortType(value);
          ref.read(listStateProvider.notifier).refresh();
        },
        itemBuilder: (BuildContext context) {
          final SortType sortType = ref.watch(sortTypeProvider);
          return [
            CheckedPopupMenuItem<SortType>(
              value: SortType.recent,
              checked: sortType == SortType.recent,
              child: Text('최신순'),
            ),
            CheckedPopupMenuItem<SortType>(
              value: SortType.recommend,
              checked: sortType == SortType.recommend,
              child: Text('추천순'),
            ),
          ];
        },
      ),
      PopupMenuButton<int>(
        icon: const Icon(Icons.more_vert),
        onSelected: (int value) {
          switch (value) {
            case 0:
              ref.read(listStateProvider.notifier).refresh();
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
