import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';

@Injectable(as: ListRepository)
class ListRepositoryImpl extends ListRepository {
  final ListDataSource dataSource;
  final BaseParser parser;

  ListRepositoryImpl({
    required this.dataSource,
    required ParserFactory parserFactory,
  }) : parser = parserFactory.createParser();

  @override
  Future<Result<List<ListItem>>> getList({
    required MainItem item,
    required int page,
    required int lastId,
  }) =>
      dataSource.getList(item, page, lastId, parser);

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
