import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bindings/mocl_main_bindings.dart';

import '../detail/mocl_detail_bindings.dart';
import '../list/mocl_list_bindings.dart';
import 'mocl_home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {

    MainBindings().dependencies();
    ListBindings().dependencies();
    DetailBindings().dependencies();

    Get.lazyPut(() => HomeController());
  }
}