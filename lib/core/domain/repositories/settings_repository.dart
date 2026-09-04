import 'package:material_ui/material_ui.dart' show ThemeMode;
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

abstract class SettingsRepository() {
  SiteType getSiteType();
  void setSiteType(SiteType siteType);

  bool isShowNickImage();
  void setShowNickImage(bool showNickImage);

  /// 메인 게시판 목록 왼쪽에 사이트 아이콘(또는 색 배지)을 보일지.
  bool isShowBoardIcon();
  void setShowBoardIcon(bool showBoardIcon);

  /// 메인 화면 오른쪽의 사이트 빠른 이동 레일을 보일지.
  bool isShowQuickJump();
  void setShowQuickJump(bool showQuickJump);

  double getFontSize();
  void setFontSize(double fontSize);

  ThemeMode getThemeMode();
  void setThemeMode(ThemeMode mode);
}
