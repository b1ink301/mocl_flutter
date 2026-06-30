import 'package:flutter/material.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

abstract class SettingsRepository {
  SiteType getSiteType();
  void setSiteType(SiteType siteType);

  bool isShowNickImage();
  void setShowNickImage(bool showNickImage);

  double getFontSize();
  void setFontSize(double fontSize);

  ThemeMode getThemeMode();
  void setThemeMode(ThemeMode mode);
}
