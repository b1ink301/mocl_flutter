import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/widgets/add_list_modal_sheet_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

part 'main_providers.g.dart';

@riverpod
class MainItemsNotifier extends _$MainItemsNotifier {
  @override
  Future<List<MainItem>> build() async {
    state = const AsyncValue.loading();
    final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
    final Either<Failure, List<MainItem>> result =
        await ref.read(getMainListProvider)(siteType);
    return result.getOrElse((Failure failure) => throw failure);
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
String mainTitle(Ref ref) {
  final String title = ref.watch(
      currentSiteTypeNotifierProvider.select((siteType) => siteType.title));
  return title;
}

@riverpod
bool showAddButton(Ref ref) {
  final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
  return siteType != SiteType.naverCafe;
}

@riverpod
bool isCurrentSiteType(Ref ref, SiteType siteType) {
  final SiteType currentSiteType = ref.watch(currentSiteTypeNotifierProvider);
  return currentSiteType == siteType;
}

@riverpod
Future<Either<Failure, List<int>>> setMainItems(
    Ref ref, List<MainItem> list) async {
  final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
  final SetMainParams params = SetMainParams(siteType: siteType, list: list);
  final SetMainList setList = ref.read(setMainListProvider);
  return await setList.call(params);
}

@riverpod
Future<void> handleAddButton(Ref ref, BuildContext context) async {
  List<MainItem>? result = await WoltModalSheet.show(
    context: context,
    pageListBuilder: (bottomSheetContext) => [
      AddListModalSheetPage(context: bottomSheetContext),
    ],
  );

  // List<MainItem>? result;
  // if (isCupertino(context)) {
  //   result = await showPlatformDialog(
  //     context: context,
  //     builder: (context) => AddListDialog(),
  //     material: MaterialDialogData(
  //       useSafeArea: false,
  //     ),
  //   );
  // } else {
  //   result = await context.push<List<MainItem>>(
  //     Routes.setMainDlgFull,
  //   );
  // }

  if (!context.mounted || result == null) return;
  final Either<Failure, List<int>> state =
      await ref.read(setMainItemsProvider(result).future);
  state.fold(
    (failure) => ref.read(showToastProvider(failure.message, context)),
    (data) => ref.read(mainItemsNotifierProvider.notifier).refresh(),
  );
}

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldState> mainScaffoldState(Ref ref) =>
    GlobalKey<ScaffoldState>();

@riverpod
class MainSidebarNotifier extends _$MainSidebarNotifier {
  @override
  bool build() => false;

  void open() => state = true;

  void close() => state = false;

  void toggle() => state = !state;
}
