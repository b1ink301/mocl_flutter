import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/main_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/main_page/domain/usecases/set_main_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_providers.g.dart';

@riverpod
class MainItemsNotifier() extends _$MainItemsNotifier {
  @override
  Future<List<MainItem>> build() async {
    state = const AsyncValue.loading();
    final siteType = ref.watch(currentSiteTypeProvider);
    final result = await ref.watch(getMainListProvider)(siteType);
    return result.getOrElse((Failure failure) => throw failure);
  }

  void refresh() => ref.invalidateSelf();

  /// 메인 항목을 드래그로 재정렬한다. 낙관적으로 화면을 먼저 갱신한 뒤
  /// orderBy 를 0..n 으로 재부여해 DB 에 저장한다(저장 순서가 곧 표시 순서).
  Future<void> reorder(int oldIndex, int newIndex) async {
    final List<MainItem>? current = state.asData?.value;
    if (current == null || oldIndex == newIndex) return;
    // onReorderItem 콜백은 제거 후 인덱스를 이미 보정해 넘겨준다(별도 -1 불필요).

    final List<MainItem> list = List<MainItem>.of(current);
    final MainItem moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    final List<MainItem> reordered = [
      for (int i = 0; i < list.length; i++) list[i].copyWith(orderBy: i),
    ];
    state = AsyncData(reordered);

    final SiteType siteType = ref.read(currentSiteTypeProvider);
    await ref.read(setMainListProvider)(
      SetMainParams(siteType: siteType, list: reordered),
    );
  }
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

/// 메인 항목 '정렬 모드' 토글. 켜져 있을 때만 드래그 핸들이 노출되고
/// 드래그로 순서를 바꿀 수 있다(평소엔 탭으로 게시판 이동).
@riverpod
class MainReorderMode() extends _$MainReorderMode {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void off() => state = false;
}

@riverpod
class MainSidebarNotifier() extends _$MainSidebarNotifier {
  @override
  bool build() => false;

  void open() => state = true;

  void close() => state = false;

  void toggle() => state = !state;
}
