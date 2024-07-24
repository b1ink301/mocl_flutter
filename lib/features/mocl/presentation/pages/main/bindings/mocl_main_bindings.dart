import 'package:get/get.dart';

import '../../../../data/datasources/mocl_main_data_source.dart';
import '../../../../data/repositories/mocl_main_repository_impl.dart';
import '../../../../domain/repositories/main_repository.dart';
import '../../../../domain/usecases/get_main_list.dart';
import '../../../../domain/usecases/get_main_list_from_json.dart';
import '../../../../domain/usecases/set_main_list.dart';
import '../controllers/mocl_main_controller.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MainDataSource>(
      MainDataSourceImpl(localDatabase: Get.find()),
      permanent: true,
    );

    Get.put<MainRepository>(
      MainRepositoryImpl(
        mainDataSource: Get.find(),
      ),
      permanent: true,
    );

    Get.lazyPut(() => GetMainList(mainRepository: Get.find()));
    Get.lazyPut(() => GetMainListFromJson(mainRepository: Get.find()));
    Get.lazyPut(() => SetMainList(mainRepository: Get.find()));

    Get.lazyPut<MainController>(() => MainController(
          getMainList: Get.find(),
          getMainListFromJson: Get.find(),
          setMainList: Get.find(),
          setSiteType: Get.find(),
          getSiteType: Get.find(),
        ));
  }
}
