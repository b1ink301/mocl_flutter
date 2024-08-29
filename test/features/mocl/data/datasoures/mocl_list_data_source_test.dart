import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

// import './mocl_local_data_source_test.mocks.dart';

// @GenerateMocks([MainDataSource])
void main() async {
  const SiteType siteType = SiteType.damoang;
  late final ListDataSource listDataSource;
  late final DamoangParser parser;
  late final LocalDatabase localDatabase;
  late final ApiClient apiClient;
  late final AppDatabase appDatabase;

  const mainItemModel = MainItemModel(
    orderBy: 1,
    board: "free",
    type: 0,
    text: "free",
    url: "https://damoang.net/free",
    siteType: siteType,
  );

  setUpAll(() async {
    appDatabase = await $FloorAppDatabase.databaseBuilder('mocl.db').build();
    apiClient = ApiClient.getInstance();
    parser = DamoangParser();
    localDatabase = LocalDatabase(database: appDatabase);
    listDataSource = ListDataSourceImpl(
      localDatabase: localDatabase,
      apiClient: apiClient,
    );
  });

  test('리스트 목록을 가져온다.', () async {
    var item = mainItemModel.toEntity(siteType);
    log("result=$item");

    ResultSuccess<List<ListItem>> result = await listDataSource.getList(
        item, 0, -1, parser) as ResultSuccess<List<ListItem>>;
    log("result=${result.data.length}");

    expect(result, isA<ResultSuccess<List<ListItem>>>());
  });

  // test('리스트 목록을 가져온다. (에러)', () async {
  //   var item = mainItemModel.toMainItem(siteType);
  //   print("result=$item");
  //
  //   when(listDataSource.getList(item)).thenThrow(() => GetListFailure());
  //
  //   ResultFailure result = await listDataSource.getList(item) as ResultFailure;
  //   print("result=${result.failure}");
  //
  //   expect(result, isA<ResultFailure>());
  // });
}
