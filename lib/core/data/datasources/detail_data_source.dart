import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/parser_factory.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';

abstract class DetailDataSource {
  Future<Result<Details>> getDetail(ListItem item);
}

@LazySingleton(as: DetailDataSource)
class DetailDataSourceImpl implements DetailDataSource {
  final ParserFactory parserFactory;

  const DetailDataSourceImpl({required this.parserFactory});

  @override
  Future<Result<Details>> getDetail(ListItem item) {
    final (parser, api) = parserFactory.buildParser();
    return api.detail(item, parser);
  }
}
