import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';

@Injectable(as: DetailRepository)
class DetailRepositoryImpl extends DetailRepository {
  final DetailDataSource dataSource;
  final BaseParser parser;

  DetailRepositoryImpl({
    required this.dataSource,
    required ParserFactory parserFactory,
  }): parser = parserFactory.createParser();

  @override
  Future<Result<Details>> getDetail({required ListItem item}) =>
      dataSource.getDetail(item, parser);
}
