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

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  Widget _buildAppbar(
    BuildContext context,
    String smallTitle,
    String title,
  ) =>
      AppbarDualTextWidget(
        smallTitle: smallTitle,
        title: title,
        automaticallyImplyLeading: Platform.isMacOS,
        actions: [
          Consumer(
              builder: (context, ref, child) => IconButton(
                    onPressed: () =>
                        ref.read(listStateProvider.notifier).refresh(),
                    icon: const Icon(Icons.refresh),
                  ))
        ],
      );

  @override
  Widget build(BuildContext context) {
    final mainItem = GoRouterState.of(context).extra as MainItem;

    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return NotificationListener<ScrollNotification>(
            onNotification:
                ref.read(listStateProvider.notifier).checkLoadMoreItems,
            child: CustomScrollView(
              cacheExtent: 0,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                _buildAppbar(context, mainItem.siteType.title, mainItem.text),
                view.ListView(mainItem: mainItem),
              ],
            ),
          );
        },
      ),
    );
  }
}
