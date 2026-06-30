import 'package:flutter/material.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;

  const SettingsRepositoryImpl({required this._prefs});

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
  void setFontSize(double fontSize) =>
      _prefs.setDouble(_extraFontSize, fontSize);

  @override
  double getFontSize() => _prefs.getDouble(_extraFontSize) ?? 0.0;

  @override
  bool isShowNickImage() => _prefs.getBool(_extraShowNickImage) ?? true;

  @override
  void setShowNickImage(bool showNickImage) =>
      _prefs.setBool(_extraShowNickImage, showNickImage);

  @override
  ThemeMode getThemeMode() {
    final String? name = _prefs.getString(_extraThemeMode);
    return ThemeMode.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  void setThemeMode(ThemeMode mode) =>
      _prefs.setString(_extraThemeMode, mode.name);

  static final String _extraSiteType = 'site_type';
  static final String _extraFontSize = 'font_size';
  static final String _extraShowNickImage = 'show_nick_image';
  static final String _extraThemeMode = 'theme_mode';
}
