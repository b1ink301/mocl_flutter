import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_entity.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

// import './mocl_local_data_source_test.mocks.dart';

// @GenerateMocks([MainDataSource])
void main() async {
  const SiteType siteType = SiteType.Damoang;
  late MainDataSource mainDataSource;
  late LocalDatabase localDatabase;

  setUpAll(() async {
    // TestWidgetsFlutterBinding.ensureInitialized();
    /// 유닛 테스트는 현재 구동하는 O/S 기반의 라이브러리가 필요하다. 다운로드 API가 동작이 안되니.. 직접 해당 버전에 맞는 라이브러리를 다운로드한다.
    // await Isar.initializeIsarCore(download: true);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
          return './';
        });

    localDatabase = LocalDatabase();
    mainDataSource = MainDataSourceImpl(localDatabase: localDatabase);
    await localDatabase.init();
  });

  tearDownAll(() async => await localDatabase.close());

  test('MainDataSource Test', () async {
    // when(mainDataSource.get(siteType)).thenAnswer((_) async => <MainItem>[]);
    await mainDataSource.deleteAll(siteType);
    final result = await mainDataSource.get(siteType);
    // verify(mainDataSource.get(siteType)).called(1);
    expect(result, equals(<MainItem>[]));
  });

  test('DB에 메인 목록이 없다.', () async {
    final result = await localDatabase.getMainItems(siteType);
    expect(result, equals(List<MainItemData>.empty()));
  });

  test('Json 파일로 부터 MainItemData 목록을 얻어온다.', () async {
    final result = await mainDataSource.getAllFromJson(siteType);
    print("result.length=${result.length}");
    // expect(result, equals(List<MainItemData>.empty()));
    expect(result.length, 23);
  });

  test('Json 파일로 부터 MainItemData 목록을 얻어 mainItem 목록로 변환한다.', () async {
    final result = await mainDataSource.getAllFromJson(siteType);
    var mainItemList = result.map((item) => item.toMainItem(siteType)).toList();
    print("mainItemList=$mainItemList");
    expect(mainItemList, isA<List<MainItem>>());
  });

  test('Json 파일의 모든 데이터를 DB로 저장한다.', () async {
    final dataList = await mainDataSource.getAllFromJson(siteType);
    var mainItemList = dataList.map((item) => item.toMainItem(siteType)).toList();
    var result = await mainDataSource.set(siteType, mainItemList);
    print("result=$result");
    expect(result, isA<List<Id>>());
  });

  test('DB에서 메인 목록을 조회 한다.', () async {
    final result = await localDatabase.getMainItems(siteType);
    print("result=$result");
    expect(result, isA<List<MainItemEntity>>());
  });
}
