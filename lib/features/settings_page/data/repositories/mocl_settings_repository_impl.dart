import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/settings_repository.dart';

class const SettingsRepositoryImpl({required final SharedPreferences _prefs})
    implements SettingsRepository {
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
  bool isShowBoardIcon() => _prefs.getBool(_extraShowBoardIcon) ?? true;

  @override
  void setShowBoardIcon(bool showBoardIcon) =>
      _prefs.setBool(_extraShowBoardIcon, showBoardIcon);

  @override
  bool isShowQuickJump() => _prefs.getBool(_extraShowQuickJump) ?? true;

  @override
  void setShowQuickJump(bool showQuickJump) =>
      _prefs.setBool(_extraShowQuickJump, showQuickJump);

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
  static final String _extraShowBoardIcon = 'show_board_icon';
  static final String _extraShowQuickJump = 'show_quick_jump';
  static final String _extraThemeMode = 'theme_mode';
}
