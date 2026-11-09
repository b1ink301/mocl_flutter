import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/list_page/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:sembast/sembast_memory.dart';

/// 정해 둔 목록만 돌려주는 API. 읽음 여부는 실제처럼 `isReads` 로 채운다.
class _FakeApi(final List<ListItem> _items) implements BaseApi {
  @override
  Future<Either<Failure, List<ListItem>>> list(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    final Set<int> read = (await isReads(
      item.siteType,
      _items.map((e) => e.id).toList(),
    )).toSet();
    return Right([
      for (final e in _items) e.copyWith(isRead: read.contains(e.id)),
    ]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeParser() implements BaseParser {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ListItem _item(int id, String reply) =>
    ListItem.empty().copyWith(id: id, reply: reply, title: 't$id');

void main() {
  late LocalDatabase db;
  int seq = 0;

  setUp(() async {
    final String path = 'new_replies_${seq++}.db';
    db = LocalDatabase(
      database: await openVersionedDatabase(databaseFactoryMemory, path),
      opener: () => openVersionedDatabase(databaseFactoryMemory, path),
    );
  });
  tearDown(() => db.dispose());

  Future<List<ListItem>> load(List<ListItem> items) async {
    final ListDataSource source = ListDataSourceImpl(
      localDatabase: db,
      apiClient: _FakeApi(items),
      parser: _FakeParser(),
    );
    final result = await source.getList(
      MainItem.empty().copyWith(siteType: SiteType.clien),
      1,
      LastId.empty(),
      SortType.recent,
    );
    return result.getOrElse((f) => throw f);
  }

  test('읽은 글만, 늘어난 만큼 newReplyCount 를 채운다', () async {
    await db.setRead(SiteType.clien, 1, replyCount: 10); // 늘었음
    await db.setRead(SiteType.clien, 2, replyCount: 5); // 그대로
    await db.setRead(SiteType.clien, 3, replyCount: 9); // 줄었음(삭제)
    await db.setRead(SiteType.clien, 4); // 옛 기록(댓글 수 없음)
    await db.setSeenReplies(SiteType.clien, 5, 1); // 읽음 기록 없음 → 안 읽은 글

    final List<ListItem> items = await load([
      _item(1, '[13]'),
      _item(2, '5'),
      _item(3, '7'),
      _item(4, '20'),
      _item(5, '30'),
      _item(6, '1.2k'),
    ]);

    expect({for (final e in items) e.id: e.newReplyCount}, {
      1: 3,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
    });
  });
}
