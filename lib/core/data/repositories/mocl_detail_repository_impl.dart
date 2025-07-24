import 'dart:core';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/repositories/detail_repository.dart';

class DetailRepositoryImpl implements DetailRepository {
  final DetailDataSource dataSource;

  const DetailRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, Details>> getDetail({required ListItem item}) =>
      dataSource.getDetail(item);
}
