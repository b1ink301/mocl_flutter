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
                message: controller.getAppbarTitle().value,
                textStyle: Theme.of(context).textTheme.labelMedium),
          ),
        ],
      );

  SliverAppBar _buildAppbar(BuildContext context) => SliverAppBar(
        title: _buildTitle(context),
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              const FlexibleSpaceBar(
            title: SizedBox.shrink(),
            collapseMode: CollapseMode.none,
          ),
        ),
        toolbarHeight: controller.calculateTitleHeight(),
        automaticallyImplyLeading: false,
        // elevation: 8,
        floating: true,
        pinned: false,
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
            _buildAppbar(context),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                child: DetailView(),
              ),
            ),
          ],
        ),
      );
}
