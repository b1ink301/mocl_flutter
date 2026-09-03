import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/domain/repositories/favorite_repository.dart';

class const FavoriteRepositoryImpl(final LocalDatabase localDatabase)
    implements FavoriteRepository {
  @override
  Future<void> add(FavoriteData data) => localDatabase.setFavorite(data);

  @override
  Future<void> addAll(List<FavoriteData> items) =>
      localDatabase.setFavorites(items);

  @override
  Future<void> remove(SiteType siteType, String board) =>
      localDatabase.removeFavorite(siteType, board);

  @override
  Future<bool> isFavorite(SiteType siteType, String board) =>
      localDatabase.isFavorite(siteType, board);

  @override
  Future<List<FavoriteData>> getAll() => localDatabase.getFavorites();

  @override
  Future<void> updateAll(List<FavoriteData> items) =>
      localDatabase.updateFavorites(items);

  /// 최초 실행(또는 그룹을 모두 지운 상태)에는 기본 그룹을 만들어 저장한 뒤
  /// 돌려준다. 그래야 게시판을 추가하자마자 정리된 상태로 보인다.
  @override
  Future<List<FavoriteGroup>> getGroups() async {
    final List<FavoriteGroup> stored = await localDatabase.getFavoriteGroups();
    if (stored.isNotEmpty) {
      return stored;
    }
    final List<FavoriteGroup> defaults = defaultFavoriteGroups();
    await localDatabase.saveFavoriteGroups(defaults);
    return defaults;
  }

  @override
  Future<void> saveGroups(List<FavoriteGroup> groups) =>
      localDatabase.saveFavoriteGroups(groups);
}
