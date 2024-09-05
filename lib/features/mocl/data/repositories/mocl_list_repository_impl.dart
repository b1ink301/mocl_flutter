import 'dart:core';

import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../domain/entities/mocl_result.dart';
import '../../domain/repositories/list_repository.dart';
import '../datasources/list_data_source.dart';
import '../datasources/parser/parser_factory.dart';

class ListRepositoryImpl extends ListRepository {
  final ListDataSource dataSource;
  final ParserFactory parserFactory;

  ListRepositoryImpl({
    required this.dataSource,
    required this.parserFactory,
  });

  @override
  Future<Result> getList({
    required MainItem item,
    required int page,
    required int lastId,
  }) =>
      dataSource.getList(item, page, lastId, parserFactory.createParser());

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
  Future<Map<int, bool>> getReadFlags({
    required SiteType siteType,
    required List<int> boardIds,
  }) =>
      dataSource.isReadFlags(siteType, boardIds);
}
