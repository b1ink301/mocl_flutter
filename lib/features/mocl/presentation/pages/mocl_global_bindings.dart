import 'package:get/get.dart';

import '../../data/datasources/mocl_local_database.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() async {
    await Get.put(LocalDatabase(), permanent: true).init();
  }
}