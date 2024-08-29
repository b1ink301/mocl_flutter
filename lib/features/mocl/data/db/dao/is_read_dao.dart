import 'package:floor/floor.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/read_item_data.dart';

@dao
abstract class IsReadDao {
  @Query('SELECT * FROM is_read')
  Future<List<ReadItemData>> findAll();

  @Query('SELECT * FROM is_read WHERE id = :id')
  Future<ReadItemData?> findById(int id);

  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<int> insert(ReadItemData entity);
}