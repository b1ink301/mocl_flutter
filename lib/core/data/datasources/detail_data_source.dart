import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';

abstract class DetailDataSource {
  Future<Either<Failure, Details>> getDetail(ListItem item);
}

class DetailDataSourceImpl implements DetailDataSource {
  final BaseApi apiClient;
  final BaseParser parser;

  const DetailDataSourceImpl({required this.apiClient, required this.parser});

  @override
  Future<Either<Failure, Details>> getDetail(ListItem item) =>
      apiClient.detail(item, parser);
}
