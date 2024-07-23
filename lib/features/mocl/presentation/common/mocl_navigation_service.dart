import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/mocl_routes.dart';

import '../../domain/entities/mocl_main_item.dart';

class NavigationService {
  void gotoListPage(MainItem item) {
    Get.toNamed(Routes.LIST, arguments: item);
  }
  void backListPage(bool isReadFlag) {
    Get.back<bool>(result: isReadFlag);
  }
}