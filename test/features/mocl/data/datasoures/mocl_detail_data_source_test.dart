import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';

import 'mocl_detail_data_source_test.mocks.dart';

@GenerateMocks([DetailDataSource, BaseParser])
void main() async {
  late final MockDetailDataSource detailDataSource;
  late final MockBaseParser parser;
  // late final ApiClient apiClient;

  // var json = '''{id: 1310241, title: 사설 댓글팀 보면 여론조작하는 세력을 놔두는거 같아요, reply: , category: , image: https://damoang.net/data/member_image/go/google_a2c50979.gif?1720228754, time: 16:01, url: https://damoang.net/free/1310241, board: free, boardTitle: boardTitle, like: , hit: 36, userInfo: Instance of 'UserInfo', hasImage: false, isRead: false}''';
  var item = ListItem(
    id: 1310241,
    title: '사설 댓글팀 보면 여론조작하는 세력을 놔두는거 같아요',
    reply: '',
    category: '',
    time: '',
    info: '',
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
    parser = MockBaseParser();
    // apiClient = ApiClient();
    detailDataSource = MockDetailDataSource();
  });

  test('상세 데이터를 가져온다. (성공)', () async {
    // arrange
    provideDummyBuilder<Result<Details>>(
        (_, __) => ResultSuccess(Details.empty()));

    when(detailDataSource.getDetail(any))
        .thenAnswer((_) => Future.value(ResultSuccess(Details.empty())));

    // act
    Result result = await detailDataSource.getDetail(item);

    // assert
    expect(result, isA<ResultSuccess>());
  });

  test('상세 데이터를 가져온다. (에러)', () async {
    // arrange
    provideDummyBuilder<Result<Details>>(
        (_, __) => ResultSuccess(Details.empty()));

    when(detailDataSource.getDetail(any)).thenAnswer(
        (_) => Future.value(ResultFailure(GetDetailFailure(message: '---'))));

    // act
    Result result = await detailDataSource.getDetail(item);

    // assert
    expect(result, isA<ResultFailure>());

    expect((result as ResultFailure?)?.failure, isA<GetDetailFailure>());
  });
}
