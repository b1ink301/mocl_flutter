import 'package:floor/floor.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

@dao
abstract class MainDao {
  @Query('SELECT * FROM main ORDER BY orderBy ASC')
  Future<List<MainItemData>> findAll();

  @Query('SELECT * FROM main WHERE siteType = :siteType ORDER BY orderBy ASC')
  Future<List<MainItemData>> findBySiteType(SiteType siteType);

  @Query('SELECT * FROM main WHERE board = :board')
  Future<MainItemData?> findByBoard(String board);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertItem(MainItemData entity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<MainItemData> list);

  @Query("DELETE FROM main")
  Future<void> deleteAll();

  @Query("DELETE FROM main WHERE siteType = :siteType")
  Future<void> deleteAllBySiteType(SiteType siteType);
}
