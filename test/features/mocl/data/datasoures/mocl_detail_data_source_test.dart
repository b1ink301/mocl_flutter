import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/http/mocl_api_client.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';

// import './mocl_local_data_source_test.mocks.dart';

// @GenerateMocks([MainDataSource])
void main() async {
  late final DetailDataSource detailDataSource;
  late final BaseParser parser;
  late final ApiClient apiClient;

  // var json = '''{id: 1310241, title: 사설 댓글팀 보면 여론조작하는 세력을 놔두는거 같아요, reply: , category: , image: https://damoang.net/data/member_image/go/google_a2c50979.gif?1720228754, time: 16:01, url: https://damoang.net/free/1310241, board: free, boardTitle: boardTitle, like: , hit: 36, userInfo: Instance of 'UserInfo', hasImage: false, isRead: false}''';
  var item = ListItem(
    id: 1310241,
    title: '사설 댓글팀 보면 여론조작하는 세력을 놔두는거 같아요',
    reply: '',
    category: '',
    time: '',
    url: 'https://damoang.net/free/1310241',
    board: 'free',
    boardTitle: '',
    like: '',
    hit: '',
    userInfo: UserInfo(id: '', nickName: '', nickImage: ''),
    hasImage: false,
    isRead: false,
  );

  setUpAll(() {
    parser = DamoangParser();
    apiClient = ApiClient();
    detailDataSource = DetailDataSourceImpl(
      parser: parser,
      apiClient: apiClient,
    );
  });

  test('리스트 목록을 가져온다.', () async {
    log("result=$item");

    ResultSuccess<Details> result =
        await detailDataSource.getDetail(item) as ResultSuccess<Details>;
    log("result=${result.data.bodyHtml}");

    expect(result, isA<ResultSuccess<Details>>());
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
