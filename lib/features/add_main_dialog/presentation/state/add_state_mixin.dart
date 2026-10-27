import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

import '../../application/add_list_dlg_providers.dart';

mixin class AddState() {
  /// 현재 사이트의 전체 게시판 목록.
  AsyncValue<List<MainItem>> boardListState(WidgetRef ref) =>
      ref.watch(addBoardListProvider);

  /// 화면이 지금 그려야 할 목록(최상위 또는 들어가 있는 컨테이너의 하위 메뉴).
  AsyncValue<List<MainItem>> visibleBoardsState(WidgetRef ref) =>
      ref.watch(addVisibleBoardsProvider);

  /// 지금 들어가 있는 컨테이너. null 이면 최상위.
  MainItem? drillParent(WidgetRef ref) => ref.watch(addDrillDownProvider);

  /// 지금 들어가 있는 컨테이너를 1회 읽는다(뒤로가기 처리 등 non-build 용).
  MainItem? readDrillParent(WidgetRef ref) => ref.read(addDrillDownProvider);

  /// 같은 사이트에서 옮겨 다닐 수 있는 컨테이너 목록(카페 전환 드롭다운용).
  List<MainItem> siblingContainers(WidgetRef ref) =>
      ref.watch(addBoardListProvider).maybeWhen(
        data: (boards) => boards.where((board) => board.hasItem).toList(),
        orElse: () => const [],
      );

  /// 컨테이너 전환 드롭다운이 열려 있는지.
  bool containerPickerOpen(WidgetRef ref) =>
      ref.watch(addContainerPickerOpenProvider);

  /// 검색어를 구독한다(빌드용).
  String searchQuery(WidgetRef ref) => ref.watch(addListSearchQueryProvider);

  /// 검색어가 외부(단계 이동 등)에서 바뀐 것을 입력창에 반영하기 위해 구독한다.
  void listenSearchQuery(WidgetRef ref, void Function(String next) onChanged) =>
      ref.listen(addListSearchQueryProvider, (_, next) => onChanged(next));

  /// 검색어를 1회 읽는다(initState 등 non-build 컨텍스트용).
  String readSearchQuery(WidgetRef ref) => ref.read(addListSearchQueryProvider);

  /// 지금 게시판 목록을 보고 있는 사이트.
  SiteType currentSite(WidgetRef ref) => ref.watch(currentSiteTypeProvider);

  /// 이미 담아둔 게시판 키(사이트+게시판) 집합.
  Set<String> addedBoardKeys(WidgetRef ref) =>
      ref.watch(favoriteBoardKeysProvider);
}
