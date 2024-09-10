import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view/list_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  Widget _buildAppbar(
    BuildContext context,
    String smallTitle,
    String title,
    void Function() refresh,
  ) =>
      AppbarDualTextWidget(
        smallTitle: smallTitle,
        title: title,
        automaticallyImplyLeading: Platform.isMacOS,
        actions: [
          IconButton(
            onPressed: refresh,
            icon: const Icon(Icons.refresh),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final mainItem = GoRouterState.of(context).extra as MainItem?;
    if (mainItem == null) {
      return _buildErrorView(context);
    }

    // final viewModel = ref.watch(listViewModelProvider(mainItem).notifier);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification) {
            if (scrollInfo.metrics.extentAfter < 800) {
              // viewModel.fetchNextPage();
            }
          }
          return true;
        },
        child: CustomScrollView(
          cacheExtent: 0,
          slivers: <Widget>[
            _buildAppbar(
              context,
              'viewModel.smallTitle',
              'viewModel.title',
              () {},
            ),
            OptimizedListView(mainItem: mainItem),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.pop(),
        child: const MessageWidget(message: '알 수 없는 에러 발생'),
      ),
    );
  }
}
