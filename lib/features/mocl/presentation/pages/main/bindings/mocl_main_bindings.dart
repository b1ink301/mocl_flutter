import 'package:get/get.dart';

import '../../../../data/datasources/main_data_source.dart';
import '../../../../data/repositories/mocl_main_repository_impl.dart';
import '../../../../domain/repositories/main_repository.dart';
import '../../../../domain/usecases/get_main_list.dart';
import '../../../../domain/usecases/get_main_list_from_json.dart';
import '../../../../domain/usecases/set_main_list.dart';
import '../controllers/mocl_main_controller.dart';

class MainBindings extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.put<MainDataSource>(
          MainDataSourceImpl(localDatabase: Get.find()),
          permanent: true,
        ),
        Bind.put<MainRepository>(
          MainRepositoryImpl(
            mainDataSource: Get.find(),
          ),
          permanent: true,
        ),
        Bind.lazyPut(() => GetMainList(mainRepository: Get.find())),
        Bind.lazyPut(() => GetMainListFromJson(mainRepository: Get.find())),
        Bind.lazyPut(() => SetMainList(mainRepository: Get.find())),
        Bind.lazyPut<MainController>(() => MainController(
              getMainList: Get.find(),
              getMainListFromJson: Get.find(),
              setMainList: Get.find(),
              setSiteType: Get.find(),
              getSiteType: Get.find(),
            )),
      ];
}
