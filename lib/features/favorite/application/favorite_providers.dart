import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:mocl_flutter/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_providers.g.dart';

/// 같은 게시판인지 판별하는 키(사이트+게시판 조합으로 유일).
String _keyOf(SiteType siteType, String board) => '${siteType.name}_$board';

@Riverpod(keepAlive: true)
FavoriteRepository favoriteRepository(Ref ref) =>
    FavoriteRepositoryImpl(ref.watch(localDatabaseProvider));

/// 즐겨찾기 그룹(카테고리) 목록. 최초에는 사이트 카테고리 기반 기본 그룹이 시드된다.
@riverpod
class FavoriteGroupsNotifier() extends _$FavoriteGroupsNotifier {
  @override
  Future<List<FavoriteGroup>> build() =>
      ref.watch(favoriteRepositoryProvider).getGroups();

  Future<void> addGroup(String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final repo = ref.read(favoriteRepositoryProvider);
    final List<FavoriteGroup> groups = await repo.getGroups();
    // 사용자가 만든 그룹은 시각(ms)으로 유일한 ID 를 부여한다.
    final String id = 'g${DateTime.now().millisecondsSinceEpoch}';
    await repo.saveGroups([
      ...groups,
      FavoriteGroup(id: id, name: trimmed, orderBy: groups.length),
    ]);
    ref.invalidateSelf();
  }

  Future<void> rename(String id, String name) async {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final repo = ref.read(favoriteRepositoryProvider);
    final List<FavoriteGroup> groups = await repo.getGroups();
    await repo.saveGroups([
      for (final FavoriteGroup group in groups)
        group.id == id ? group.copyWith(name: trimmed) : group,
    ]);
    ref.invalidateSelf();
  }

  /// 그룹을 지운다. 마지막 그룹은 남겨두고(갈 곳이 없어짐), 소속 게시판은
  /// 사라지지 않도록 첫 번째 남은 그룹으로 옮긴다.
  Future<void> removeGroup(String id) async {
    final repo = ref.read(favoriteRepositoryProvider);
    final List<FavoriteGroup> groups = await repo.getGroups();
    if (groups.length <= 1) return;

    final List<FavoriteGroup> remain = groups
        .where((group) => group.id != id)
        .toList();
    final String fallbackId = remain.first.id;

    final List<FavoriteData> favorites = await repo.getAll();
    final List<FavoriteData> orphans = favorites
        .where((favorite) => favorite.group == id)
        .toList();
    if (orphans.isNotEmpty) {
      int order = _nextOrderIn(favorites, fallbackId);
      await repo.updateAll([
        for (final FavoriteData favorite in orphans)
          favorite.copyWith(group: fallbackId, orderBy: order++),
      ]);
    }

    await repo.saveGroups([
      for (int i = 0; i < remain.length; i++) remain[i].copyWith(orderBy: i),
    ]);
    ref.invalidateSelf();
    ref.invalidate(favoritesProvider);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final List<FavoriteGroup>? current = state.asData?.value;
    if (current == null || oldIndex == newIndex) return;

    final List<FavoriteGroup> list = List<FavoriteGroup>.of(current);
    final FavoriteGroup moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    final List<FavoriteGroup> reordered = [
      for (int i = 0; i < list.length; i++) list[i].copyWith(orderBy: i),
    ];
    state = AsyncData(reordered);
    await ref.read(favoriteRepositoryProvider).saveGroups(reordered);
    ref.invalidateSelf();
  }
}

/// 즐겨찾기한 게시판 전체. 메인 화면의 유일한 데이터 소스다.
@riverpod
class FavoritesNotifier() extends _$FavoritesNotifier {
  @override
  Future<List<FavoriteData>> build() =>
      ref.watch(favoriteRepositoryProvider).getAll();

