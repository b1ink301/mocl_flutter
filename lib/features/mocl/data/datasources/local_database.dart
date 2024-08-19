import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/read_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../db/app_database.dart';

@singleton
class LocalDatabase {
  final AppDatabase database;
  final _initCompleter = Completer<void>();

  LocalDatabase({required this.database});

  // Future<void> waitForInit() async => await _initCompleter.future;

  // Future<void> init() async {
  //   database = await $FloorAppDatabase.databaseBuilder('mocl.db').build();
  //   _initCompleter.complete();
  // }

  Future<List<MainItemData>> getMainItems(
    SiteType siteType,
  ) async {
    // await waitForInit();
    return database.mainDao.findBySiteType(siteType);
  }

  Future<List<int>> setMainItems(
    SiteType siteType,
    List<MainItemData> entities,
  ) async {
    // await waitForInit();
    return database.mainDao.insertList(entities);
  }

  Future<void> deleteAll(
    SiteType siteType,
  ) async {
    // await waitForInit();
    return database.mainDao.deleteAll();
  }

  Future<bool> hasItem(
    SiteType siteType,
    MainItemData entity,
  ) async {
    // await waitForInit();
    return await database.mainDao.findByBoard(entity.board) != null;
  }

  Future<bool> isRead(
    SiteType siteType,
    int id,
  ) async {
    // await waitForInit();
    return await database.isReadDao.findById(id) != null;
  }

  Future<int> setRead(
    SiteType siteType,
    int id,
  ) async {
    // await waitForInit();
    final entity = ReadItemData(siteType: siteType, id: id);
    return database.isReadDao.insert(entity);
  }
}
