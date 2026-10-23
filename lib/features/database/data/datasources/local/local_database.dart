import 'dart:async';

import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:sembast/sembast.dart';

import 'database_migrations.dart';

class LocalDatabase({
  required Database database,
  required final Future<Database> Function() _opener,
}) {
  Database _db = database;

  /// 현재 메모리에 적재된 DB 연결을 닫는다.
  /// Drive 복원 시 파일 교체(rename) 전에 호출해 파일 핸들 충돌을 막는다.
  Future<void> close() async => await _db.close();

  /// 교체된 DB 파일을 다시 연다. Sembast 는 open 시점에 파일 전체를
  /// 메모리로 읽어오므로, 파일을 덮어쓴 뒤 close→reopen 해야 새 데이터가 반영된다.
  Future<void> reopen() async => _db = await _opener();

  // ===== 읽음 기록 — 사이트별 `{site}_read` 스토어 (키: 글 id, 값: 읽은 시각) =====

  /// 정리 주기를 기록하는 스토어. DB 파일 안에 두어 Drive 백업과 함께 움직인다.
  static final StoreRef<String, int> _metaStore = StoreRef<String, int>('meta');
  static const String _readsPrunedAtKey = 'readsPrunedAt';

  Future<bool> isRead(SiteType siteType, int id) =>
      readStoreOf(siteType).record(id).exists(_db);

  /// [ids] 중 읽은 글의 id 만 돌려준다. 키 조회라 스토어 크기와 무관하다.
  Future<List<int>> isReads(SiteType siteType, List<int> ids) async {
    final List<int?> readAts = await readStoreOf(siteType)
        .records(ids)
        .get(_db);
    return [
      for (int i = 0; i < ids.length; i++)
        if (readAts[i] != null) ids[i],
    ];
  }

  /// 읽음으로 표시한다. 같은 글을 다시 열면 읽은 시각만 갱신된다.
  Future<int> setRead(SiteType siteType, int id) async {
    await readStoreOf(siteType)
        .record(id)
        .put(_db, DateTime.now().millisecondsSinceEpoch);
    return id;
  }

  /// [ttl] 보다 오래전에 읽은 기록을 지우고 지운 개수를 돌려준다.
  ///
  /// 지난 정리 후 [interval] 이 지나지 않았으면 아무것도 하지 않는다.
  /// 스토어 전체를 훑으므로 앱 시작 직후가 아니라 첫 프레임 뒤에 부를 것.
  Future<int> pruneReadsIfDue({
    required Duration ttl,
    Duration interval = const Duration(days: 1),
    DateTime? now,
  }) async {
    final int nowMs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final int? prunedAt = await _metaStore.record(_readsPrunedAtKey).get(_db);
    if (prunedAt != null && nowMs - prunedAt < interval.inMilliseconds) {
      return 0;
    }

    final Finder expired = Finder(
      filter: Filter.lessThan(Field.value, nowMs - ttl.inMilliseconds),
    );
    final int removed = await _db.transaction((txn) async {
      int count = 0;
      for (final SiteType siteType in SiteType.values) {
        count += await readStoreOf(siteType).delete(txn, finder: expired);
      }
      await _metaStore.record(_readsPrunedAtKey).put(txn, nowMs);
      return count;
    });
    // sembast 는 변경을 파일 끝에 덧붙이므로, 지운 만큼 줄이려면 압축해야 한다.
    if (removed > 0) await _db.compact();
    return removed;
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

  // ===== 즐겨찾기(게시판) — 전역 `favorites` 스토어 =====

  StoreRef<int, Map<String, Object?>> get _favoriteStore =>
      intMapStoreFactory.store('favorites');

  Finder _favoriteFinder(SiteType siteType, String board) => Finder(
    filter: Filter.and([
      Filter.equals('siteType', siteType.name),
      Filter.equals('board', board),
    ]),
  );

  Future<void> setFavorite(FavoriteData data) async {
    final existing = await _favoriteStore.find(
      _db,
      finder: _favoriteFinder(data.siteType, data.board),
    );
    if (existing.isEmpty) {
      await _favoriteStore.add(_db, data.toJson());
    }
  }

  /// 여러 게시판을 한 트랜잭션으로 추가한다(이미 있는 항목은 건너뛴다).
  Future<void> setFavorites(List<FavoriteData> items) async {
    if (items.isEmpty) return;
    await _db.transaction((txn) async {
      for (final FavoriteData data in items) {
        final existing = await _favoriteStore.find(
          txn,
          finder: _favoriteFinder(data.siteType, data.board),
        );
        if (existing.isEmpty) {
          await _favoriteStore.add(txn, data.toJson());
        }
      }
    });
  }

  /// 기존 즐겨찾기 레코드를 통째로 갱신한다(그룹 이동 / 순서 변경용).
  Future<void> updateFavorites(List<FavoriteData> items) async {
    if (items.isEmpty) return;
    await _db.transaction((txn) async {
      for (final FavoriteData data in items) {
        await _favoriteStore.update(
          txn,
          data.toJson(),
          finder: _favoriteFinder(data.siteType, data.board),
        );
      }
    });
  }

  Future<void> removeFavorite(SiteType siteType, String board) async {
    await _favoriteStore.delete(_db, finder: _favoriteFinder(siteType, board));
  }

  Future<bool> isFavorite(SiteType siteType, String board) async {
    final found = await _favoriteStore.find(
      _db,
      finder: _favoriteFinder(siteType, board),
    );
    return found.isNotEmpty;
  }

  /// 그룹 안에서의 표시 순서(orderBy) 우선, 같은 순서면 먼저 추가한 것 우선.
  Future<List<FavoriteData>> getFavorites() async {
    final records = await _favoriteStore.find(
      _db,
      finder: Finder(
        sortOrders: [SortOrder('orderBy', true), SortOrder('savedAt', true)],
      ),
    );
    return records.map((r) => FavoriteData.fromJson(r.value)).toList();
  }

  // ===== 즐겨찾기 그룹 — 전역 `favorite_groups` 스토어 =====

  StoreRef<int, Map<String, Object?>> get _favoriteGroupStore =>
      intMapStoreFactory.store('favorite_groups');

  Future<List<FavoriteGroup>> getFavoriteGroups() async {
    final records = await _favoriteGroupStore.find(
      _db,
      finder: Finder(sortOrders: [SortOrder('orderBy', true)]),
    );
    return records.map((r) => FavoriteGroup.fromJson(r.value)).toList();
  }

  /// 그룹은 개수가 적어 통째로 교체한다(추가/이름변경/삭제/순서변경 공용).
  Future<void> saveFavoriteGroups(List<FavoriteGroup> groups) async {
    await _db.transaction((txn) async {
      await _favoriteGroupStore.delete(txn);
      for (final FavoriteGroup group in groups) {
        await _favoriteGroupStore.add(txn, group.toJson());
      }
    });
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
