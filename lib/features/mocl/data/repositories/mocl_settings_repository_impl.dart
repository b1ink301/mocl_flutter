import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl extends SettingsRepository {
  final SharedPreferences _prefs;

  SettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  SiteType getSiteType() {
    final siteTypeName =
        _prefs.getString(EXTRA_SITE_TYPE) ?? SiteType.damoang.name;
    return SiteType.values.firstWhere((e) => e.name == siteTypeName);
  }

  @override
  void setSiteType(SiteType siteType) =>
      _prefs.setString(EXTRA_SITE_TYPE, siteType.name);
}
