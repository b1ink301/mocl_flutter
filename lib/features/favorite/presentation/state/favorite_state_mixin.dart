import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

mixin class FavoriteState() {
  /// 지금 보고 있는 사이트의 담은 게시판. 홈 목록이 이걸 그린다.
  AsyncValue<List<FavoriteData>> siteFavoritesState(WidgetRef ref) =>
      ref.watch(siteFavoritesProvider);

  /// 사이트별 담은 개수(드로어 칩 · 빠른 이동 레일).
  Map<SiteType, int> favoriteCountBySiteState(WidgetRef ref) =>
      ref.watch(favoriteCountBySiteProvider);

  /// 그룹 순서대로 묶인 즐겨찾기 게시판 섹션. 메인 화면이 이걸 그린다.
  AsyncValue<List<FavoriteSection>> favoriteSectionsState(WidgetRef ref) =>
      ref.watch(favoriteSectionsProvider);

  /// 그룹 목록만 필요할 때(그룹 이동 다이얼로그 등).
  AsyncValue<List<FavoriteGroup>> favoriteGroupsState(WidgetRef ref) =>
      ref.watch(favoriteGroupsProvider);

  /// 그룹 목록을 1회 읽는다(다이얼로그 오픈 등 non-build 컨텍스트용).
  List<FavoriteGroup> readFavoriteGroups(WidgetRef ref) =>
      ref.read(favoriteGroupsProvider).asData?.value ?? const [];
}
