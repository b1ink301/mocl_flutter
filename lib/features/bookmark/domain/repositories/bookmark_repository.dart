import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';

abstract class BookmarkRepository() {
  Future<void> add(BookmarkData data);
  Future<void> remove(SiteType siteType, int id);
  Future<bool> isBookmarked(SiteType siteType, int id);
  Future<List<BookmarkData>> getAll();
}
