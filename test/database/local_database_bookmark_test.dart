import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  late String path;
  int seq = 0;

  setUp(() => path = 'bookmark_test_${seq++}.db');
  tearDown(() => databaseFactoryMemory.deleteDatabase(path));

  Future<LocalDatabase> open() async => LocalDatabase(
    database: await openVersionedDatabase(databaseFactoryMemory, path),
    opener: () => openVersionedDatabase(databaseFactoryMemory, path),
  );

  PostSnapshot post(int id, {int savedAt = 1}) => PostSnapshot.fromListItem(
    SiteType.clien,
    ListItem.empty().copyWith(id: id, title: '글 $id', board: 'park'),
    savedAt,
  );

  BookmarkFolder folder(String id, int createdAt) =>
      BookmarkFolder(id: id, name: '폴더 $id', tone: 1, createdAt: createdAt);

  test('옛 JSON(폴더 · 메모 없음)도 기본값으로 읽힌다', () {
    final Map<String, dynamic> json = post(1).toJson()
      ..remove('folders')
      ..remove('memo');
    final PostSnapshot read = PostSnapshot.fromJson(json);
    expect(read.folders, isEmpty);
    expect(read.memo, '');
  });

  test('폴더 · 메모를 바꿔도 스크랩한 시각은 그대로', () async {
    final LocalDatabase local = await open();
    await local.setBookmark(post(1, savedAt: 42));
    await local.updateBookmarkMeta(
      SiteType.clien,
      1,
      folders: ['a'],
      memo: '메모',
    );
    final PostSnapshot b = (await local.getBookmarks()).single;
    expect(b.folders, ['a']);
    expect(b.memo, '메모');
    expect(b.savedAt, 42);
  });

  test('폴더는 만든 순, 지우면 스크랩에서만 빠지고 글은 남는다', () async {
    final LocalDatabase local = await open();
    await local.putBookmarkFolder(folder('b', 2));
    await local.putBookmarkFolder(folder('a', 1));
    expect(
      [for (final f in await local.getBookmarkFolders()) f.id],
      ['a', 'b'],
    );

    await local.setBookmark(post(1));
    await local.setBookmark(post(2));
    await local.updateBookmarkMeta(
      SiteType.clien,
      1,
      folders: ['a', 'b'],
      memo: '',
    );
    await local.updateBookmarkMeta(
      SiteType.clien,
      2,
      folders: ['a'],
      memo: '남김',
    );

    await local.deleteBookmarkFolder('a');

    expect([for (final f in await local.getBookmarkFolders()) f.id], ['b']);
    final Map<int, PostSnapshot> byId = {
      for (final b in await local.getBookmarks()) b.id: b,
    };
    expect(byId[1]!.folders, ['b']);
    expect(byId[2]!.folders, isEmpty);
    expect(byId[2]!.memo, '남김');
  });
}
