import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';

abstract class FavoriteRepository() {
  Future<void> add(FavoriteData data);
  Future<void> remove(SiteType siteType, String board);
  Future<bool> isFavorite(SiteType siteType, String board);
  Future<List<FavoriteData>> getAll();
}
