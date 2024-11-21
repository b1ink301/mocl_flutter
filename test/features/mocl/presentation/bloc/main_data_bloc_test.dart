import 'dart:async';
import 'dart:developer';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
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
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/bloc/main_data_json_bloc.dart';
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

    final appDatabase =
        await $FloorAppDatabase.databaseBuilder('mocl.db').build();
    final prefs = await SharedPreferences.getInstance();
    localDatabase = LocalDatabase(database: appDatabase);
    mainDataSource = MainDataSourceImpl(localDatabase: localDatabase);
    settingsRepository = SettingsRepositoryImpl(prefs: prefs);
    mainRepository = MainRepositoryImpl(
        dataSource: mainDataSource,
        apiClient: ApiClient(),
        parserFactory: ParserFactory(
          clienParser: ClienParser(),
          meecoParser: MeecoParser(),
          naverCafeParser: NaverCafeParser(),
          damoangParser: DamoangParser(),
          settingsRepository: settingsRepository,
        ));
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
    expect(mainDataBloc.state, equals(const MainDataState.initial()));
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
