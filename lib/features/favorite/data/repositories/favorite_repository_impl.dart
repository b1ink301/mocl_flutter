import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/domain/repositories/favorite_repository.dart';

class const FavoriteRepositoryImpl(final LocalDatabase localDatabase)
    implements FavoriteRepository {
  @override
  Future<void> add(FavoriteData data) => localDatabase.setFavorite(data);

  @override
  Future<void> remove(SiteType siteType, String board) =>
      localDatabase.removeFavorite(siteType, board);

  @override
  Future<bool> isFavorite(SiteType siteType, String board) =>
      localDatabase.isFavorite(siteType, board);

  @override
  Future<List<FavoriteData>> getAll() => localDatabase.getFavorites();
}
