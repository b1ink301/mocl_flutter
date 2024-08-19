import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_provider.dart';

import '../../../../domain/entities/mocl_list_item.dart';
import '../../../widgets/appbar_dual_text_widget.dart';
import 'mocl_detail_view.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({super.key});

  Widget _buildAppbar(BuildContext context, WidgetRef ref, ListItem item) {
    final appBarHeight = ref.watch(appBarHeightStateProvider(context, item.title));

    return AppbarDualTextWidget(
      title: item.title,
      smallTitle: item.boardTitle,
      automaticallyImplyLeading: Platform.isMacOS,
      toolbarHeight: appBarHeight,
      actions: [
        PopupMenuButton<int>(
          onSelected: (int value) {
            switch (value) {
              case 0:
                // controller.openBrowserByMenu();
                break;
              case 1:
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 0,
              child: Text('새로고침'),
            ),
            const PopupMenuItem(
              value: 1,
              child: Text('브라우저로 열기'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listItem = GoRouterState.of(context).extra as ListItem;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppbar(context, ref, listItem),
          SliverToBoxAdapter(
            child: DetailView(listItem: listItem),
          ),
        ],
      ),
    );
  }
}
