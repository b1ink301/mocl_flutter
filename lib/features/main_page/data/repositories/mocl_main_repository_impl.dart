import 'dart:core';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/main_page/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainDataSource dataSource;

  const MainRepositoryImpl({required this.dataSource});

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
    // 1) 실시간 파싱(main()) 우선 시도. main() 미구현/네트워크 실패 시 asset 폴백.
    //    (UnimplementedError 는 Error 라서 Exception catch 로는 안 잡히므로 catch-all)
    try {
      final List<MainItem> live = await dataSource.getAllLive(siteType);
      if (live.isNotEmpty) {
        return Right(await _markHasItem(siteType, live));
      }
    } catch (_) {
      // 폴백으로 진행
    }

    // 2) asset JSON 폴백
    try {
      final mainData = await dataSource.getAllFromJson(siteType);
      final List<MainItem> result = mainData
          .map((data) => data.toEntity(siteType))
          .toList();
      return Right(await _markHasItem(siteType, result));
    } on Exception catch (e) {
      return Left(GetMainFailure(message: e.toString()));
    }
  }

  /// 각 항목이 이미 추가돼 있는지(hasItem) 표시.
  /// 항목이 많을 수 있으므로(예: 디시 2,500+ 갤러리) 저장 목록을 한 번만 읽어
  /// board 기준 Set 으로 비교한다(항목당 DB 조회 방지).
  Future<List<MainItem>> _markHasItem(
    SiteType siteType,
    List<MainItem> items,
  ) async {
    Set<String> savedBoards;
    try {
      final saved = await dataSource.get(siteType);
      savedBoards = saved.map((e) => e.board).toSet();
    } catch (_) {
      savedBoards = const <String>{};
    }
    return items
        .map(
          (item) => item.copyWith(hasItem: savedBoards.contains(item.board)),
        )
        .toList();
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
