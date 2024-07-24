import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_detail_data_source.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../../data/repositories/mocl_detail_repository_impl.dart';
import '../../../domain/repositories/detail_repository.dart';
import '../../../domain/usecases/get_detail.dart';
import '../../../domain/usecases/get_site_type.dart';
import 'mocl_detail_controller.dart';

class DetailBindings extends Bindings {
  @override
  void dependencies() {
    var tag = Get.find<GetSiteType>().call(NoParams()).name;

    Get.lazyPut<DetailDataSource>(
      () => DetailDataSourceImpl(parser: Get.find(tag: tag)),
    );

    Get.lazyPut<DetailRepository>(
      () => DetailRepositoryImpl(detailDataSource: Get.find()),
    );

    Get.lazyPut(() => GetDetail(detailRepository: Get.find()));

    Get.lazyPut<DetailController>(() => DetailController(
          getDetail: Get.find(),
        ));
  }
}
