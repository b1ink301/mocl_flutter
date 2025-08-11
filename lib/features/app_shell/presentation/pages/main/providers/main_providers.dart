import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

@riverpod
class MainItemsNotifier extends _$MainItemsNotifier {
  @override
  Future<List<MainItem>> build() async {
    state = const AsyncValue.loading();
    final siteType = ref.watch(currentSiteTypeNotifierProvider);
    final result = await ref.read(getMainListProvider)(siteType);
    return result.getOrElse((Failure failure) => throw failure);
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
String mainTitle(Ref ref) {
  final String title = ref.watch(
    currentSiteTypeNotifierProvider.select((siteType) => siteType.title),
  );
  return title;
}

@riverpod
bool showAddButton(Ref ref) {
  final siteType = ref.watch(currentSiteTypeNotifierProvider);
  return siteType != SiteType.naverCafe;
}

@riverpod
bool isCurrentSiteType(Ref ref, SiteType siteType) {
  final SiteType currentSiteType = ref.watch(currentSiteTypeNotifierProvider);
  return currentSiteType == siteType;
}

@riverpod
Future<Either<Failure, List<int>>> setMainItems(Ref ref, List<MainItem> list) {
  final siteType = ref.read(currentSiteTypeNotifierProvider);
  final params = SetMainParams(siteType: siteType, list: list);
  final result = ref.read(setMainListProvider).call(params);
  return result;
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
