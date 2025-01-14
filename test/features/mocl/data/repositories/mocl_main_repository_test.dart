import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

import './mocl_main_repository_test.mocks.dart';

@GenerateMocks([MainDataSource, SettingsRepository, ParserFactory])
void main() {
  const SiteType siteType = SiteType.damoang;
  late MockMainDataSource mockMainDataSource;
  late MainRepository moclRepository;
  late MockParserFactory mockParserFactory;

  setUpAll(() async {
    // TestWidgetsFlutterBinding.ensureInitialized();
    // SharedPreferences.setMockInitialValues({});
    // final prefs = await SharedPreferences.getInstance();

    mockParserFactory = MockParserFactory();
    when(mockParserFactory.currentParser).thenReturn(ClienParser());

    mockMainDataSource = MockMainDataSource();
    moclRepository = MainRepositoryImpl(
      dataSource: mockMainDataSource,
      apiClient: ApiClient(Dio())..init(CookieJar()),
      parserFactory: mockParserFactory,
    );
  });

  const MainItemModel mainItemModel = MainItemModel(
    orderBy: 1,
    board: "notice",
    type: 0,
    text: "공지사항",
    url: "https://damoang.net/notice",
    siteType: siteType,
  );

  final MainItem mainItem = mainItemModel.toEntity(siteType);

  group("메인 목록", () {
    test('메인 목록 요청시 에러 발생', () async {
      // arrange
      when(mockMainDataSource.get(siteType))
          .thenThrow(ResultFailure(GetMainFailure(message: 'test')));

      // act
      try {
        final result = await moclRepository.getMainList(siteType: siteType);
        expect(result, isA<Result>());
      } catch (e) {
        // assert
        expect(e, isA<ResultFailure>());
        expect((e as ResultFailure?)?.failure, isA<GetMainFailure>());
      }
    });

    test('메인 목록이 비어 있을 때', () async {
      provideDummyBuilder<Result<List<MainItem>>>(
          (Object parent, Invocation invocation) {
        return Result.success(const []);
      });

      // arrange
      when(mockMainDataSource.get(siteType))
          .thenAnswer((_) => Future.value(<MainItem>[]));

      // act
      final result = await moclRepository.getMainList(siteType: siteType);

      var expected = Result.success(const <MainItem>[]);

      // assert
      expect(result.runtimeType, expected.runtimeType);
    });

    test('메인 목록이 있을 때', () async {
      // arrange
      when(mockMainDataSource.get(siteType))
          .thenAnswer((_) async => <MainItem>[mainItem]);

      // act
      var result = await moclRepository.getMainList(siteType: siteType);

      // verify(mockMainDataSource.get(siteType)).called(1);

      var data = <MainItem>[mainItem];
      // var expected = emitsInOrder([ResultSuccess(data: data)]);
      var expected = Result.success(data);

      // assert
      expect(result, expected);
    });
  });
}
