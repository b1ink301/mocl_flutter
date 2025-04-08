import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/bloc/main_data_json_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late SettingsRepository settingsRepository;
  late GetSiteType getSiteType;
  late SetSiteType setSiteType;
  StreamSubscription<MainDataState>? subscription;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      return './';
    });

    final Directory dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final String dbPath = join(dir.path, 'mocl-sembast.db');
    final Database database = await databaseFactoryIo.openDatabase(dbPath);
    final prefs = await SharedPreferences.getInstance();
    localDatabase = LocalDatabase(database: database);
    mainDataSource = MainDataSourceImpl(
        localDatabase: localDatabase,
        parserFactory:
            ParserFactory({}, settingsRepository));
    settingsRepository = SettingsRepositoryImpl(prefs: prefs);
    mainRepository = MainRepositoryImpl(
      dataSource: mainDataSource,
    );
    getMainList = GetMainList(mainRepository: mainRepository);
    getMainListFromJson = GetMainListFromJson(mainRepository: mainRepository);
    setMainList = SetMainList(mainRepository: mainRepository);
    getSiteType = GetSiteType(settingsRepository: settingsRepository);
    setSiteType = SetSiteType(settingsRepository: settingsRepository);
    mainDataBloc = MainDataBloc(
      getMainList: getMainList,
      setMainList: setMainList,
      getSiteType: getSiteType,
      setSiteType: setSiteType,
    );

    mainDataJsonBloc = MainDataJsonBloc(
      getMainListFromJson: getMainListFromJson,
      setMainList: setMainList,
    );
    // ignore: avoid_print
    subscription = mainDataBloc.stream.listen(print);
  });

  tearDownAll(() => subscription?.cancel());

  test('초기 상태는 Empty()', () {
    // expect(mainDataBloc.state, equals(const MainDataState.initial()));
  });

  test('blocTest', () {
    mainDataBloc.add(const MainDataEvent.getList(siteType: siteType));
    log('mainDataBloc.state=${mainDataBloc.state}');
  });

  blocTest(
    'blocTest GetMainDataEvent',
    build: () => mainDataBloc,
    act: (bloc) {
      bloc.testInitialize();
      bloc.add(const MainDataEvent.getList(siteType: siteType));
    },
    expect: () => [isA<MainDataState>()],
  );

  blocTest(
    'blocTest MainDataJsonBloc',
    build: () => mainDataJsonBloc,
    act: (bloc) =>
        bloc.add(const MainDataJsonEvent.getList(siteType: siteType)),
    expect: () => [isA<MainDataJsonState>()],
  );
}
