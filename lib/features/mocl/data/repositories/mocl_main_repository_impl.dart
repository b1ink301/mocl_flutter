import 'dart:core';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainDataSource dataSource;

  const MainRepositoryImpl({
    required this.dataSource,
  });

  @override
  Stream<Either<Failure, List<MainItem>>> getMainListStream({
    required SiteType siteType,
  }) async* {
    try {
      final result = await dataSource.get(siteType);
      yield Right(result);
    } on Exception catch (e) {
      yield Left(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<int>>> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  }) async {
    try {
      final result = await dataSource.set(siteType, list);
      return Right(result);
    } on Exception catch (e) {
      return Left(SetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  }) async {
    try {
      final List<MainItemModel> mainData =
          await dataSource.getAllFromJson(siteType);
      final Iterable<MainItem> result =
          mainData.map((data) => data.toEntity(siteType));
      final List<Future<MainItem>> futures = result.map((item) async {
        final bool hasItem = await dataSource.hasItem(siteType, item);
        return item.copyWith(hasItem: hasItem);
      }).toList();

      final List<MainItem> list = await Future.wait(futures);
      return Right(list);
    } on Exception catch (e) {
      return Left(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MainItem>>> getMainList({
    required SiteType siteType,
  }) async {
    try {
      final List<MainItem> result = await dataSource.get(siteType);
      return Right(result);
    } on Exception catch (e) {
      return Left(GetMainFailure(message: e.toString()));
    }
  }
}
