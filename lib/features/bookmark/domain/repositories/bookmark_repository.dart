import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';

abstract class BookmarkRepository() {
  Future<void> add(PostSnapshot data);
  Future<void> remove(SiteType siteType, int id);
  Future<bool> isBookmarked(SiteType siteType, int id);
  Future<List<PostSnapshot>> getAll();
  Future<void> updateMeta(
    SiteType siteType,
    int id, {
    required List<String> folders,
    required String memo,
  });

  Future<List<BookmarkFolder>> getFolders();
  Future<void> putFolder(BookmarkFolder folder);
  Future<void> deleteFolder(String id);
}
