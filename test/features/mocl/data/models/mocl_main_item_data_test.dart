import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() async {
  const currentSiteType = SiteType.damoang;

  const mainItemModel = MainItemData(
    orderBy: 1,
    board: "notice",
    type: 0,
    text: "공지사항",
    url: "https://damoang.net/notice",
    siteType: currentSiteType,
  );

  final List<dynamic> mainListJson =
      json.decode(fixture('damoang_board_link.json'));

  final List<MainItemData> mainModelList = mainListJson.map((item) {
    item['siteType'] = currentSiteType.name;
    return MainItemData.fromJson(item as Map<String, dynamic>);
  }).toList();

  group('MainItemModel 테스트', () {
    test('json은 List<MainItemModel>로 변환되어야 한다.', () async {
      expect(mainModelList, isA<List<MainItemData>>());
    });

    test('첫 번째 항목이 일치 해야 한다.', () async {
      expect(mainModelList.first, mainItemModel);
    });
  });

  group('MainItem 테스트', () {
    final List<MainItem> mainList =
        mainModelList.map((item) => item.toMainItem(currentSiteType)).toList();

    test('json은 List<MainItem>로 변환되어야 한다.', () async {
      expect(mainList, isA<List<MainItem>>());
    });

    test('두 항목이 일치 해야 한다.', () async {
      // act
      final mainItemDto = mainItemModel.toMainItem(currentSiteType);
      // assert
      expect(mainItemDto, mainList.first);
    });
  });

  // group('MainItemModel', () {
  //   test('JsonSerializable', () async {
  //     // arrange
  //     final Map<String, dynamic> jsonMap =
  //         json.decode(fixture('damoang_board_link.json'));
  //
  //     // act
  //     final result = MainItemModel.fromJson(jsonMap);
  //
  //     // assert
  //     expect(result, mainList);
  //   });
  // });
}
