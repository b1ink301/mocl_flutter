import 'dart:async';

import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
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

  // ===== 북마크(스크랩) — 전역 `bookmarks` 스토어 =====

  StoreRef<int, Map<String, Object?>> get _bookmarkStore =>
      intMapStoreFactory.store('bookmarks');

  Finder _bookmarkFinder(SiteType siteType, int id) => Finder(
    filter: Filter.and([
      Filter.equals('siteType', siteType.name),
      Filter.equals('id', id),
    ]),
  );

  Future<void> setBookmark(BookmarkData data) async {
    final existing = await _bookmarkStore.find(
      _db,
      finder: _bookmarkFinder(data.siteType, data.id),
    );
    if (existing.isEmpty) {
      await _bookmarkStore.add(_db, data.toJson());
    }
  }

  Future<void> removeBookmark(SiteType siteType, int id) async {
    await _bookmarkStore.delete(_db, finder: _bookmarkFinder(siteType, id));
  }

  Future<bool> isBookmarked(SiteType siteType, int id) async {
    final found = await _bookmarkStore.find(
      _db,
      finder: _bookmarkFinder(siteType, id),
    );
    return found.isNotEmpty;
  }

  Future<List<BookmarkData>> getBookmarks() async {
    final records = await _bookmarkStore.find(
      _db,
      finder: Finder(sortOrders: [SortOrder('savedAt', false)]),
    );
    return records.map((r) => BookmarkData.fromJson(r.value)).toList();
  }

  // ===== 뮤트(키워드/작성자 차단) — 전역 `mutes` 스토어 =====

  StoreRef<int, Map<String, Object?>> get _muteStore =>
      intMapStoreFactory.store('mutes');

  Finder _muteFinder(MuteRule rule) => Finder(
    filter: Filter.and([
      Filter.equals('pattern', rule.pattern),
      Filter.equals('type', rule.type.name),
    ]),
  );

  Future<void> addMute(MuteRule rule) async {
    final existing = await _muteStore.find(_db, finder: _muteFinder(rule));
    if (existing.isEmpty) {
      await _muteStore.add(_db, rule.toJson());
    }
  }

  Future<void> removeMute(MuteRule rule) async {
    await _muteStore.delete(_db, finder: _muteFinder(rule));
  }

  Future<List<MuteRule>> getMutes() async {
    final records = await _muteStore.find(
      _db,
      finder: Finder(sortOrders: [SortOrder('createdAt', false)]),
    );
    return records.map((r) => MuteRule.fromJson(r.value)).toList();
  }

  Future<void> dispose() async => await _db.close();
}
