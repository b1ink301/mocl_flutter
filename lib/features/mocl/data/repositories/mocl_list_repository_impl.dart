import 'dart:core';

import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';

import '../../domain/entities/mocl_result.dart';
import '../../domain/repositories/list_repository.dart';
import '../datasources/mocl_list_data_source.dart';

class ListRepositoryImpl extends ListRepository {
  final ListDataSource listDataSource;

  ListRepositoryImpl({
    required this.listDataSource,
  });

  @override
  Future<Result> getList({
    required MainItem item,
    required int page,
  }) => listDataSource.getList(item, page);
}
