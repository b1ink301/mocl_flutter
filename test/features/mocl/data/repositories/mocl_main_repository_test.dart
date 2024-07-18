import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';

import './mocl_main_repository_test.mocks.dart';

@GenerateMocks([MainDataSource, ListDataSource])
void main() {
  const SiteType siteType = SiteType.Damoang;
  late MockMainDataSource mockMainDataSource;
  late MainRepository moclRepository;

  setUpAll(() {
    mockMainDataSource = MockMainDataSource();
    moclRepository = MainRepositoryImpl(
      mainDataSource: mockMainDataSource,
    );
  });

  const mainItemModel = MainItemData(
    orderBy: 1,
    board: "notice",
    type: 0,
    text: "공지사항",
    url: "https://damoang.net/notice",
    siteType: siteType,
  );

  final mainItem = mainItemModel.toMainItem(siteType);

  group("메인 목록", () {
    test('메인 목록 요청시 에러 발생', () async {
      // arrange
      when(mockMainDataSource.get(any))
          .thenThrow(GetMainException());

      verifyZeroInteractions(mockMainDataSource);

      // act
      final result = await moclRepository.getMainList(siteType: siteType) as ResultFailure;
      var expected = ResultFailure<Failure>(failure: GetMainFailure());
      print('result=$result, expected=$expected');

      // assert
      await expectLater(result.runtimeType, expected.runtimeType);
    });

    test('메인 목록이 비어 있을 때', () async {
      // arrange
      when(mockMainDataSource.get(siteType))
          .thenAnswer((_) async => <MainItem>[]);

      // verifyZeroInteractions(moclRepository);
      // act
      final result = await moclRepository.getMainList(siteType: siteType) as ResultSuccess;

      // verify(mockMainDataSource.get(siteType));

      var expected = ResultSuccess(data: const <MainItem>[]);
      print('result=$result, expected=$expected');

      // assert
      expect(result.runtimeType, expected.runtimeType);
    });

    test('메인 목록이 있을 때', () async {
      // arrange
      when(mockMainDataSource.get(siteType))
          .thenAnswer((_) async => <MainItem>[mainItem]);

      // verifyZeroInteractions(mockMainDataSource);
      // act

      var result = await moclRepository.getMainList(siteType: siteType) as ResultSuccess;

      // verify(mockMainDataSource.get(siteType)).called(1);

      var data = <MainItem>[mainItem];
      // var expected = emitsInOrder([ResultSuccess(data: data)]);
      var expected = ResultSuccess(data: data);
      print('result=$result, expected=$expected');

      // assert
      expect(result, expected);
    });
  });
}
