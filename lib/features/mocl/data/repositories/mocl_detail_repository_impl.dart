import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';

@Injectable(as: DetailRepository)
class DetailRepositoryImpl extends DetailRepository {
  final DetailDataSource dataSource;

  DetailRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Result<Details>> getDetail({required ListItem item}) =>
      dataSource.getDetail(item);
}
