import 'package:fpdart/fpdart.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:mocl_shared/util/reply_count.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

abstract class ListDataSource() {
  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
  );

  Future<Either<Failure, List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
  );

  Future<bool> isReadFlag(SiteType siteType, int boardId);

  Future<List<int>> isReadFlags(SiteType siteType, List<int> boardIds);
}

class const ListDataSourceImpl({
  required final LocalDatabase localDatabase,
  required final BaseApi apiClient,
  required final BaseParser parser,
}) implements ListDataSource {
  @override
  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
  ) async => _withNewReplies(
    item.siteType,
    await apiClient.list(item, page, lastId, sortType, parser, isReadFlags),
  );

  @override
  Future<Either<Failure, List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
  ) async => _withNewReplies(
    item.siteType,
    await apiClient.searchList(
      item,
      page,
      lastId,
      sortType,
      keyword,
      parser,
      isReadFlags,
    ),
  );

  /// 읽은 글마다 마지막으로 열었을 때 본 댓글 수와 비교해 늘어난 만큼을
  /// [ListItem.newReplyCount] 에 넣는다. 기록이 없거나(옛 기록 · 14일 지남)
  /// 댓글 수를 정확히 읽을 수 없는 글은 0 그대로.
  Future<Either<Failure, List<ListItem>>> _withNewReplies(
    SiteType siteType,
    Either<Failure, List<ListItem>> result,
  ) async {
    final List<ListItem>? items = result.toNullable();
    if (items == null) return result;
    final List<int> readIds = [
      for (final ListItem item in items)
        if (item.isRead) item.id,
    ];
    if (readIds.isEmpty) return result;
    final Map<int, int> seen = await localDatabase.seenReplies(
      siteType,
      readIds,
    );
    if (seen.isEmpty) return result;
    return Right([
      for (final ListItem item in items)
        switch ((seen[item.id], parseReplyCount(item.reply))) {
          (final int before, final int now) when item.isRead && now > before =>
            item.copyWith(newReplyCount: now - before),
          _ => item,
        },
    ]);
  }

  @override
  Future<bool> isReadFlag(SiteType siteType, int boardId) async =>
      localDatabase.isRead(siteType, boardId);

  @override
  Future<List<int>> isReadFlags(SiteType siteType, List<int> boardIds) async =>
      localDatabase.isReads(siteType, boardIds);
}
