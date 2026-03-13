import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

abstract class ListDataSource {
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

class ListDataSourceImpl implements ListDataSource {
  final LocalDatabase localDatabase;
  final BaseApi apiClient;
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
    LastId lastId,
    SortType sortType,
  ) => apiClient.list(item, page, lastId, sortType, parser, isReadFlags);

  @override
  Future<Either<Failure, List<ListItem>>> getSearchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
  ) => apiClient.searchList(
    item,
    page,
    lastId,
    sortType,
    keyword,
    parser,
    isReadFlags,
  );

  @override
  Future<bool> isReadFlag(SiteType siteType, int boardId) async =>
      localDatabase.isRead(siteType, boardId);

  @override
  Future<List<int>> isReadFlags(SiteType siteType, List<int> boardIds) async =>
      localDatabase.isReads(siteType, boardIds);
}
