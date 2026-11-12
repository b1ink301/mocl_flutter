import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/bookmark/domain/bookmark_filter.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

void main() {
  PostSnapshot post(
    int id,
    String title, {
    SiteType site = SiteType.clien,
    String boardTitle = '모두의공원',
    List<String> folders = const [],
    String memo = '',
  }) => PostSnapshot.fromListItem(
    site,
    ListItem.empty().copyWith(id: id, title: title, boardTitle: boardTitle),
    0,
  ).copyWith(folders: folders, memo: memo);

  final List<PostSnapshot> items = [
    post(1, '맥북 에어 M4 팝니다', folders: ['used'], memo: '145 이하면 연락'),
    post(2, '김치찌개 황금 비율', site: SiteType.cook82, boardTitle: '키친토크'),
    post(3, '연말정산 미리보기', folders: ['read', 'used']),
  ];

  List<int> ids(List<PostSnapshot> list) => [for (final p in list) p.id];

  test('폴더로 거른다', () {
    expect(ids(BookmarkFilter.apply(items, folderId: 'used')), [1, 3]);
    expect(ids(BookmarkFilter.apply(items, folderId: 'none')), isEmpty);
    expect(ids(BookmarkFilter.apply(items)), [1, 2, 3]);
  });

  test('제목 · 메모 · 사이트 · 게시판 이름에서 찾고, 띄어 쓴 말은 모두 들어 있어야 한다', () {
    expect(ids(BookmarkFilter.apply(items, query: '맥북')), [1]);
    expect(ids(BookmarkFilter.apply(items, query: '연락')), [1]);
    expect(ids(BookmarkFilter.apply(items, query: '82쿡')), [2]);
    expect(ids(BookmarkFilter.apply(items, query: '키친')), [2]);
    expect(ids(BookmarkFilter.apply(items, query: '  m4   맥북 ')), [1]);
    expect(ids(BookmarkFilter.apply(items, query: '맥북 김치')), isEmpty);
  });

  test('폴더와 검색어를 같이 건다', () {
    expect(ids(BookmarkFilter.apply(items, folderId: 'used', query: '연말')), [
      3,
    ]);
  });

  test('폴더별 글 수', () {
    expect(BookmarkFilter.countByFolder(items), {'used': 2, 'read': 1});
  });
}
