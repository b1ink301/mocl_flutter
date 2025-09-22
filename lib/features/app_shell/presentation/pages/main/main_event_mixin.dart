import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/add_dialog/add_list_modal_sheet_page.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_app_pages.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'main_providers.dart';

mixin class MainEvent {
  void listenNotLoginFailure(WidgetRef ref, BuildContext context) {
    ref.listen(mainItemsProvider, (previous, next) {
      if (next case AsyncError error when error.error is NotLoginFailure) {
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
    List<MainItem>? result = await WoltModalSheet.show(
      context: context,
      modalTypeBuilder: (context) => WoltModalType.bottomSheet(),
      pageListBuilder: (bottomSheetContext) => [
        AddListModalSheetPage(
          context: bottomSheetContext,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ],
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

  void sidebarClose(WidgetRef ref) =>
      ref.read(mainSidebarProvider.notifier).close;

  void changeSiteType(WidgetRef ref, siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  static List<Override> overridesProviderScope(
    BuildContext context,
    double width,
  ) => [
    screenWidthProvider.overrideWithValue(width),
    appTextStylesProvider.overrideWithValue(AppTextStyles.of(context)),
  ];

  void handlePop(WidgetRef ref, bool didPop) {
    if (didPop) {
      return;
    }
    final state = ref.read(mainScaffoldStateProvider);
    final scaffoldState = state.currentState;

    if (scaffoldState?.isDrawerOpen == true) {
      scaffoldState?.closeDrawer();
    } else {
      SystemNavigator.pop();
    }
  }
}
