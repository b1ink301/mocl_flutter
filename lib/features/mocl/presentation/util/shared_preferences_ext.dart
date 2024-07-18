import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';


extension SharedPreferencesExt on SharedPreferences {
  static String SITE_TYPE = 'site_type';

 // SiteType getSiteType() {
 //   setString(SITE_TYPE, SiteType.Damoang.name);
 //   return getString(SITE_TYPE) ?? SiteType.Damoang
 // }
}