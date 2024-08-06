import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomCupertinoPageRoute extends GetPageRoute {
  CustomCupertinoPageRoute({required super.page, super.binding})
      : super(transition: Transition.cupertino);

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return CupertinoPageRoute(
      builder: (context) => page!(),
      // settings: this,
      // gestureWidthFactor: 0.8, // 스와이프 영역을 화면 너비의 80%로 설정
    );
  }
}