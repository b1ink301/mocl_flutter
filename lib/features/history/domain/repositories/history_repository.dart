import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';

/// 최근 본 글. 기기에만 남는다(Drive 백업에는 DB 파일째 들어간다).
abstract class HistoryRepository() {
  /// 본 글을 남긴다. 실제로 썼으면 true(방금 남긴 같은 글이면 false).
  Future<bool> add(PostSnapshot data);
  Future<void> remove(SiteType siteType, int id);
  Future<void> clear();

  /// 최근 본 순.
  Future<List<PostSnapshot>> getAll();
}
