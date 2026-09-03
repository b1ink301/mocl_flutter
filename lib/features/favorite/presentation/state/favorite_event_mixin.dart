import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

mixin class FavoriteEvent() {
  /// 선택한 게시판들을 지정 그룹에 추가한다(게시판 선택 화면의 '적용').
  Future<void> addBoards(
    WidgetRef ref,
    List<MainItem> items,
    String groupId,
  ) => ref.read(favoritesProvider.notifier).addBoards(items, groupId);

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

  void reorderFavoriteGroups(WidgetRef ref, int oldIndex, int newIndex) =>
      ref.read(favoriteGroupsProvider.notifier).reorder(oldIndex, newIndex);

  /// 당겨서 새로고침. DB 기반이라 네트워크 호출 없이 다시 읽기만 한다.
  void refreshFavorites(WidgetRef ref) {
    ref.invalidate(favoriteGroupsProvider);
    ref.invalidate(favoritesProvider);
  }
}
