import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var page = 0.obs;
  var controller = PageController().obs;

  onPageChanged(index) {
    page.value = index;
  }

  animateTo(int page) {
    if (controller.value.hasClients) {
      controller.value.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  resetController(int page) {
    controller.value = PageController(initialPage: page);
  }
}
