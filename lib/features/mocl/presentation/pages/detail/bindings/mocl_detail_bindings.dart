import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';

import '../../../../../../core/usecases/usecase.dart';
import '../../../../data/repositories/mocl_detail_repository_impl.dart';
import '../../../../domain/repositories/detail_repository.dart';
import '../../../../domain/usecases/get_detail.dart';
import '../../../../domain/usecases/get_site_type.dart';
import '../controllers/mocl_detail_controller.dart';

class DetailBindings extends Binding {
  @override
  List<Bind> dependencies() => [
        Bind.lazyPut<DetailDataSource>(
          () => DetailDataSourceImpl(
            apiClient: Get.find(),
            parser:
                Get.find(tag: Get.find<GetSiteType>().call(NoParams()).name),
          ),
        ),
        Bind.lazyPut<DetailRepository>(
          () => DetailRepositoryImpl(detailDataSource: Get.find()),
        ),
        Bind.lazyPut(() => GetDetail(detailRepository: Get.find())),
        Bind.lazyPut<DetailController>(() => DetailController(
              getDetail: Get.find(),
              siteType: Get.find<GetSiteType>().call(NoParams())
            ))
      ];
}
