import 'package:dartx/dartx.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/settings/domain/repositories/settings_repository.dart';
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

  void _setFontSize(double fontSize) =>
      _prefs.setDouble(_extraFontSize, fontSize);

  @override
  void setFontSize(double fontSize) {
    double currentFontSize = getFontSize();
    currentFontSize += fontSize;
    currentFontSize = currentFontSize.coerceIn(-5.0, 10.0);
    _setFontSize(currentFontSize);
  }

  @override
  double getFontSize() => _prefs.getDouble(_extraFontSize) ?? 0.0;

  @override
  void initFontSize() => _setFontSize(0);

  @override
  bool isShowNickImage() => _prefs.getBool(_extraShowNickImage) ?? true;

  @override
  void setShowNickImage(bool showNickImage) =>
      _prefs.setBool(_extraShowNickImage, showNickImage);

  static final String _extraSiteType = 'site_type';
  static final String _extraFontSize = 'font_size';
  static final String _extraShowNickImage = 'show_nick_image';
}
