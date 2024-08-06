import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/views/mocl_detail_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/home/mocl_home_controller.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_list_page.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/views/mocl_main_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) => PageView(
      controller: homeController.pageController,
      onPageChanged: homeController.changePage,
      children: const [
        MainPage(),
        ListPage(),
        DetailPage(),
      ],
    );
}
