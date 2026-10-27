import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';

class const BookmarkRepositoryImpl(final LocalDatabase localDatabase)
    implements BookmarkRepository {
  @override
  Future<void> add(BookmarkData data) => localDatabase.setBookmark(data);

  @override
  Future<void> remove(SiteType siteType, int id) =>
      localDatabase.removeBookmark(siteType, id);

  @override
  Future<bool> isBookmarked(SiteType siteType, int id) =>
      localDatabase.isBookmarked(siteType, id);

  @override
  Future<List<BookmarkData>> getAll() => localDatabase.getBookmarks();
}
