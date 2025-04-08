import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';

abstract class DetailDataSource {
  Future<Result<Details>> getDetail(
    ListItem item,
  );
}

@LazySingleton(as: DetailDataSource)
class DetailDataSourceImpl implements DetailDataSource {
  final ParserFactory parserFactory;

  const DetailDataSourceImpl({
    required this.parserFactory,
  });

  @override
  Future<Result<Details>> getDetail(
    ListItem item,
  ) {
    final (parser, api) = parserFactory.buildParser();
    return api.detail(item, parser);
  }
}
