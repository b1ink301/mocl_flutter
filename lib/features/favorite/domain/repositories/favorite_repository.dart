import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';

abstract class FavoriteRepository() {
  Future<void> add(FavoriteData data);

  /// 여러 게시판을 한 번에 추가한다(게시판 선택 다이얼로그의 '적용').
  Future<void> addAll(List<FavoriteData> items);

  Future<void> remove(SiteType siteType, String board);

  Future<bool> isFavorite(SiteType siteType, String board);

  Future<List<FavoriteData>> getAll();

  /// 그룹 이동 / 순서 변경된 항목들을 저장한다.
  Future<void> updateAll(List<FavoriteData> items);

  /// 즐겨찾기 그룹 목록. 비어 있으면 기본 그룹을 시드한 뒤 돌려준다.
  Future<List<FavoriteGroup>> getGroups();

  Future<void> saveGroups(List<FavoriteGroup> groups);
}
