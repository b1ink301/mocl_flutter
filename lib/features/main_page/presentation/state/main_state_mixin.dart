import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/main_page/application/main_providers.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';

mixin class MainState() {
  AsyncValue<String> appVersionState(WidgetRef ref) =>
      ref.watch(getAppVersionProvider);

  GlobalKey<ScaffoldState> scaffoldState(WidgetRef ref) =>
      ref.watch(mainScaffoldStateProvider);

  bool isSidebarExpanded(WidgetRef ref) => ref.watch(mainSidebarProvider);

  double screenWidth(WidgetRef ref) => ref.watch(screenWidthProvider);

  SiteType currentSiteType(WidgetRef ref) => ref.watch(currentSiteTypeProvider);

  bool isSiteType(WidgetRef ref, SiteType siteType) =>
      ref.watch(isCurrentSiteTypeProvider(siteType));

  TextStyle titleTextStyleState(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select((state) => state.titleTextStyle),
  );

  TextStyle smallTextStyleState(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select((state) => state.smallTextStyle),
  );

  /// 그룹/항목을 편집(순서 변경·이름 변경·삭제)하는 모드인지.
  bool editModeState(WidgetRef ref) => ref.watch(mainEditModeProvider);
}
