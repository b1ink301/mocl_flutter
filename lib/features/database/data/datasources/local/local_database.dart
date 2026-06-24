import 'dart:async';

import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';
import 'package:sembast/sembast.dart';

class LocalDatabase {
  Database _db;
  final Future<Database> Function() _opener;

  LocalDatabase({
    required Database database,
    required Future<Database> Function() opener,
  }) : _db = database,
       // ignore: prefer_initializing_formals
       _opener = opener;

  /// 현재 메모리에 적재된 DB 연결을 닫는다.
  /// Drive 복원 시 파일 교체(rename) 전에 호출해 파일 핸들 충돌을 막는다.
  Future<void> close() async => await _db.close();

  /// 교체된 DB 파일을 다시 연다. Sembast 는 open 시점에 파일 전체를
  /// 메모리로 읽어오므로, 파일을 덮어쓴 뒤 close→reopen 해야 새 데이터가 반영된다.
  Future<void> reopen() async => _db = await _opener();

  Future<List<MainItemData>> getMainData(SiteType siteType) async {
    final StoreRef<int, Map<String, Object?>> store = intMapStoreFactory.store(
      siteType.name,
    );
    final List<RecordSnapshot<int, Map<String, Object?>>> recordSnapshot =
        await store.find(_db);
    return recordSnapshot
        .map((snapshot) => MainItemData.fromJson(snapshot.value))
        .toList();
  }

  Future<List<int>> setMainData(
    SiteType siteType,
    List<MainItemData> entities,
  ) async {
    final StoreRef<int, Map<String, Object?>> store = intMapStoreFactory.store(
      siteType.name,
    );

    return await _db.transaction((txn) async {
      final Iterable<Future<int>> futures = entities.map(
        (entity) async => await store.add(txn, entity.toJson()),
      );
      return Future.wait(futures);
    });
  }

  Future<void> deleteAll(SiteType siteType) async {
    final StoreRef<int, Map<String, Object?>> store = intMapStoreFactory.store(
      siteType.name,
    );
    await store.delete(_db);
  }

  Future<bool> hasItem(SiteType siteType, MainItemData entity) async {
    final StoreRef<int, Map<String, Object?>> store = intMapStoreFactory.store(
      siteType.name,
    );
    final Filter filter = Filter.equals('board', entity.board);
    final Finder finder = Finder(filter: filter);
    final List<RecordSnapshot<int, Map<String, Object?>>> recordSnapshot =
        await store.find(_db, finder: finder);
    return recordSnapshot.isNotEmpty;
  }

  Future<bool> isRead(SiteType siteType, int id) async {
    final StoreRef<int, Map<String, Object?>> store = intMapStoreFactory.store(
      '${siteType.name}_read',
    );
    final Finder finder = Finder(filter: Filter.equals(Field.value, id));
    final List<RecordSnapshot<int, Map<String, Object?>>> recordSnapshot =
        await store.find(_db, finder: finder);
    return recordSnapshot.isNotEmpty;
  }

  FutureOr<List<int>> isReads(SiteType siteType, List<int> ids) async {
    final StoreRef<int, int> store = StoreRef<int, int>(
      '${siteType.name}_read',
    );
    final List<Filter> filters = ids
        .map((id) => Filter.equals(Field.value, id))
        .toList();
    final Finder finder = Finder(filter: Filter.or(filters));
    final List<RecordSnapshot<int, int>> recordSnapshot = await store.find(
      _db,
      finder: finder,
    );
    final List<int> result = recordSnapshot
        .map((snapshot) => snapshot.value)
        .toList();
    return result;
  }

  Future<int> setRead(SiteType siteType, int id) async {
    final StoreRef<int, int> store = StoreRef<int, int>(
      '${siteType.name}_read',
    );
    return store.add(_db, id);
  }

  Future<void> dispose() async => await _db.close();
}
