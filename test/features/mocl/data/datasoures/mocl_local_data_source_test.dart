import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/features/mocl/data/db/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import './mocl_local_data_source_test.mocks.dart';

@GenerateMocks([LocalDatabase])
void main() {
  const SiteType siteType = SiteType.damoang;
  late MainDataSource mainDataSource;
  late MockLocalDatabase localDatabase;
  late final ProviderContainer container;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    localDatabase = MockLocalDatabase();

    container = ProviderContainer(
      overrides: [
        mainDatasourceProvider
            .overrideWithValue(MainDataSourceImpl(localDatabase: localDatabase))
      ],
    );

    mainDataSource = container.read(mainDatasourceProvider);
  });

  tearDownAll(() => localDatabase.dispose());

  test('main local datasource test. (empty)', () async {
    when(localDatabase.getMainData(any))
        .thenAnswer((_) async => List<MainItemData>.empty());

    verifyZeroInteractions(localDatabase);

    final result = await mainDataSource.get(siteType);

    expect(result, isA<List<MainItem>>());

    expect(result.isEmpty, true);
  });

  test('Get MainItemModel from json File', () async {
    // arrange
    // when(mainDataSource.getAllFromJson(siteType)).thenAnswer((_) async =>
    //     mainListJson.map((item) => MainItemModel.fromJson(item)).toList());

    // act
    final result = await mainDataSource.getAllFromJson(siteType);
    log("result.length=${result.length}");

    // assert
    expect(result.isNotEmpty, true);
  });

  test('MainItemData to MainItem From JSON', () async {
    final result = await mainDataSource.getAllFromJson(siteType);
    var mainItemList = result.map((item) => item.toEntity(siteType)).toList();
    log("mainItemList=$mainItemList");
    expect(mainItemList, isA<List<MainItem>>());
  });

  test('set MainItemData to DB', () async {
    // arrange
    // when(mainDataSource.getAllFromJson(siteType)).thenAnswer((_) =>
    //     Future.value(
    //         mainListJson.map((item) => MainItemModel.fromJson(item)).toList()));

    when(localDatabase.setMainData(any, any))
        .thenAnswer((_) async => <int>[1, 2, 3]);

    // act
    final mainResult = await mainDataSource.getAllFromJson(siteType);
    var mainItemList =
        mainResult.map((item) => item.toEntity(siteType)).toList();

    var result = await mainDataSource.set(siteType, mainItemList);
    log("result=$result");

    // asseret
    expect(result, isA<List<int>>());
  });

  test('query MainItemData from DB', () async {
    when(localDatabase.getMainData(any))
        .thenAnswer((_) async => List<MainItemData>.empty());

    final result = await mainDataSource.get(siteType);
    log("result=$result");

    expect(result, isA<List<MainItem>>());
  });
}
