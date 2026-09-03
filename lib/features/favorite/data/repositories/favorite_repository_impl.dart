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

  /// 그룹은 게시판을 담을 때 사이트별로 만들어지므로, 미리 시드하지 않는다.
  @override
  Future<List<FavoriteGroup>> getGroups() => localDatabase.getFavoriteGroups();

  @override
  Future<void> saveGroups(List<FavoriteGroup> groups) =>
      localDatabase.saveFavoriteGroups(groups);
}
