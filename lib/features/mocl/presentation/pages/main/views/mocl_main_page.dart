import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/message_widget.dart';
import '../controllers/mocl_main_controller.dart';
import 'mocl_drawer_widget.dart';
import 'mocl_main_view.dart';
import 'mocl_show_add_dialog.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  Widget _buildTitle(BuildContext context) => Obx(() => MessageWidget(
        message: controller.siteName(),
        textStyle: Theme.of(context).textTheme.labelMedium,
      ));

  AppBar _buildAppbar(BuildContext context) => AppBar(
        title: _buildTitle(context),
        titleSpacing: 0,
        toolbarHeight: 60,
        // elevation: 8,
        // scrolledUnderElevation: 8,
        actions: [
          IconButton(
            onPressed: () => Get.dialog(ShowAddDialog()),
            icon: const Icon(Icons.add),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: DrawerWidget(onChangeSite: controller.changeSite),
        appBar: _buildAppbar(context),
        body: const MainView(),
      );
}
