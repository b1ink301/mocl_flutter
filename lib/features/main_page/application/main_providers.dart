import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/main_page/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/main_page/application/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

@riverpod
class MainItemsNotifier extends _$MainItemsNotifier {
  @override
  Future<List<MainItem>> build() async {
    state = const AsyncValue.loading();
    final siteType = ref.watch(currentSiteTypeProvider);
    final result = await ref.watch(getMainListProvider)(siteType);
    return result.getOrElse((Failure failure) => throw failure);
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
String mainTitle(Ref ref) =>
    ref.watch(currentSiteTypeProvider.select((state) => state.title));

@riverpod
bool showAddButton(Ref ref) => ref.watch(
  currentSiteTypeProvider.select(
    (state) => state != SiteType.naverCafe && state != SiteType.reddit,
  ),
);

@riverpod
bool isCurrentSiteType(Ref ref, SiteType siteType) =>
    ref.watch(currentSiteTypeProvider.select((state) => state == siteType));

@riverpod
Future<Either<Failure, List<int>>> setMainItems(Ref ref, List<MainItem> list) {
  final siteType = ref.read(currentSiteTypeProvider);
  final params = SetMainParams(siteType: siteType, list: list);
  return ref.read(setMainListProvider)(params);
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
