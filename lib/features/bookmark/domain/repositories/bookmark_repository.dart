import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';

abstract class BookmarkRepository() {
  Future<void> add(PostSnapshot data);
  Future<void> remove(SiteType siteType, int id);
  Future<bool> isBookmarked(SiteType siteType, int id);
  Future<List<PostSnapshot>> getAll();
}
