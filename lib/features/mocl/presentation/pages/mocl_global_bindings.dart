import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';

import '../../data/datasources/parser/base_parser.dart';
import '../../data/datasources/parser/clien_parser.dart';
import '../../data/datasources/parser/damoang_parser.dart';
import '../../data/http/mocl_api_client.dart';
import '../../domain/entities/mocl_site_type.dart';
import '../../domain/usecases/set_site_type.dart';

class GlobalBindings extends Binding {
  @override
  List<Bind> dependencies() => [
    Bind.put(ApiClient().init(), permanent: true),
    Bind.put<SettingsRepository>(SettingsRepositoryImpl(), permanent: true),
    Bind.lazyPut(() => GetSiteType(settingsRepository: Get.find())),
    Bind.lazyPut(() => SetSiteType(settingsRepository: Get.find())),

    Bind.put<BaseParser>(
      DamoangParser(),
      tag: SiteType.damoang.name,
      permanent: true,
    ),

    Bind.put<BaseParser>(
      ClienParser(),
      tag: SiteType.clien.name,
      permanent: true,
    ),
  ];
}