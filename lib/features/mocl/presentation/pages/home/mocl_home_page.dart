import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

import '../list/mocl_list_bindings.dart';
import '../list/mocl_list_page.dart';
import 'mocl_home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        debugPrint('onPageChanged=$index');
        switch(index) {
          case 0: Get.toNamed('/main');
          case 1: Get.toNamed('/list');
        }
      },
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container();
      },
    );
  }
}
