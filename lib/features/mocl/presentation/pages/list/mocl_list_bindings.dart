import 'package:get/get.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';

import '../../../data/datasources/mocl_list_data_source.dart';
import '../../../domain/usecases/get_list.dart';
import 'mocl_list_controller.dart';

class ListBindings extends Bindings {
  @override
  void dependencies() {
    var tag = Get.find<GetSiteType>().call(NoParams()).name;
    Get.lazyPut<ListDataSource>(
        () => ListDataSourceImpl(
        localDatabase: Get.find(),
        parser: Get.find(tag: tag),
      ),
    );

    Get.put<ListRepository>(
      ListRepositoryImpl(listDataSource: Get.find()),
    );

    Get.lazyPut(() => GetList(listRepository: Get.find()));
    Get.lazyPut(() => SetReadFlag(listRepository: Get.find()));

    Get.lazyPut<ListController>(
      () => ListController(
        getList: Get.find(),
        setReadFlag: Get.find(),
      ),
    );
  }
}
