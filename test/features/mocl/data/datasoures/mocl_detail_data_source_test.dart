import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/damoang/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';

import 'mocl_detail_data_source_test.mocks.dart';

@GenerateMocks([BaseApi])
void main() async {
  late final DetailDataSource detailDataSource;
  late final MockBaseApi mockApiClient;
  late final ProviderContainer container;
  late final BaseParser parser;

  // var json = '''{id: 1310241, title: 사설 댓글팀 보면 여론조작하는 세력을 놔두는거 같아요, reply: , category: , image: https://damoang.net/data/member_image/go/google_a2c50979.gif?1720228754, time: 16:01, url: https://damoang.net/free/1310241, board: free, boardTitle: boardTitle, like: , hit: 36, userInfo: Instance of 'UserInfo', hasImage: false, isRead: false}''';
  final item = ListItem(
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
    TestWidgetsFlutterBinding.ensureInitialized();

    parser = DamoangParser();
    mockApiClient = MockBaseApi();

    container = ProviderContainer(
      overrides: [
        detailDatasourceProvider
            .overrideWithValue(DetailDataSourceImpl(apiClient: mockApiClient, parser: parser))
      ],
    );

    detailDataSource = container.read(detailDatasourceProvider);
  });

  test('[API] detail remote datasource test. (success)', () async {
    provideDummyBuilder<Either<Failure, Details>>(
        (_, __) => Right(Details.empty()));

    // arrange
    when(mockApiClient.detail(any, any))
        .thenAnswer((_) async => Right(Details.empty()));

    // act
    final Either<Failure, Details> result =
        await detailDataSource.getDetail(item);

    debugPrint('result=$result');

    // assert
    expect(result, isA<Right>());

    final details = result.getRight().toNullable();

    expect(details, isA<Details>());
  });

  test('[API] detail remote datasource test. (failed)', () async {
    // arrange
    provideDummyBuilder<Either<Failure, Details>>(
        (_, __) => Right(Details.empty()));

    // arrange
    when(mockApiClient.detail(any, any)).thenAnswer(
        (_) async => Left(GetDetailFailure(message: 'GetDetailFailure')));

    // act
    final result = await detailDataSource.getDetail(item);

    // assert
    expect(result.isLeft(), true);

    final failure = result.getLeft().toNullable();

    expect(failure, isA<GetDetailFailure>());
  });
}
