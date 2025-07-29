import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/local/local_database.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';

import '../../../../fixtures/fixture_reader.dart';
import './mocl_local_data_source_test.mocks.dart';

@GenerateMocks([LocalDatabase, MainDataSource])
void main() {
  const SiteType siteType = SiteType.damoang;
  late MockMainDataSource mainDataSource;
  late MockLocalDatabase localDatabase;
  late final List<dynamic> mainListJson;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    /// 유닛 테스트는 현재 구동하는 O/S 기반의 라이브러리가 필요하다. 다운로드 API가 동작이 안되니.. 직접 해당 버전에 맞는 라이브러리를 다운로드한다.
    // await Isar.initializeIsarCore(download: true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      return './';
    });
    localDatabase = MockLocalDatabase();
    mainDataSource = MockMainDataSource();

    mainListJson = json.decode(fixture('damoang_board_link.json'));
  });

  // tearDownAll(() async => await localDatabase.close());

  test('DB에 메인 목록이 없다.', () async {
    when(mainDataSource.get(siteType))
        .thenAnswer((_) => Future.value(ResultSuccess(List.empty())));
    verifyZeroInteractions(mainDataSource);
    final result = await mainDataSource.get(siteType);
    expect(result, equals(List<MainItemModel>.empty()));
  });

  test('Json 파일로 부터 MainItemData 목록을 얻어온다.', () async {
    // arrange
    when(mainDataSource.getAllFromJson(siteType)).thenAnswer((_) =>
        Future.value(
            mainListJson.map((item) => MainItemModel.fromJson(item)).toList()));

    // act
    final result = await mainDataSource.getAllFromJson(siteType);
    log("result.length=${result.length}");

    // assert
    expect(result.length, 23);
  });

  test('Json 파일로 부터 MainItemData 목록을 얻어 mainItem 목록로 변환한다.', () async {
    final result = await mainDataSource.getAllFromJson(siteType);
    var mainItemList = result.map((item) => item.toEntity(siteType)).toList();
    log("mainItemList=$mainItemList");
    expect(mainItemList, isA<List<MainItem>>());
  });

  test('Json 파일의 모든 데이터를 DB로 저장한다.', () async {
    // arrange

    when(mainDataSource.getAllFromJson(siteType)).thenAnswer((_) =>
        Future.value(
            mainListJson.map((item) => MainItemModel.fromJson(item)).toList()));

    when(mainDataSource.set(any, any))
        .thenAnswer((_) => Future.value(<int>[1, 2, 3]));

    // act
    final mainResult = await mainDataSource.getAllFromJson(siteType);
    var mainItemList = mainResult.map((item) => item.toEntity(siteType)).toList();

    var result = await mainDataSource.set(siteType, mainItemList);
    log("result=$result");

    // asseret
    expect(result, isA<List<int>>());
  });

  test('DB에서 메인 목록을 조회 한다.', () async {
    final result = await localDatabase.getMainData(siteType);
    log("result=$result");
    expect(result, isA<List<MainItemData>>());
  });
}
