import 'dart:core';

import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../../domain/entities/mocl_result.dart';
import '../../domain/repositories/detail_repository.dart';
import '../datasources/detail_data_source.dart';

class DetailRepositoryImpl extends DetailRepository {
  final DetailDataSource detailDataSource;

  DetailRepositoryImpl({
    required this.detailDataSource,
  });

  @override
  Future<Result> getDetail({required ListItem item}) =>
      detailDataSource.getDetail(item);
}
