import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

@Injectable(as: ListRepository)
class ListRepositoryImpl implements ListRepository {
  final ListDataSource dataSource;

  ListRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Result<List<ListItem>>> getList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
  }) =>
      dataSource.getList(item, page, lastId, sortType);

  @override
  Future<int> setReadFlag({
    required SiteType siteType,
    required int boardId,
  }) =>
      dataSource.setReadFlag(siteType, boardId);

  @override
  Future<bool> getReadFlag({
    required SiteType siteType,
    required int boardId,
  }) =>
      dataSource.isReadFlag(siteType, boardId);

  @override
  Future<List<int>> getReadFlags({
    required SiteType siteType,
    required List<int> boardIds,
  }) =>
      dataSource.isReadFlags(siteType, boardIds);

  @override
  Future<Result<List<ListItem>>> getSearchList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
    required String keyword,
  }) =>
      dataSource.getSearchList(item, page, lastId, sortType, keyword);
}