  /// 선택한 게시판들을 지정 그룹의 맨 뒤에 추가한다(이미 있는 항목은 건너뜀).
  Future<void> addBoards(List<MainItem> items, String groupId) async {
    if (items.isEmpty) return;

    final repo = ref.read(favoriteRepositoryProvider);
    final List<FavoriteData> current = await repo.getAll();
    final Set<String> existing = current
        .map((favorite) => _keyOf(favorite.siteType, favorite.board))
        .toSet();

    int order = _nextOrderIn(current, groupId);
    final int now = DateTime.now().millisecondsSinceEpoch;
    final List<FavoriteData> toAdd = [
      for (final MainItem item in items)
        if (existing.add(_keyOf(item.siteType, item.board)))
          FavoriteData.fromMainItem(
            item,
            now,
            group: groupId,
            orderBy: order++,
          ),
    ];

    await repo.addAll(toAdd);
    ref.invalidateSelf();
  }

  Future<void> remove(SiteType siteType, String board) async {
    await ref.read(favoriteRepositoryProvider).remove(siteType, board);
    ref.invalidateSelf();
  }

  /// 게시판을 다른 그룹으로 옮긴다(대상 그룹의 맨 뒤로).
  Future<void> moveToGroup(FavoriteData favorite, String groupId) async {
    if (favorite.group == groupId) return;

    final repo = ref.read(favoriteRepositoryProvider);
    final List<FavoriteData> current = await repo.getAll();
    await repo.updateAll([
      favorite.copyWith(
        group: groupId,
        orderBy: _nextOrderIn(current, groupId),
      ),
    ]);
    ref.invalidateSelf();
  }

  /// 그룹 안에서 순서를 바꾼다. 낙관적으로 화면을 먼저 갱신한 뒤
  /// orderBy 를 0..n 으로 재부여해 저장한다(저장 순서가 곧 표시 순서).
  Future<void> reorderInGroup(
    String groupId,
    List<FavoriteData> groupItems,
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex == newIndex) return;

    // onReorderItem 콜백은 제거 후 인덱스를 이미 보정해 넘겨준다(별도 -1 불필요).
    final List<FavoriteData> list = List<FavoriteData>.of(groupItems);
    final FavoriteData moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    final List<FavoriteData> reordered = [
      for (int i = 0; i < list.length; i++) list[i].copyWith(orderBy: i),
    ];

    final List<FavoriteData>? current = state.asData?.value;
    if (current != null) {
      final Map<String, FavoriteData> updated = {
        for (final FavoriteData favorite in reordered)
          _keyOf(favorite.siteType, favorite.board): favorite,
      };
      state = AsyncData([
        for (final FavoriteData favorite in current)
          updated[_keyOf(favorite.siteType, favorite.board)] ?? favorite,
      ]);
    }

    await ref.read(favoriteRepositoryProvider).updateAll(reordered);
    ref.invalidateSelf();
  }
}

/// 그룹 순서대로 묶은 메인 화면용 섹션 목록.
/// 그룹이 삭제되는 등으로 소속을 잃은 항목은 사이트 기본 카테고리로,
/// 그마저 없으면 첫 그룹으로 보내 화면에서 사라지지 않게 한다.
@riverpod
Future<List<FavoriteSection>> favoriteSections(Ref ref) async {
  final List<FavoriteGroup> groups = await ref.watch(
    favoriteGroupsProvider.future,
  );
  if (groups.isEmpty) return const [];

  final List<FavoriteData> favorites = await ref.watch(favoritesProvider.future);
  final Set<String> groupIds = {for (final FavoriteGroup g in groups) g.id};
  final Map<String, List<FavoriteData>> byGroup = {
    for (final FavoriteGroup group in groups) group.id: <FavoriteData>[],
  };

  for (final FavoriteData favorite in favorites) {
    String id = favorite.group;
    if (!groupIds.contains(id)) {
      final String fallback = defaultCategoryIdOf(favorite.siteType);
      id = groupIds.contains(fallback) ? fallback : groups.first.id;
    }
    byGroup[id]!.add(favorite);
  }

  return [
    for (final FavoriteGroup group in groups)
      (group: group, items: byGroup[group.id]!),
  ];
}

/// 그룹 안에서 다음에 쓸 orderBy(맨 뒤에 붙이기 위한 값).
int _nextOrderIn(List<FavoriteData> favorites, String groupId) {
  int max = -1;
  for (final FavoriteData favorite in favorites) {
    if (favorite.group == groupId && favorite.orderBy > max) {
      max = favorite.orderBy;
    }
  }
  return max + 1;
}
