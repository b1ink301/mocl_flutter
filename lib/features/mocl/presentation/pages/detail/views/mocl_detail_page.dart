import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/appbar_dual_text_widget.dart';
import '../controllers/mocl_detail_controller.dart';
import 'mocl_detail_view.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  Widget _buildAppbar(BuildContext context) => AppbarDualTextWidget(
        title: controller.appbarTitle,
        smallTitle: RxString(controller.getAppbarSmallTitle()),
        automaticallyImplyLeading: Platform.isMacOS,
        toolbarHeight: controller.appBarHeight,
        actions: [
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<int>(
            onSelected: (int value) {
              switch (value) {
                case 0:
                  controller.openBrowserByMenu();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('브라우저로 열기'),
              ),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            _buildAppbar(context),
            const SliverToBoxAdapter(
              child: DetailView(),
            ),
          ],
        ),
      );
}
