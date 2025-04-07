import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

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

  Future<int> setReadFlag(
    SiteType siteType,
    int id,
  );

  Future<bool> isReadFlag(
    SiteType siteType,
    int boardId,
  );

  Future<List<int>> isReadFlags(
    SiteType siteType,
    List<int> boardIds,
  );
}

@LazySingleton(as: ListDataSource)
class ListDataSourceImpl implements ListDataSource {
  final LocalDatabase localDatabase;
  final BaseApi apiClient;
  final BaseParser parser;

  ListDataSourceImpl({
    required this.localDatabase,
    required ParserFactory parserFactory,
  })  : parser = parserFactory.buildParser().$1,
        apiClient = parserFactory.buildParser().$2;

  @override
  Future<Result<List<ListItem>>> getList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
  ) =>
      apiClient.list(item, page, lastId, sortType, parser, isReadFlags);

  @override
  Future<Result<List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
  ) =>
      apiClient.searchList(
          item, page, lastId, sortType, keyword, parser, isReadFlags);

  @override
  Future<int> setReadFlag(
    SiteType siteType,
    int id,
  ) async =>
      localDatabase.setRead(siteType, id);

  @override
  Future<bool> isReadFlag(
    SiteType siteType,
    int boardId,
  ) async =>
      localDatabase.isRead(siteType, boardId);

  @override
  Future<List<int>> isReadFlags(
    SiteType siteType,
    List<int> boardIds,
  ) async =>
      localDatabase.isReads(siteType, boardIds);
}
