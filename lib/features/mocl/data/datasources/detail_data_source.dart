import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../../domain/entities/mocl_result.dart';

abstract class DetailDataSource {
  Future<Result> getDetail(
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
  Future<Result> getDetail(
    ListItem item,
    BaseParser parser,
  ) =>
      apiClient.getDetail(item, parser);
}
