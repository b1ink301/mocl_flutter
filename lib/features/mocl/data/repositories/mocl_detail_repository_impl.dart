import 'dart:core';
import 'dart:developer';

import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../../domain/entities/mocl_result.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_data_source.dart';
import '../datasources/parser/parser_factory.dart';

class DetailRepositoryImpl extends DetailRepository {
  final DetailDataSource dataSource;
  final ParserFactory parserFactory;

  DetailRepositoryImpl({
    required this.dataSource,
    required this.parserFactory,
  });

  @override
  Future<Result> getDetail({required ListItem item}) =>
      dataSource.getDetail(item, parserFactory.createParser());
}
