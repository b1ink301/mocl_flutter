import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'use_case_provider.dart';

part 'add_list_dlg_providers.g.dart';

/// 게시판 추가 화면의 검색어. 화면이 닫히면 자동으로 초기화된다.
@riverpod
class AddListSearchQuery() extends _$AddListSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// 현재 선택된 사이트가 제공하는 전체 게시판 목록.
/// 담겼는지 여부는 즐겨찾기(favoriteBoardKeys)가 알려주므로 여기선 다루지 않는다.
@riverpod
Future<List<MainItem>> addBoardList(Ref ref) async {
  final SiteType siteType = ref.watch(currentSiteTypeProvider);
  final getMainListFromJson = ref.watch(getMainListFromJsonProvider);
  final result = await getMainListFromJson(siteType);
  return result.fold((failure) => throw failure, (data) => data);
}

/// 지금 들어가 있는 컨테이너(카페 등). null 이면 최상위 목록을 보고 있다.
///
/// 사이트를 바꾸면 들어가 있던 카페는 의미가 없으므로 스스로 빠져나온다.
@riverpod
class AddDrillDown() extends _$AddDrillDown {
  @override
  MainItem? build() {
    // 사이트가 바뀌면 다시 빌드되어 최상위로 돌아온다.
    ref.watch(currentSiteTypeProvider);
    return null;
  }

  void enter(MainItem parent) => state = parent;

  void exit() => state = null;
}

/// [parent] 안의 하위 게시판 목록.
///
/// 카페 메뉴는 거의 바뀌지 않는데 조회는 네트워크 왕복이라, 화면을 오가는
/// 동안 다시 받지 않도록 살려둔다(앱을 다시 켜면 새로 받는다).
@Riverpod(keepAlive: true)
Future<List<MainItem>> subMenuList(Ref ref, MainItem parent) async {
  final getSubMenuList = ref.watch(getSubMenuListProvider(parent.siteType));
  final result = await getSubMenuList(parent);
  return result.fold((failure) => throw failure, (data) => data);
}

/// 추가 화면이 실제로 그릴 목록. 드릴다운 여부를 여기서 흡수하므로
/// 위젯에는 '어느 단계인지' 분기가 생기지 않는다.
@riverpod
Future<List<MainItem>> addVisibleBoards(Ref ref) {
  final MainItem? parent = ref.watch(addDrillDownProvider);
  return parent == null
      ? ref.watch(addBoardListProvider.future)
      : ref.watch(subMenuListProvider(parent).future);
}

/// 컨테이너 전환 드롭다운의 열림 상태. 사이트를 바꾸면 닫힌다.
@riverpod
class AddContainerPickerOpen() extends _$AddContainerPickerOpen {
  @override
  bool build() {
    ref.watch(currentSiteTypeProvider);
    return false;
  }

  void toggle() => state = !state;

  void close() => state = false;
}
