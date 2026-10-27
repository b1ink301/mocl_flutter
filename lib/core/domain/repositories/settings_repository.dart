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

  /// 본문 링크가 지원 사이트의 글이면 브라우저 대신 앱 상세 화면으로 열지.
  bool isOpenSiteLinksInApp();
  void setOpenSiteLinksInApp(bool openInApp);

  /// 본문의 유튜브 · 영상 파일 링크를 앱 안 플레이어로 재생할지.
  bool isPlayVideosInApp();
  void setPlayVideosInApp(bool playInApp);

  /// 접어둔 카페 소구획 키 목록('{siteType}_{부모board}').
  /// 그룹 접힘과 마찬가지로 앱을 다시 켜도 유지한다.
  List<String> getCollapsedSubSections();
  void setCollapsedSubSections(List<String> keys);

  double getFontSize();
  void setFontSize(double fontSize);

  ThemeMode getThemeMode();
  void setThemeMode(ThemeMode mode);
}
