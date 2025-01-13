import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocl_detail_data_source_test.mocks.dart';

@GenerateMocks([DetailDataSource, BaseParser])
void main() async {
  late final MockDetailDataSource mockDetailDataSource;
  late final DetailDataSource detailDataSource;
  late final MockBaseParser mockBaseParser;
  late final ApiClient apiClient;

  late final ProviderContainer container;

  late final SharedPreferences prefs;

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

  setUpAll(() async {
    HttpOverrides.global = null;

    TestWidgetsFlutterBinding.ensureInitialized();

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    apiClient = ApiClient();

    container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(SettingsRepositoryImpl(prefs: prefs)),
        detailDatasourceProvider.overrideWithValue(DetailDataSourceImpl(apiClient: apiClient))
      ],
    );

    mockBaseParser = MockBaseParser();
    mockDetailDataSource = MockDetailDataSource();
    detailDataSource = container.read(detailDatasourceProvider);
  });

  test('[API] 상세 데이터를 가져온다. (성공)', () async {
    // arrange
    // act
    final result = await detailDataSource.getDetail(item, DamoangParser());

    // assert
    expect(result, isA<Right>());

    final details = result.getRight().toNullable();

    expect(details, isA<Details>());
  });

  test('[API] 상세 데이터를 가져온다. (실패)', () async {
    // arrange
    // act
    final result = await detailDataSource.getDetail(item, DamoangParser());

    // assert
    expect(result, isA<Left>());

    final failure = result.getLeft().toNullable();

    expect(failure, isA<GetDetailFailure>());
  });

  test('상세 데이터를 가져온다. (성공)', () async {
    // arrange
    provideDummyBuilder<Either<Failure, Details>>(
        (_, __) => Right(Details.empty()));

    when(mockDetailDataSource.getDetail(any, any))
        .thenAnswer((_) => Future.value(Right(Details.empty())));

    // act
    final result = await mockDetailDataSource.getDetail(item, mockBaseParser);

    // assert
    expect(result, isA<Right>());

    final details = result.getRight().toNullable();

    expect(details, isA<Details>());
  });

  test('상세 데이터를 가져온다. 에러', () async {
    // arrange
    provideDummyBuilder<Either<Failure, Details>>(
        (_, __) => Right(Details.empty()));

    when(mockDetailDataSource.getDetail(any, any)).thenAnswer(
        (_) => Future.value(Left(GetDetailFailure(message: '---'))));
    // act
    final result = await mockDetailDataSource.getDetail(item, mockBaseParser);

    debugPrint('result: $result');

    // assert
    expect(result, isA<Left>());

    final failure = result.getLeft().toNullable();

    expect(failure, isA<GetDetailFailure>());
  });
}
