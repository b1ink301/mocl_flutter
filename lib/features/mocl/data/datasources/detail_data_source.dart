import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

abstract class DetailDataSource {
  Future<Either<Failure, Details>> getDetail(
    ListItem item,
  );
}

class DetailDataSourceImpl implements DetailDataSource {
  final ApiClient apiClient;
  final BaseParser parser;

  const DetailDataSourceImpl({
    required this.apiClient,
    required this.parser,
  });

  @override
  Future<Either<Failure, Details>> getDetail(
    ListItem item,
  ) =>
      apiClient.getDetail(item, parser);
}
