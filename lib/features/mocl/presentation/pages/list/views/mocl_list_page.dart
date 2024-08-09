import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/appbar_dual_text_widget.dart';
import '../controllers/mocl_list_controller.dart';
import 'mocl_list_view.dart' as view;

class ListPage extends GetView<ListController> {
  const ListPage({super.key});

  Widget _buildAppbar(BuildContext context) => AppbarDualTextWidget(
        smallTitle: RxString(controller.getAppbarSmallTitle()),
        title: RxString(controller.getAppbarTitle()),
        toolbarHeight: RxDouble(64.0),
        automaticallyImplyLeading: Platform.isMacOS,
        hasObx: false,
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
