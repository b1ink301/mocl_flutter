import 'dart:async';

import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/read_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../db/app_database.dart';

class LocalDatabase {
  final Future<AppDatabase> database;

  LocalDatabase({required this.database});

  Future<List<MainItemData>> getMainItems(
    SiteType siteType,
  ) =>
      database.then((db) => db.mainDao.findBySiteType(siteType));

  Future<List<int>> setMainItems(
    SiteType siteType,
    List<MainItemData> entities,
  ) =>
      database.then((db) => db.mainDao.insertList(entities));

  Future<void> deleteAll(
    SiteType siteType,
  ) =>
      database.then((db) => db.mainDao.deleteAll());

  Future<bool> hasItem(
    SiteType siteType,
    MainItemData entity,
  ) =>
      database.then((db) =>
          db.mainDao.findByBoard(entity.board).then((data) => data != null));

  Future<bool> isRead(
    SiteType siteType,
    int id,
  ) =>
      database
          .then((db) => db.isReadDao.findById(id).then((data) => data != null));

  Future<int> setRead(
    SiteType siteType,
    int id,
  ) {
    final entity = ReadItemData(siteType: siteType, id: id);
    return database.then((db) => db.isReadDao.insert(entity));
  }
}
