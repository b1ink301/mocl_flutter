import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/mocl_routes.dart';


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
        log('onPageChanged=$index');
        switch(index) {
          case 0: Get.toNamed(Routes.MAIN);
          case 1: Get.toNamed(Routes.LIST);
        }
      },
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container();
      },
    );
  }
}
