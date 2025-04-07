import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

@LazySingleton(as: MainRepository)
class MainRepositoryImpl implements MainRepository {
  final MainDataSource dataSource;

  MainRepositoryImpl({
    required this.dataSource,
  });

  @override
  Stream<Result<List<MainItem>>> getMainListStream({
    required SiteType siteType,
  }) async* {
    yield ResultLoading();
    try {
      yield await dataSource.get(siteType);
    } on Exception catch (e) {
      yield ResultFailure(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<int>>> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  }) async {
    try {
      final result = await dataSource.set(siteType, list);
      return ResultSuccess(result);
    } on Exception catch (e) {
      return ResultFailure(SetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  }) async {
    try {
      final result = await dataSource.getAllFromJson(siteType);
      final items = result.map((data) => data.toEntity(siteType));
      final futures = items.map((item) async {
        var hasItem = await dataSource.hasItem(siteType, item);
        return item.copyWith(hasItem: hasItem);
      }).toList();

      final list = await Future.wait(futures);
      return ResultSuccess(list);
    } on Exception catch (e) {
      return ResultFailure(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<MainItem>>> getMainList({required SiteType siteType}) =>
      dataSource.get(siteType);
}
