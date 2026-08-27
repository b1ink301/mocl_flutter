import 'dart:core';

import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/main_page/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';

class const MainRepositoryImpl({required final MainDataSource dataSource})
    implements MainRepository {
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
    // 큐레이션된 정의 목록을 우선한다. 예전엔 실시간 파싱(main())을 먼저 써서
    // "부분 파싱 성공"이 완전한 목록을 덮어써 항목이 누락됐다. 이제:
    //   1) 원격 큐레이션 JSON (GitHub raw) — 재배포 없이 갱신되는 주 소스
    //   2) 번들 asset JSON — 오프라인/원격 실패 폴백
    //   3) 실시간 파싱 — 큐레이션 JSON 이 없는 사이트(예: 네이버카페)의 최후 수단
    // (UnimplementedError 는 Error 라서 Exception catch 로는 안 잡히므로 catch-all)

    // 1) 원격 큐레이션 JSON
    try {
      final remote = await dataSource.getAllFromRemote(siteType);
      if (remote.isNotEmpty) {
        final List<MainItem> result = remote
            .map((data) => data.toEntity(siteType))
            .toList();
        return Right(await _markHasItem(siteType, result));
      }
    } catch (_) {
      // 다음 폴백으로 진행
    }

    // 2) 번들 asset JSON 폴백
    try {
      final mainData = await dataSource.getAllFromJson(siteType);
      if (mainData.isNotEmpty) {
        final List<MainItem> result = mainData
            .map((data) => data.toEntity(siteType))
            .toList();
        return Right(await _markHasItem(siteType, result));
      }
    } catch (_) {
      // 다음 폴백으로 진행
    }

    // 3) 실시간 파싱 최후 수단
    try {
      final List<MainItem> live = await dataSource.getAllLive(siteType);
      return Right(await _markHasItem(siteType, live));
    } catch (e) {
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
        .map((item) => item.copyWith(hasItem: savedBoards.contains(item.board)))
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
