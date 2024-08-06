import 'package:get/get.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';

import '../../../../data/datasources/mocl_list_data_source.dart';
import '../../../../domain/usecases/get_list.dart';
import '../controllers/mocl_list_controller.dart';

class ListBindings extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.lazyPut<ListDataSource>(
        () => ListDataSourceImpl(
        localDatabase: Get.find(),
        parser: Get.find(tag: Get.find<GetSiteType>().call(NoParams()).name),
      ),
    ),

    Bind.put<ListRepository>(
      ListRepositoryImpl(listDataSource: Get.find()),
    ),

    Bind.lazyPut(() => GetList(listRepository: Get.find())),
    Bind.lazyPut(() => SetReadFlag(listRepository: Get.find())),

    Bind.lazyPut<ListController>(
      () => ListController(
        getList: Get.find(),
        setReadFlag: Get.find(),
      ),
    )
  ];
}
