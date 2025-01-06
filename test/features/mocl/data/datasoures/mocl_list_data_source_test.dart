import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import 'mocl_list_data_source_test.mocks.dart';

@GenerateMocks([ListDataSource, BaseParser])
void main() {
  const SiteType siteType = SiteType.damoang;
  late final MockListDataSource listDataSource;
  late final MockBaseParser parser;
  // late final AppDatabase appDatabase;

  const mainItemModel = MainItemModel(
    orderBy: 1,
    board: "free",
    type: 0,
    text: "free",
    url: "https://damoang.net/free",
    siteType: siteType,
  );

  setUpAll(() {
    // appDatabase = await $FloorAppDatabase.databaseBuilder('mocl.db').build();
    parser = MockBaseParser();
    listDataSource = MockListDataSource();
    // listDataSource = ListDataSourceImpl(
    //   localDatabase: localDatabase,
    //   apiClient: apiClient,
    // );
  });

  test('리스트 목록을 가져온다. (성공)', () async {
    // arrange
    provideDummyBuilder<Either<Failure, List<ListItem>>>(
        (_, __) => Right(const <ListItem>[]));

    when(listDataSource.getList(any, any, any, any))
        .thenAnswer((_) => Future.value(Right(const <ListItem>[])));

    var item = mainItemModel.toEntity(siteType);
    log("result=$item");

    // act
    final result = await listDataSource.getList(item, 0, -1, parser);
    // log("result=${result.data.length}");

    // assert
    expect(result, isA<ResultSuccess>());
  });

  test('리스트 목록을 가져온다. (에러)', () async {
    //arrange
    provideDummyBuilder<Result<List<ListItem>>>(
        (_, __) => ResultSuccess(const <ListItem>[]));

    when(listDataSource.getList(any, any, any, any))
        .thenThrow(ResultFailure(GetListFailure(message: '----')));

    //act
    final item = mainItemModel.toEntity(siteType);
    try {
      final _ = await listDataSource.getList(item, 0, -1, parser);
    } catch (e) {
      //assert
      expect(e, isA<ResultFailure>());
      expect((e as ResultFailure?)?.failure, isA<GetListFailure>());
    }
  });
}
