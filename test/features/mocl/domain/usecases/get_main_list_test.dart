import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';

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
    provideDummy<Result>(ResultSuccess<List<MainItem>>(data: const []));

    when(mockMainRepository.getMainList(siteType: anyNamed('siteType')))
        .thenAnswer((_) async => ResultSuccess<List<MainItem>>(data: const []));

    var result = await getMainList(SiteType.damoang);
    var expected = ResultSuccess<List<MainItem>>(data: const []);
    log('result=$result, expected=$expected');
    expect(result, expected);
  });
}
