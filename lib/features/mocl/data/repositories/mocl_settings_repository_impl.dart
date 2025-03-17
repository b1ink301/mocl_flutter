import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  const SettingsRepositoryImpl({required SharedPreferences prefs})
      : _prefs = prefs;

  @override
  SiteType getSiteType() {
    final String siteTypeName =
        _prefs.getString(_extraSiteType) ?? SiteType.damoang.name;
    return SiteType.values.firstWhere((e) => e.name == siteTypeName);
  }

  @override
  void setSiteType(SiteType siteType) =>
      _prefs.setString(_extraSiteType, siteType.name);

  @override
  bool isShowNickImage() => _prefs.getBool(_extraShowNickImage) ?? false;

  @override
  void setShowNickImage(bool showNickImage) =>
      _prefs.setBool(_extraShowNickImage, showNickImage);

  static final String _extraSiteType = 'site_type';
  static final String _extraShowNickImage = 'show_nick_image';
}
