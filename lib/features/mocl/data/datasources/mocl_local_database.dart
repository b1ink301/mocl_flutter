import 'dart:async';

import 'package:isar/isar.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_entity.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_read_item_entity.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabase {
  Isar? isar;

  final _initCompleter = Completer<void>();

  Future<void> waitForInit() async => await _initCompleter.future;

  Future<void> init() async {
    if (isar != null && isar?.isOpen == true) return;
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MainItemEntitySchema, ReadItemEntitySchema],
      directory: dir.path,
    );
    _initCompleter.complete();
  }

  Future<List<MainItemEntity>> getMainItems(
    SiteType siteType,
  ) async {
    await waitForInit();
    return await isar?.mainItemEntitys
            .filter()
            .siteTypeEqualTo(siteType)
            .sortByOrderBy()
            .findAll() ??
        List.empty();
  }

  Future<List<Id>> setMainItems(
    SiteType siteType,
    List<MainItemEntity> entities,
  ) async {
    await waitForInit();
    return await isar?.writeTxn(() async {
          await isar?.mainItemEntitys
              .filter()
              .siteTypeEqualTo(siteType)
              .deleteAll();
          return await isar?.mainItemEntitys.putAll(entities) ?? List.empty();
        }) ??
        List.empty();
  }

  Future<bool> close() async => await isar?.close() ?? true;

  Future<int> deleteAll(
    SiteType siteType,
  ) async {
    await waitForInit();
    return await isar?.writeTxn(() async =>
            await isar?.mainItemEntitys
                .filter()
                .siteTypeEqualTo(siteType)
                .deleteAll() ??
            -1) ??
        -1;
  }

  Future<bool> hasItem(
    SiteType siteType,
    MainItemEntity entity,
  ) async {
    await waitForInit();
    return await isar?.mainItemEntitys
            .filter()
            .siteTypeEqualTo(siteType)
            .boardEqualTo(entity.board)
            .urlEqualTo(entity.url)
            .isNotEmpty() ??
        false;
  }

  Future<bool> isRead(
    SiteType siteType,
    int id,
  ) async {
    await waitForInit();
    return await isar?.readItemEntitys
            .filter()
            .siteTypeEqualTo(siteType)
            .boardIdEqualTo(id)
            .isNotEmpty() ??
        false;
  }

  Future<int> setRead(
    SiteType siteType,
    int boardId,
  ) async {
    await waitForInit();
    var entity = ReadItemEntity()
      ..siteType = siteType
      ..boardId = boardId;

    return await isar?.writeTxn(
            () async => await isar?.readItemEntitys.put(entity) ?? -1) ??
        -1;
  }
}
