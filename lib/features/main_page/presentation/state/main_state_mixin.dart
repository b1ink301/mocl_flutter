import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/main_page/application/main_providers.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_flutter/features/settings_page/application/settings_providers.dart';

mixin class MainState() {
  double screenWidth(WidgetRef ref) => ref.watch(screenWidthProvider);

  SiteType currentSiteType(WidgetRef ref) => ref.watch(currentSiteTypeProvider);

  /// 앱바 제목(= 지금 보고 있는 사이트 이름).
  String titleState(WidgetRef ref) => ref.watch(mainTitleProvider);

  /// 드로어 칩이 자기 사이트가 선택됐는지 물어본다.
  bool isSiteType(WidgetRef ref, SiteType siteType) =>
      ref.watch(isCurrentSiteTypeProvider(siteType));

  /// 앱 버전(드로어 헤더).
  AsyncValue<String> appVersionState(WidgetRef ref) =>
      ref.watch(getAppVersionProvider);

  GlobalKey<ScaffoldState> scaffoldState(WidgetRef ref) =>
      ref.watch(mainScaffoldStateProvider);

  bool isSidebarExpanded(WidgetRef ref) => ref.watch(mainSidebarProvider);

  TextStyle titleTextStyleState(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select((state) => state.titleTextStyle),
  );

  TextStyle smallTextStyleState(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select((state) => state.smallTextStyle),
  );

  /// 그룹/항목을 편집(순서 변경·이름 변경·삭제)하는 모드인지.
  bool editModeState(WidgetRef ref) => ref.watch(mainEditModeProvider);

  /// 현재 선택된 하단 탭.
  int tabIndexState(WidgetRef ref) => ref.watch(mainTabIndexProvider);

  /// 게시판 목록에 사이트 아이콘을 보일지(설정에서 끌 수 있다).
  bool showBoardIconState(WidgetRef ref) => ref.watch(showBoardIconProvider);

  /// 오른쪽 사이트 빠른 이동 레일을 보일지(설정에서 끌 수 있다).
  bool showQuickJumpState(WidgetRef ref) => ref.watch(showQuickJumpProvider);

  /// 검색창이 열려 있는지.
  bool searchOpenState(WidgetRef ref) => ref.watch(mainSearchOpenProvider);

  /// 내 게시판 검색어.
  String searchQueryState(WidgetRef ref) => ref.watch(mainSearchQueryProvider);

  /// 검색어를 1회 읽는다(initState 등 non-build 컨텍스트용).
  String readSearchQuery(WidgetRef ref) => ref.read(mainSearchQueryProvider);

  /// 접어둔 카페 소구획 키 집합.
  Set<String> collapsedSubSectionsState(WidgetRef ref) =>
      ref.watch(collapsedSubSectionsProvider);
}
