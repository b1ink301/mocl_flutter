import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_provider.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../widgets/appbar_dual_text_widget.dart';
import 'mocl_list_view.dart' as view;

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
                onPressed: () => ref.read(listStateProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
              )
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final mainItem = GoRouterState.of(context).extra as MainItem;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppbar(context, mainItem.siteType.title, mainItem.text),
          view.ListView(mainItem: mainItem),
        ],
      ),
    );
  }
}
