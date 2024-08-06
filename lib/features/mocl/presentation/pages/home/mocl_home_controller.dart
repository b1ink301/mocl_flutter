import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/mocl_app_pages.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);
  final currentPage = 0.obs;

  changePage(int index) {
    currentPage.value = index;
    // pageController.jumpToPage(index);

    switch(index) {
      case 0 : Get.toNamed(Routes.MAIN);
      case 1 : Get.toNamed(Routes.LIST);
      case 2 : Get.toNamed(Routes.DETAIL);
    }
  }

  animateTo(page) {
    if (pageController.hasClients) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  resetController(int page) {
    // controller = PageController(initialPage: page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
