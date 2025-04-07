import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:injectable/injectable.dart';

abstract class DetailDataSource {
  Future<Result<Details>> getDetail(
    ListItem item,
  );
}

@LazySingleton(as: DetailDataSource)
class DetailDataSourceImpl extends DetailDataSource {
  final BaseApi api;
  final BaseParser parser;

  DetailDataSourceImpl({
    required ParserFactory parserFactory,
  })  : parser = parserFactory.buildParser().$1,
        api = parserFactory.buildParser().$2;

  @override
  Future<Result<Details>> getDetail(
    ListItem item,
  ) =>
      api.detail(item, parser);
}
