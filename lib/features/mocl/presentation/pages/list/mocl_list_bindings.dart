import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

import '../../../data/datasources/mocl_list_data_source.dart';
import '../../../data/datasources/parser/base_parser.dart';
import '../../../data/datasources/parser/damoang_parser.dart';
import '../../../domain/usecases/get_list.dart';
import 'mocl_list_controller.dart';

class ListBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<BaseParser>(
      DamoangParser(),
      permanent: true,
    );

    Get.put<ListDataSource>(
      ListDataSourceImpl(parser: Get.find()),
      permanent: true,
    );

    Get.put<ListRepository>(
      ListRepositoryImpl(listDataSource: Get.find()),
      permanent: true,
    );

    Get.lazyPut(() => GetList(listRepository: Get.find()));

    Get.lazyPut<ListController>(() => ListController(
      getList: Get.find(),
    ));
  }
}