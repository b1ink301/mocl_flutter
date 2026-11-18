import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/mocl_user_info.dart';
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
  test('이미 있는 스크랩을 다시 넣으면 내용만 바뀌고 폴더 · 메모 · 시각은 남는다', () async {
    final LocalDatabase local = await open();
    await local.setBookmark(
      post(1, savedAt: 42).copyWith(title: '', nickName: '옛닉'),
    );
    await local.updateBookmarkMeta(
      SiteType.clien,
      1,
      folders: ['a'],
      memo: '메모',
    );
    await local.setBookmark(
      post(1, savedAt: 99).copyWith(title: '새 제목', nickName: '', reply: '5'),
    );
    final PostSnapshot b = (await local.getBookmarks()).single;
    expect(b.title, '새 제목');
    expect(b.reply, '5');
    expect(b.nickName, '옛닉', reason: '빈 새 값으로 저장된 값을 지우지 않는다');
    expect(b.folders, ['a']);
    expect(b.memo, '메모');
    expect(b.savedAt, 42);
  });

  test('게시판 이름이 비면 즐겨찾기한 같은 게시판 이름으로 채운다', () async {
    final LocalDatabase local = await open();
    await local.setFavorite(
      const FavoriteData(
        siteType: SiteType.clien,
        board: 'park',
        text: '모두의공원',
        url: '',
        type: 0,
        icon: '',
        savedAt: 1,
      ),
    );
    await local.setBookmark(post(1));
    await local.setBookmark(post(2).copyWith(board: 'other'));
    final Map<int, PostSnapshot> byId = {
      for (final b in await local.getBookmarks()) b.id: b,
    };
    expect(byId[1]!.boardTitle, '모두의공원');
    expect(byId[2]!.boardTitle, '');
  });

  group('PostSnapshot.forBookmark', () {
    Details details({String title = '상세 제목', String nick = '상세닉'}) =>
        Details.empty().copyWith(
          title: title,
          time: '2026-11-18',
          userInfo: UserInfo(id: 'u', nickName: nick, nickImage: ''),
        );

    test('링크로 연 빈 목록 항목은 상세 값으로 채운다', () {
      final PostSnapshot s = PostSnapshot.forBookmark(
        SiteType.clien,
        ListItem.empty().copyWith(id: 1, board: 'park'),
        details(),
        1,
      );
      expect(s.title, '상세 제목');
      expect(s.nickName, '상세닉');
      expect(s.time, '2026-11-18');
    });

    test('상세가 있으면 옛 목록 값보다 상세 값을 쓴다', () {
      final PostSnapshot s = PostSnapshot.forBookmark(
        SiteType.clien,
        ListItem.empty().copyWith(id: 1, title: '옛 제목', time: '3분 전'),
        details(),
        1,
      );
      expect(s.title, '상세 제목');
      expect(s.time, '3분 전');
    });

    test('상세가 없거나 비어 있으면 목록 값', () {
      final ListItem item = ListItem.empty().copyWith(id: 1, title: '목록');
      expect(
        PostSnapshot.forBookmark(SiteType.clien, item, null, 1).title,
        '목록',
      );
      expect(
        PostSnapshot.forBookmark(
          SiteType.clien,
          item,
          details(title: '', nick: ''),
          1,
        ).title,
        '목록',
      );
    });
  });
}
