import 'dart:core';

import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';

import '../../domain/entities/mocl_result.dart';
import '../../domain/entities/mocl_site_type.dart';
import '../../domain/repositories/main_repository.dart';
import '../datasources/main_data_source.dart';

class MainRepositoryImpl extends MainRepository {
  final MainDataSource dataSource;

  MainRepositoryImpl({required this.dataSource});

  @override
  Stream<Result> getMainListStream({
    required SiteType siteType,
  }) async* {
    yield ResultLoading();
    try {
      final result = await dataSource.get(siteType);
      yield ResultSuccess<List<MainItem>>(data: result);
    } on Exception catch (e) {
      yield ResultFailure<Failure>(
          failure: GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  }) async {
    try {
      final result = await dataSource.set(siteType, list);
      return ResultSuccess<List<int>>(data: result);
    } on Exception catch (e) {
      return ResultFailure<Failure>(
          failure: SetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result> getMainListFromJson({
    required SiteType siteType,
  }) async {
    try {
      final mainData = await dataSource.getAllFromJson(siteType);
      final result = mainData.map((data) => data.toEntity(siteType));
      var futures = result.map((item) async {
        var hasItem = await dataSource.hasItem(item);
        return item.copyWith(hasItem: hasItem);
      }).toList();

      var list = await Future.wait(futures);
      return ResultSuccess<List<MainItem>>(data: list);
    } on Exception catch (e) {
      return ResultFailure<Failure>(
          failure: GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result> getMainList({required SiteType siteType}) async {
    try {
      var result = await dataSource.get(siteType);
      return ResultSuccess(data: result);
    } on Exception catch (e) {
      return ResultFailure<Failure>(
          failure: GetMainFailure(message: e.toString()));
    }
  }
}
