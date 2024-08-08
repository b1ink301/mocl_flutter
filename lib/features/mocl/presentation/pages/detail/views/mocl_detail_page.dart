import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/message_widget.dart';
import '../controllers/mocl_detail_controller.dart';
import 'mocl_detail_view.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  Widget _buildTitle(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: controller.getAppbarSmallTitle(),
            textStyle:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 2),
          Obx(
            () => MessageWidget(
                message: controller.appbarTitle.value,
                textStyle: Theme.of(context).textTheme.labelMedium),
          ),
        ],
      );

  SliverAppBar _buildAppbar(BuildContext context) => SliverAppBar(
        flexibleSpace:
            Container(color: Theme.of(context).appBarTheme.backgroundColor),
        title: _buildTitle(context),
        toolbarHeight: controller.appBarHeight.value,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.refresh),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'OpenBrowser':
                  controller.openBrowserByMenu();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'OpenBrowser',
                  child: Text('브라우저로 열기'),
                ),
              ];
            },
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            Obx(() => _buildAppbar(context)),
            const SliverToBoxAdapter(
              child: DetailView(),
            ),
          ],
        ),
      );
}
