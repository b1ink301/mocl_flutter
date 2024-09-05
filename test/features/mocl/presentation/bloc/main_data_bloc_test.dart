import 'dart:async';
import 'dart:developer';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_json_bloc.dart';

void main() async {
  const SiteType siteType = SiteType.damoang;
  late MainDataBloc mainDataBloc;
  late MainDataJsonBloc mainDataJsonBloc;
  late GetMainList getMainList;
  late GetMainListFromJson getMainListFromJson;
  late SetMainList setMainList;
  late MainRepository mainRepository;
  late MainDataSource mainDataSource;
  late LocalDatabase localDatabase;
  StreamSubscription<MainDataState>? subscription;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      return './';
    });

    final appDatabase =
        await $FloorAppDatabase.databaseBuilder('mocl.db').build();
    localDatabase = LocalDatabase(database: appDatabase);
    mainDataSource = MainDataSourceImpl(localDatabase: localDatabase);
    mainRepository = MainRepositoryImpl(dataSource: mainDataSource);
    getMainList = GetMainList(mainRepository: mainRepository);
    getMainListFromJson = GetMainListFromJson(mainRepository: mainRepository);
    setMainList = SetMainList(mainRepository: mainRepository);
    mainDataBloc = MainDataBloc(
      getMainList: getMainList,
      setMainList: setMainList,
    );

    mainDataJsonBloc = MainDataJsonBloc(
      getMainListFromJson: getMainListFromJson,
      setMainList: setMainList,
    );
    subscription = mainDataBloc.stream.listen(print);
  });

  tearDownAll(() => subscription?.cancel());

  test('초기 상태는 Empty()', () {
    expect(mainDataBloc.state.status, equals(MainDataStatus.initial));
  });

  test('test', () {
    mainDataBloc.add(GetMainDataEvent(siteType: siteType));
    log('mainDataBloc.state=${mainDataBloc.state}');
  });

  blocTest(
    '블락 GetMainDataEvent',
    build: () => mainDataBloc,
    act: (bloc) => bloc.add(GetMainDataEvent(siteType: siteType)),
    expect: () => [isA<MainDataState>()],
  );

  blocTest(
    '블락 MainDataJsonBloc',
    build: () => mainDataJsonBloc,
    act: (bloc) => bloc.add(const GetMainDataFromJsonEvent(siteType: siteType)),
    expect: () => [isA<MainDataJsonState>(), isA<MainDataJsonState>()],
  );
}
