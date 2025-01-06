import 'dart:core';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';

class DetailRepositoryImpl extends DetailRepository {
  final DetailDataSource dataSource;
  final BaseParser parser;

  DetailRepositoryImpl({
    required this.dataSource,
    required ParserFactory parserFactory,
  }): parser = parserFactory.createParser();

  @override
  Future<Either<Failure, Details>> getDetail({required ListItem item}) =>
      dataSource.getDetail(item, parser);
}
