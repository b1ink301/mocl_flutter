import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import 'local_database.dart';

abstract class ListDataSource {
  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    int lastId,
    BaseParser parser,
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

class ListDataSourceImpl extends ListDataSource {
  final LocalDatabase localDatabase;
  final ApiClient apiClient;

  ListDataSourceImpl({
    required this.localDatabase,
    required this.apiClient,
  });

  @override
  Future<Either<Failure, List<ListItem>>> getList(
    MainItem item,
    int page,
    int lastId,
    BaseParser parser,
  ) =>
      apiClient.getList(
        item,
        page,
        lastId,
        parser,
        isReadFlags
      );

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
