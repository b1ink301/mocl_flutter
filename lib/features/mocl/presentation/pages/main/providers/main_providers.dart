import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

@riverpod
class MainItemsNotifier extends _$MainItemsNotifier {
  @override
  Future<List<MainItem>> build() async {
    final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
    final Either<Failure, List<MainItem>> result =
        await ref.read(getMainListProvider)(siteType);
    return result.fold(
      (Failure failure) => throw failure,
      (List<MainItem> data) => data,
    );
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
String mainTitle(Ref ref) {
  final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
  return siteType.title;
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
  final SiteType currentSiteType = ref.watch(currentSiteTypeNotifierProvider);
  final SetMainParams params =
      SetMainParams(siteType: currentSiteType, list: list);
  final SetMainList setList = ref.read(setMainListProvider);
  return await setList.call(params);
}

@riverpod
Future<void> handleAddButton(Ref ref, BuildContext context) async {
  final SiteType siteType = ref.read(currentSiteTypeNotifierProvider);
  final List<MainItem>? result = await context.push<List<MainItem>>(
    Routes.setMainDlgFull,
    extra: siteType,
  );

  if (!context.mounted || result == null) return;
  final Either<Failure, List<int>> state =
      await ref.read(setMainItemsProvider(result).future);
  state.fold(
    (failure) => ref.read(showToastProvider(failure.message, context)),
    (data) => ref.read(mainItemsNotifierProvider.notifier).refresh(),
  );
}
