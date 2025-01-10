import 'package:mocl_flutter/features/mocl/data/db/entities/read_item_data.dart';

// @dao
abstract class IsReadDao {
  // @Query('SELECT * FROM is_read')
  Future<List<ReadItemData>> findAll();

  // @Query('SELECT * FROM is_read WHERE id = :id')
  Future<ReadItemData?> findById(int id);

  // @Query('SELECT * FROM is_read WHERE id IN (:ids)')
  Future<List<ReadItemData>> findByIds(List<int> ids);

  // @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insert(ReadItemData entity);
}