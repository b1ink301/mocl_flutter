import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({super.key});

  Widget _buildAppbar(
    BuildContext context,
    ReadableListItem item,
  ) =>
      Consumer(
        builder: (context, ref, _) {
          final viewModel = ref.watch(detailViewModelProvider(item).notifier);
          final appBarHeight = ref.watch(
              detailViewModelProvider(item).select((vm) => vm.appBarHeight));

          return appBarHeight.when(
            data: (height) => AppbarDualTextWidget(
              title: viewModel.title,
              smallTitle: viewModel.smallTitle,
              automaticallyImplyLeading: Platform.isMacOS,
              toolbarHeight: height,
              actions: [
                PopupMenuButton<int>(
                  onSelected: (int value) {
                    switch (value) {
                      case 0:
                        viewModel.refresh();
                        break;
                      case 1:
                        viewModel.openBrowser(item.item.url);
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
            ),
            loading: () => const SizedBox(height: 64),
            error: (err, stack) => MessageWidget(message: err.toString()),
          );
        },
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = GoRouterState.of(context).extra as ReadableListItem;

    ref.watch(detailViewModelProvider(item).notifier).updateAppbarHeight(
          Theme.of(context).textTheme.labelMedium!,
          MediaQuery.of(context).size.width,
        );

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppbar(context, item),
          SliverToBoxAdapter(
            child: DetailView(
              item: item,
            ),
          ),
        ],
      ),
    );
  }
}
