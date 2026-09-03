import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

mixin class FavoriteEvent() {
  /// 게시판을 담거나 뺀다(게시판 추가 화면의 칩 탭). 즉시 저장된다.
  Future<void> toggleBoard(WidgetRef ref, MainItem item) =>
      ref.read(favoritesProvider.notifier).toggleBoard(item);

  void removeFavorite(WidgetRef ref, SiteType siteType, String board) =>
      ref.read(favoritesProvider.notifier).remove(siteType, board);

  void moveFavoriteToGroup(
    WidgetRef ref,
    FavoriteData favorite,
    String groupId,
  ) => ref.read(favoritesProvider.notifier).moveToGroup(favorite, groupId);

  void reorderFavoriteInGroup(
    WidgetRef ref,
    String groupId,
    List<FavoriteData> groupItems,
    int oldIndex,
    int newIndex,
  ) => ref
      .read(favoritesProvider.notifier)
      .reorderInGroup(groupId, groupItems, oldIndex, newIndex);

  void addFavoriteGroup(WidgetRef ref, String name) =>
      ref.read(favoriteGroupsProvider.notifier).addGroup(name);

  void renameFavoriteGroup(WidgetRef ref, String id, String name) =>
      ref.read(favoriteGroupsProvider.notifier).rename(id, name);

  void removeFavoriteGroup(WidgetRef ref, String id) =>
      ref.read(favoriteGroupsProvider.notifier).removeGroup(id);

  /// 그룹 접기/펼치기 토글.
  void toggleGroupCollapsed(WidgetRef ref, String id) =>
      ref.read(favoriteGroupsProvider.notifier).toggleCollapsed(id);

  void reorderFavoriteGroups(WidgetRef ref, int oldIndex, int newIndex) =>
      ref.read(favoriteGroupsProvider.notifier).reorder(oldIndex, newIndex);

  /// 당겨서 새로고침. DB 기반이라 네트워크 호출 없이 다시 읽기만 한다.
  void refreshFavorites(WidgetRef ref) {
    ref.invalidate(favoriteGroupsProvider);
    ref.invalidate(favoritesProvider);
  }
}
