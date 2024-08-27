import 'dart:async';

import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/read_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../db/app_database.dart';

class LocalDatabase {
  final AppDatabase _database;

  LocalDatabase({required AppDatabase database}) : _database = database;

  Future<List<MainItemData>> getMainItems(
    SiteType siteType,
  ) =>
      _database.mainDao.findBySiteType(siteType);

  Future<List<int>> setMainItems(
    SiteType siteType,
    List<MainItemData> entities,
  ) =>
      _database.mainDao.insertList(entities);

  Future<void> deleteAll(
    SiteType siteType,
  ) =>
      _database.mainDao.deleteAll();

  Future<bool> hasItem(
    SiteType siteType,
    MainItemData entity,
  ) =>
      _database.mainDao.findByBoard(entity.board).then((data) => data != null);

  Future<bool> isRead(
    SiteType siteType,
    int id,
  ) =>
      _database.isReadDao.findById(id).then((data) => data != null);

  Future<int> setRead(
    SiteType siteType,
    int id,
  ) {
    final entity = ReadItemData(siteType: siteType, id: id);
    return _database.isReadDao.insert(entity);
  }
}
