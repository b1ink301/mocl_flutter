import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:injectable/injectable.dart';

abstract class DetailDataSource {
  Future<Result<Details>> getDetail(
    ListItem item,
    BaseParser parser,
  );
}

@LazySingleton(as: DetailDataSource)
class DetailDataSourceImpl extends DetailDataSource {
  final ApiClient apiClient;

  DetailDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<Result<Details>> getDetail(
    ListItem item,
    BaseParser parser,
  ) =>
      apiClient.getDetail(item, parser);
}
