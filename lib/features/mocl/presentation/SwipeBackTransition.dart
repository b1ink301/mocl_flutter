import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SwipeBackTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 10) {
          Get.back();
        }
      },
      child: CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: false, // iOS 스타일 슬라이드 애니메이션 사용
        child: child,
      ),
    );
  }
}
