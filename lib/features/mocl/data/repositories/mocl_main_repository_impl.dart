import 'dart:core';

import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

@LazySingleton(as: MainRepository)
class MainRepositoryImpl extends MainRepository {
  final MainDataSource dataSource;
  final ApiClient apiClient;
  final ParserFactory parserFactory;

  MainRepositoryImpl({
    required this.dataSource,
    required this.apiClient,
    required this.parserFactory,
  });

  BaseParser _currentParser() => parserFactory.createParser();

  @override
  Stream<Result<List<MainItem>>> getMainListStream({
    required SiteType siteType,
  }) async* {
    yield Result.loading();
    try {
      if (siteType == SiteType.naverCafe) {
        yield await apiClient.getMain(_currentParser());
      } else {
        final result = await dataSource.get(siteType);
        yield Result.success(result);
      }
    } on Exception catch (e) {
      yield Result.failure(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<int>>> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  }) async {
    try {
      final result = await dataSource.set(siteType, list);
      return Result<List<int>>.success(result);
    } on Exception catch (e) {
      return Result.failure(SetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  }) async {
    try {
      final mainData = await dataSource.getAllFromJson(siteType);
      final result = mainData.map((data) => data.toEntity(siteType));
      var futures = result.map((item) async {
        var hasItem = await dataSource.hasItem(siteType, item);
        return item.copyWith(hasItem: hasItem);
      }).toList();

      var list = await Future.wait(futures);
      return Result.success(list);
    } on Exception catch (e) {
      return Result.failure(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<List<MainItem>>> getMainList(
      {required SiteType siteType}) async {
    try {
      if (siteType == SiteType.naverCafe) {
        return await apiClient.getMain(_currentParser());
      } else {
        final result = await dataSource.get(siteType);
        return Result<List<MainItem>>.success(result);
      }
    } on Exception catch (e) {
      return Result.failure(GetMainFailure(message: e.toString()));
    }
  }
}
