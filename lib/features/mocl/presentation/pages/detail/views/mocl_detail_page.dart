import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/views/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  Widget _buildAppbar(BuildContext context, ListItem item) => Consumer(
        builder: (context, ref, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref
                .read(appBarHeightStateProvider.notifier)
                .update(context, item.title);
          });

          final appBarHeight = ref.watch(appBarHeightStateProvider);

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
        },
      );

  @override
  Widget build(BuildContext context) {
    final listItem = GoRouterState.of(context).extra as ListItem;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppbar(context, listItem),
          SliverToBoxAdapter(
            child: DetailView(listItem: listItem),
          ),
        ],
      ),
    );
  }
}
