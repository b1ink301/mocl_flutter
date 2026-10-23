import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/database_migrations.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  late String path;
  int seq = 0;

  setUp(() => path = 'read_test_${seq++}.db');
  tearDown(() => databaseFactoryMemory.deleteDatabase(path));

  Future<LocalDatabase> open() async => LocalDatabase(
    database: await openVersionedDatabase(databaseFactoryMemory, path),
    opener: () => openVersionedDatabase(databaseFactoryMemory, path),
  );

  /// v1 앱이 남긴 DB 를 흉내 낸다: `자동 증가 키 → 글 id`.
  Future<void> seedV1(SiteType siteType, List<Object?> values) async {
    final Database db = await databaseFactoryMemory.openDatabase(
      path,
      version: 1,
    );
    final store = StoreRef<int, Object?>(readStoreOf(siteType).name);
    for (final Object? value in values) {
      await store.add(db, value);
    }
    await db.close();
  }

  Future<Map<int, int>> rawReads(SiteType siteType) async {
    final Database db = await openVersionedDatabase(
      databaseFactoryMemory,
      path,
    );
    final records = await readStoreOf(siteType).find(db);
    await db.close();
    return {for (final r in records) r.key: r.value};
  }

  group('읽음 기록 (v2)', () {
    test('같은 글을 여러 번 읽어도 레코드는 하나다', () async {
      final LocalDatabase local = await open();
      await local.setRead(SiteType.clien, 42);
      await local.setRead(SiteType.clien, 42);
      await local.setRead(SiteType.clien, 42);
      await local.dispose();

      expect((await rawReads(SiteType.clien)).keys, [42]);
    });

    test('isRead / isReads 는 읽은 글만, 요청 순서대로 돌려준다', () async {
      final LocalDatabase local = await open();
      await local.setRead(SiteType.clien, 3);
      await local.setRead(SiteType.clien, 1);

      expect(await local.isRead(SiteType.clien, 1), isTrue);
      expect(await local.isRead(SiteType.clien, 2), isFalse);
      expect(await local.isReads(SiteType.clien, [1, 2, 3, 4]), [1, 3]);
      expect(await local.isReads(SiteType.clien, []), isEmpty);
      await local.dispose();
    });

    test('사이트끼리 섞이지 않는다', () async {
      final LocalDatabase local = await open();
      await local.setRead(SiteType.clien, 7);
      expect(await local.isRead(SiteType.damoang, 7), isFalse);
      await local.dispose();
    });
  });

  group('v1 → v2 마이그레이션', () {
    test('글 id 가 아직 옮기지 않은 기록의 키와 겹쳐도 잃지 않는다', () async {
      // 키 1..5 에 [100, 5, 100, 12345, 2]. 글 2·5 는 자동 증가 키 2·5 와 겹친다.
      await seedV1(SiteType.clien, [100, 5, 100, 12345, 2]);

      final LocalDatabase local = await open();
      expect(await local.isReads(SiteType.clien, [2, 5, 100, 12345, 1, 3, 4]), [
        2,
        5,
        100,
        12345,
      ]);
      await local.dispose();

      final Map<int, int> raw = await rawReads(SiteType.clien);
      expect(raw.keys.toSet(), {2, 5, 100, 12345}, reason: '중복이 합쳐져야 한다');
      expect(raw.values.toSet(), hasLength(1), reason: '모두 같은 이관 시각');
    });

    test('정수가 아닌 값은 건너뛰고 열기는 성공한다', () async {
      await seedV1(SiteType.clien, [
        10,
        'oops',
        3.5,
        {'id': 7},
        20,
      ]);

      final LocalDatabase local = await open();
      expect(await local.isReads(SiteType.clien, [10, 20]), [10, 20]);
      await local.dispose();
      expect((await rawReads(SiteType.clien)).keys.toSet(), {10, 20});
    });

    test('이미 v2 인 DB 는 다시 옮기지 않는다 (복원 후 reopen 포함)', () async {
      final LocalDatabase first = await open();
      await first.setRead(SiteType.clien, 1);
      await first.dispose();
      final int before = (await rawReads(SiteType.clien))[1]!;

      final LocalDatabase local = await open();
      await local.close();
      await local.reopen();
      expect(await local.isRead(SiteType.clien, 1), isTrue);
      await local.dispose();

      expect((await rawReads(SiteType.clien))[1], before);
    });

    test('복원으로 v1 파일이 돌아오면 reopen 시 옮겨진다', () async {
      final LocalDatabase local = await open();
      await local.close();

      // Drive 복원: 닫힌 사이 옛 버전 파일로 바뀐다.
      await databaseFactoryMemory.deleteDatabase(path);
      await seedV1(SiteType.ppomppu, [555]);

      await local.reopen();
      expect(await local.isRead(SiteType.ppomppu, 555), isTrue);
      await local.dispose();
    });
  });

  group('읽음 기록 정리', () {
    const Duration ttl = Duration(days: 180);
    final DateTime now = DateTime(2026, 10, 22);

    test('TTL 이 지난 기록만 지우고, 하루 안에는 다시 돌지 않는다', () async {
      final Database db = await openVersionedDatabase(
        databaseFactoryMemory,
        path,
      );
      final LocalDatabase local = LocalDatabase(
        database: db,
        opener: () => openVersionedDatabase(databaseFactoryMemory, path),
      );
      Future<void> readAt(int id, Duration ago) =>
          readStoreOf(SiteType.clien)
              .record(id)
              .put(db, now.subtract(ago).millisecondsSinceEpoch);

      await readAt(1, const Duration(days: 181));
      await readAt(2, const Duration(days: 179));

      expect(await local.pruneReadsIfDue(ttl: ttl, now: now), 1);
      expect(await local.isReads(SiteType.clien, [1, 2]), [2]);

      // 하루가 지나지 않았으면 만료 기록이 있어도 건너뛴다.
      await readAt(3, const Duration(days: 365));
      final DateTime soon = now.add(const Duration(hours: 23));
      expect(await local.pruneReadsIfDue(ttl: ttl, now: soon), 0);
      expect(await local.isRead(SiteType.clien, 3), isTrue);

      final DateTime tomorrow = now.add(const Duration(days: 1));
      expect(await local.pruneReadsIfDue(ttl: ttl, now: tomorrow), 1);
      expect(await local.isRead(SiteType.clien, 3), isFalse);
      await local.dispose();
    });
  });
}
