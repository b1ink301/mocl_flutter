import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_view.dart'
    as view;
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class ListPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final mainItem = GoRouterState.of(context).extra as MainItem?;
    if (mainItem == null) {
      return _buildErrorView(context);
    }

    final viewModel = ref.watch(listViewModelProvider(mainItem).notifier);

    return Scaffold(
      body: CustomScrollView(
        cacheExtent: 100,
        slivers: <Widget>[
          _buildAppbar(
            context,
            viewModel.smallTitle,
            viewModel.title,
            viewModel.refresh,
          ),
          view.ListView(viewModel: viewModel),
        ],
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
