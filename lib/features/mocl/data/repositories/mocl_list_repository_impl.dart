import 'dart:core';

import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
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
  }) async {
    var parser = await parserFactory.createParser();
    return dataSource.getList(
          item, page, lastId, parser);
  }

  @override
  Future<int> setReadFlag({
    required SiteType siteType,
    required int boardId,
  }) =>
      dataSource.setReadFlag(siteType, boardId);
}
