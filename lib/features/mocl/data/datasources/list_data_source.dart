import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/db/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

abstract class ListDataSource {
  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    int lastId,
    SortType sortType,
  );

  Future<Either<Failure, List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    int lastId,
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

class ListDataSourceImpl implements ListDataSource {
  final LocalDatabase localDatabase;
  final ApiClient apiClient;
  final BaseParser parser;

  const ListDataSourceImpl({
    required this.localDatabase,
    required this.apiClient,
    required this.parser,
  });

  @override
  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    int lastId,
    SortType sortType,
  ) =>
      apiClient.getList(item, page, lastId, sortType, parser, isReadFlags);

  @override
  Future<Either<Failure, List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    int lastId,
    SortType sortType,
    String keyword,
  ) =>
      apiClient.getSearchList(
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
