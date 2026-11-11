import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  late String path;
  int seq = 0;

  setUp(() => path = 'history_test_${seq++}.db');
  tearDown(() => databaseFactoryMemory.deleteDatabase(path));

  Future<LocalDatabase> open() async => LocalDatabase(
    database: await openVersionedDatabase(databaseFactoryMemory, path),
    opener: () => openVersionedDatabase(databaseFactoryMemory, path),
  );

  final DateTime base = DateTime(2026, 11, 11, 12);

  PostSnapshot post(
    int id, {
    SiteType siteType = SiteType.clien,
    DateTime? at,
    String title = '제목',
  }) => PostSnapshot.fromListItem(
    siteType,
    ListItem.empty().copyWith(id: id, title: title, board: 'park'),
    (at ?? base).millisecondsSinceEpoch,
  );

  List<String> keysOf(List<PostSnapshot> items) => [
    for (final PostSnapshot p in items) p.key,
  ];

  group('최근 본 글', () {
    test('최근 본 순으로 돌려주고, 사이트가 다르면 같은 id 도 따로 남긴다', () async {
      final LocalDatabase local = await open();
      await local.putHistory(post(1, at: base));
      await local.putHistory(post(2, at: base.add(const Duration(hours: 1))));
      await local.putHistory(
        post(
          1,
          siteType: SiteType.damoang,
          at: base.add(const Duration(hours: 2)),
        ),
      );

      expect(keysOf(await local.getHistory()), [
        'damoang:1',
        'clien:2',
        'clien:1',
      ]);
      await local.dispose();
    });

    test('다시 보면 레코드는 하나로 남고 맨 앞으로 올라간다', () async {
      final LocalDatabase local = await open();
      await local.putHistory(post(1, at: base));
      await local.putHistory(post(2, at: base.add(const Duration(minutes: 5))));
      await local.putHistory(
        post(1, at: base.add(const Duration(minutes: 10))),
      );

      final List<PostSnapshot> items = await local.getHistory();
      expect(keysOf(items), ['clien:1', 'clien:2']);
      expect(
        items.first.savedAt,
        base.add(const Duration(minutes: 10)).millisecondsSinceEpoch,
      );
      await local.dispose();
    });

    test('1분 안에 같은 내용으로 다시 열면 쓰지 않는다', () async {
      final LocalDatabase local = await open();
      expect(await local.putHistory(post(1, at: base)), isTrue);
      expect(
        await local.putHistory(
          post(1, at: base.add(const Duration(seconds: 30))),
        ),
        isFalse,
      );
      // 내용이 바뀌었으면(제목 수정 등) 1분 안이라도 쓴다.
      expect(
        await local.putHistory(
          post(1, at: base.add(const Duration(seconds: 40)), title: '고친 제목'),
        ),
        isTrue,
      );
      expect(
        await local.putHistory(
          post(1, at: base.add(const Duration(minutes: 3))),
        ),
        isTrue,
      );
      await local.dispose();
    });

    test('지우기 · 모두 지우기', () async {
      final LocalDatabase local = await open();
      await local.putHistory(post(1));
      await local.putHistory(post(2));
      await local.removeHistory(SiteType.clien, 1);
      expect(keysOf(await local.getHistory()), ['clien:2']);

      await local.clearHistory();
      expect(await local.getHistory(), isEmpty);
      await local.dispose();
    });

    test('정리: 기한이 지났거나 최근 N개 밖의 글을 지운다', () async {
      final LocalDatabase local = await open();
      final DateTime now = base.add(const Duration(days: 40));
      await local.putHistory(post(1, at: base)); // 40일 전 → 기한 지남
      for (int i = 0; i < 5; i++) {
        await local.putHistory(
          post(10 + i, at: now.subtract(Duration(hours: 5 - i))),
        );
      }

      final int removed = await local.pruneReadsIfDue(
        ttl: const Duration(days: 180),
        replyTtl: const Duration(days: 14),
        historyTtl: const Duration(days: 30),
        maxHistory: 3,
        now: now,
      );

      expect(removed, 3);
      expect(keysOf(await local.getHistory()), [
        'clien:14',
        'clien:13',
        'clien:12',
      ]);
      await local.dispose();
    });
  });

  group('PostSnapshot.fromDetails', () {
    final Details details = Details.empty().copyWith(
      title: '상세 제목',
      time: '12:34',
      userInfo: const UserInfo(id: 'u', nickName: '닉', nickImage: ''),
    );

    test('목록 항목이 비어 있으면(링크 · 알림으로 연 글) 상세 값으로 채운다', () {
      final PostSnapshot p = PostSnapshot.fromDetails(
        SiteType.clien,
        ListItem.empty().copyWith(id: 7),
        details,
        0,
      );
      expect(p.title, '상세 제목');
      expect(p.time, '12:34');
      expect(p.nickName, '닉');
    });

    test('목록 값이 있으면 그대로 둔다', () {
      final PostSnapshot p = PostSnapshot.fromDetails(
        SiteType.clien,
        ListItem.empty().copyWith(
          id: 7,
          title: '목록 제목',
          time: '어제',
          userInfo: const UserInfo(id: 'a', nickName: '목록 닉', nickImage: ''),
        ),
        details,
        0,
      );
      expect(p.title, '목록 제목');
      expect(p.time, '어제');
      expect(p.nickName, '목록 닉');
    });

    test('JSON 왕복 — 옛 스크랩(bookmarks) 레코드 형식과 같다', () {
      final PostSnapshot p = post(3);
      expect(PostSnapshot.fromJson(p.toJson()), p);
      expect(
        p.toJson().keys,
        containsAll(<String>['siteType', 'id', 'savedAt']),
      );
    });
  });
}
