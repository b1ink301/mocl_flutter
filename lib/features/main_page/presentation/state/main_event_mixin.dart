import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/utilities.dart';

import '../../application/main_providers.dart';

mixin class MainEvent {
  void listenNotLoginFailure(WidgetRef ref, BuildContext context) {
    ref.listen(mainItemsProvider, (previous, next) {
      if (next case AsyncError<List<MainItem>> error
          when error.error is NotLoginFailure) {
        context.push<bool>(Routes.login).then((result) {
          if (context.mounted && result == true) {
            handleRefresh(ref);
          }
        });
      }
    });
  }

  Future<void> handleLogin(WidgetRef ref, BuildContext context) async {
    context.push<bool>(Routes.login).then((result) {
      if (context.mounted && result == true) {
        handleRefresh(ref);
      }
    });
  }

  void handleRefresh(WidgetRef ref) =>
      ref.read(mainItemsProvider.notifier).refresh();

  Future<void> handleAddButton(WidgetRef ref, BuildContext context) async {
    List<MainItem>? result = await context.push<List<MainItem>>(
      Routes.setMainDlgFull,
    );
    if (!context.mounted || result == null) {
      return;
    }
    final state = await ref.read(setMainItemsProvider(result).future);
    if (!context.mounted) {
      return;
    }
    state.fold(
      (failure) => failure.message.showToast(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
      ),
      (data) => handleRefresh(ref),
    );
  }

  void handleSideBarToggle(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).toggle();

  void sidebarOpen(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).open();

  void sidebarClose(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).close();

  void changeSiteType(WidgetRef ref, SiteType siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  static List<Override> overridesProviderScope(double width) => [
    screenWidthProvider.overrideWithValue(width),
  ];

  void handlePop(WidgetRef ref, bool didPop) {
    if (didPop) {
      return;
    }
    final scaffoldState = ref.read(mainScaffoldStateProvider).currentState;

    if (scaffoldState?.isDrawerOpen == true) {
      scaffoldState?.closeDrawer();
    }
  }
}
