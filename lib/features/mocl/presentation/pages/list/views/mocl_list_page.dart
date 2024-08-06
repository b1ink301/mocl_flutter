import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/message_widget.dart';
import '../controllers/mocl_list_controller.dart';
import 'mocl_list_view.dart' as view;

class ListPage extends GetView<ListController> {
  const ListPage({super.key});

  Widget _buildTitle(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: controller.getAppbarSmallTitle(),
            textStyle:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 2),
          MessageWidget(
            textStyle: Theme.of(context).textTheme.labelMedium,
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar _buildAppbar(BuildContext context) => SliverAppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        // scrolledUnderElevation: 8,
        floating: true,
        pinned: false,
        actions: [
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.refresh),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            _buildAppbar(context),
            const view.ListView(),
          ],
        ),
      );
}
