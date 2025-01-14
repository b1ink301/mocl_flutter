import 'dart:core';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainDataSource dataSource;
  final ApiClient apiClient;
  final ParserFactory parserFactory;

  const MainRepositoryImpl({
    required this.dataSource,
    required this.apiClient,
    required this.parserFactory,
  });

  BaseParser get _currentParser => parserFactory.currentParser;

  @override
  Stream<Either<Failure, List<MainItem>>> getMainListStream({
    required SiteType siteType,
  }) async* {
    try {
      if (siteType == SiteType.naverCafe) {
        yield await apiClient.getMain(_currentParser);
      } else {
        final result = await dataSource.get(siteType);
        yield Right(result);
      }
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
      final mainData = await dataSource.getAllFromJson(siteType);
      final result = mainData.map((data) => data.toEntity(siteType));
      final futures = result.map((item) async {
        final hasItem = await dataSource.hasItem(siteType, item);
        return item.copyWith(hasItem: hasItem);
      }).toList();

      var list = await Future.wait(futures);
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
      if (siteType == SiteType.naverCafe) {
        return await apiClient.getMain(_currentParser);
      } else {
        final result = await dataSource.get(siteType);
        return Right(result);
      }
    } on Exception catch (e) {
      return Left(GetMainFailure(message: e.toString()));
    }
  }
}
