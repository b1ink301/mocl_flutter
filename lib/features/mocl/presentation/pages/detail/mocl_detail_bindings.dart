import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_detail_data_source.dart';

import '../../../data/repositories/mocl_detail_repository_impl.dart';
import '../../../domain/repositories/detail_repository.dart';
import '../../../domain/usecases/get_detail.dart';
import 'mocl_detail_controller.dart';

class DetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<DetailDataSource>(
      DetailDataSourceImpl(parser: Get.find()),
      permanent: true,
    );

    Get.put<DetailRepository>(
      DetailRepositoryImpl(detailDataSource: Get.find()),
      permanent: true,
    );

    Get.lazyPut(() => GetDetail(detailRepository: Get.find()));

    Get.lazyPut<DetailController>(() => DetailController(
      getDetail: Get.find(),
    ));
  }
}