import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

// import './mocl_local_data_source_test.mocks.dart';

// @GenerateMocks([MainDataSource])
void main() async {
  const SiteType siteType = SiteType.damoang;
  late final ListDataSource listDataSource;
  late final BaseParser parser;
  late final LocalDatabase localDatabase;

  const mainItemModel = MainItemData(
    orderBy: 1,
    board: "free",
    type: 0,
    text: "free",
    url: "https://damoang.net/free",
    siteType: siteType,
  );

  setUpAll(() {
    parser = DamoangParser();
    localDatabase = LocalDatabase();
    listDataSource = ListDataSourceImpl(
      parser: parser,
      localDatabase: localDatabase,
    );
  });

  test('리스트 목록을 가져온다.', () async {
    var item = mainItemModel.toMainItem(siteType);
    log("result=$item");

    ResultSuccess<List<ListItem>> result =
        await listDataSource.getList(item, 0) as ResultSuccess<List<ListItem>>;
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
