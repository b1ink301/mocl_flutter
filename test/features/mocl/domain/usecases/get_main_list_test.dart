import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/core/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/core/error/failures.dart';

import 'get_main_list_test.mocks.dart';

@GenerateMocks([MainRepository])
void main() {
  late final GetMainList getMainList;
  late final MockMainRepository mockMainRepository;

  setUpAll(() {
    mockMainRepository = MockMainRepository();
    getMainList = GetMainList(mainRepository: mockMainRepository);
  });

  test('main 유즈케이스는 빈값을 리턴한다.', () async {
    provideDummyBuilder<Either<Failure, List<MainItem>>>(
        (Object parent, Invocation invocation) {
      return Right(const []);
    });

    when(mockMainRepository.getMainList(siteType: anyNamed('siteType')))
        .thenAnswer((_) async => Right(const []));

    var result = await getMainList(SiteType.damoang);
    var expected = Result<List<MainItem>>.success(const []);
    log('result=$result, expected=$expected');
    expect(result, expected);
  });
}
