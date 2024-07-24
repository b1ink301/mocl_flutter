import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';

import '../../data/datasources/mocl_local_database.dart';
import '../../data/datasources/parser/base_parser.dart';
import '../../data/datasources/parser/clien_parser.dart';
import '../../data/datasources/parser/damoang_parser.dart';
import '../../domain/entities/mocl_site_type.dart';
import '../../domain/usecases/set_site_type.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put<SettingsRepository>(SettingsRepositoryImpl(), permanent: true);
    Get.lazyPut(() => GetSiteType(settingsRepository: Get.find()));
    Get.lazyPut(() => SetSiteType(settingsRepository: Get.find()));

    Get.put<BaseParser>(
      DamoangParser(),
      tag: SiteType.damoang.name,
      permanent: true,
    );

    Get.put<BaseParser>(
      ClienParser(),
      tag: SiteType.clien.name,
      permanent: true,
    );
    await Get.put(LocalDatabase(), permanent: true).init();
  }
}