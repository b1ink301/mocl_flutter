import 'package:flutter/cupertino.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final Future<SharedPreferences> prefs;

  SettingsRepositoryImpl({required this.prefs});

  @override
  Future<SiteType> getSiteType() async {
    final siteTypeName = await prefs.then(
        (prefs) => prefs.getString(EXTRA_SITE_TYPE) ?? SiteType.damoang.name);
    debugPrint('[getSiteType] siteTypeName=$siteTypeName');
    return SiteType.values.firstWhere((e) => e.name == siteTypeName);
  }

  @override
  void setSiteType(SiteType siteType) {

    prefs.then((prefs) => prefs.setString(EXTRA_SITE_TYPE, siteType.name));
  }
}
