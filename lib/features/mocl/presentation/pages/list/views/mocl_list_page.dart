import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_list_view.dart'
    as view;
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  Widget _buildAppbar(BuildContext context, MainItem mainItem, WidgetRef ref) {
    return AppbarDualTextWidget(
      smallTitle: mainItem.siteType.title,
      title: mainItem.text,
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(
          onPressed: () => ref.read(listStateProvider(item: mainItem).notifier).refresh(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainItem = GoRouterState.of(context).extra as MainItem?;

    if (mainItem == null) {
      return _buildErrorView(context);
    }

    return Scaffold(
      body: Consumer(
        builder: (context, ref, _) => _buildBody(context, ref, mainItem),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, MainItem mainItem) {
    return NotificationListener<ScrollNotification>(
      onNotification: ref.read(listStateProvider(item: mainItem).notifier).checkLoadMoreItems,
      child: CustomScrollView(
        cacheExtent: view.ListView.itemExtent * 3,
        slivers: <Widget>[
          _buildAppbar(context, mainItem, ref),
          view.ListView(mainItem: mainItem),
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
