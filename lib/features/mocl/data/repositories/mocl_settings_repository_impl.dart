import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl extends SettingsRepository {
  final SharedPreferences prefs;

  SettingsRepositoryImpl({required this.prefs});

  // @preResolve
  // SharedPreferencesAsync get prefs => SharedPreferencesAsync();

  @override
  SiteType getSiteType() {
    final siteTypeName =
        prefs.getString(EXTRA_SITE_TYPE) ?? SiteType.damoang.name;
    return SiteType.values.firstWhere((e) => e.name == siteTypeName);
  }

  @override
  void setSiteType(SiteType siteType) =>
      prefs.setString(EXTRA_SITE_TYPE, siteType.name);
}
