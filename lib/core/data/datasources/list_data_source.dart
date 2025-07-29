import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/parser_factory.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/database/data/local/local_database.dart';

abstract class ListDataSource {
  Future<Result<List<ListItem>>> getList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
  );

  Future<Result<List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
  );

  Future<int> setReadFlag(SiteType siteType, int id);

  Future<bool> isReadFlag(SiteType siteType, int boardId);

  Future<List<int>> isReadFlags(SiteType siteType, List<int> boardIds);
}

@LazySingleton(as: ListDataSource)
class ListDataSourceImpl implements ListDataSource {
  final LocalDatabase localDatabase;
  final ParserFactory parserFactory;

  const ListDataSourceImpl({
    required this.localDatabase,
    required this.parserFactory,
  });

  @override
  Future<Result<List<ListItem>>> getList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
  ) {
    final (parser, api) = parserFactory.buildParser();
    return api.list(item, page, lastId, sortType, parser, isReadFlags);
  }

  @override
  Future<Result<List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
  ) {
    final (parser, api) = parserFactory.buildParser();
    return api.searchList(
      item,
      page,
      lastId,
      sortType,
      keyword,
      parser,
      isReadFlags,
    );
  }

  @override
  Future<int> setReadFlag(SiteType siteType, int id) async =>
      localDatabase.setRead(siteType, id);

  @override
  Future<bool> isReadFlag(SiteType siteType, int boardId) async =>
      localDatabase.isRead(siteType, boardId);

  @override
  Future<List<int>> isReadFlags(SiteType siteType, List<int> boardIds) async =>
      localDatabase.isReads(siteType, boardIds);
}
