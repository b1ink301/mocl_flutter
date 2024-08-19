import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../../domain/entities/mocl_result.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_data_source.dart';
import '../datasources/parser/base_parser.dart';
import '../datasources/parser/parser_factory.dart';

@Injectable(as: DetailRepository)
class DetailRepositoryImpl extends DetailRepository {
  final DetailDataSource dataSource;
  final BaseParser parser;

  DetailRepositoryImpl({
    required this.dataSource,
    required ParserFactory parserFactory,
  }) : parser = parserFactory.createParser();

  @override
  Future<Result> getDetail({required ListItem item}) =>
      dataSource.getDetail(item, parser);
}
