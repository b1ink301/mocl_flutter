import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

abstract class DetailDataSource {
  Future<Either<Failure, Details>> getDetail(
    ListItem item,
    BaseParser parser,
  );
}

class DetailDataSourceImpl extends DetailDataSource {
  final ApiClient apiClient;

  DetailDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<Either<Failure, Details>> getDetail(
    ListItem item,
    BaseParser parser,
  ) =>
      apiClient.getDetail(item, parser);
}
