import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/di/app_provider.dart';

import 'main_providers.dart';

mixin class MainState {
  AsyncValue<List<MainItem>> mainState(WidgetRef ref) =>
      ref.watch(mainItemsProvider);

  String titleState(WidgetRef ref) => ref.watch(mainTitleProvider);

  bool showAddButtonState(WidgetRef ref) => ref.watch(showAddButtonProvider);

  GlobalKey<ScaffoldState> scaffoldState(WidgetRef ref) =>
      ref.watch(mainScaffoldStateProvider);

  bool isSidebarExpanded(WidgetRef ref) => ref.watch(mainSidebarProvider);

  double screenWidth(WidgetRef ref) => ref.watch(screenWidthProvider);

  SiteType currentSiteType(WidgetRef ref) => ref.watch(currentSiteTypeProvider);

  bool isSiteType(WidgetRef ref, SiteType siteType) =>
      ref.watch(isCurrentSiteTypeProvider(siteType));
}
