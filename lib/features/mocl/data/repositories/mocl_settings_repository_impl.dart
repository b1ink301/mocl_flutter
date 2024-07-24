import 'package:get_storage/get_storage.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final GetStorage getStorage = GetStorage();

  @override
  SiteType getSiteType() {
    final siteTypeName =
        getStorage.read(EXTRA_SITE_TYPE) ?? SiteType.damoang.name;
    return SiteType.values.firstWhere((e) => e.name == siteTypeName);
  }

  @override
  void setSiteType(SiteType siteType) async =>
      await getStorage.write(EXTRA_SITE_TYPE, siteType.name);
}
