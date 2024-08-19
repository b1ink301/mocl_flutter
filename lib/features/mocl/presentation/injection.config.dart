// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../data/datasources/api_client.dart' as _i875;
import '../data/datasources/detail_data_source.dart' as _i694;
import '../data/datasources/list_data_source.dart' as _i715;
import '../data/datasources/local_database.dart' as _i231;
import '../data/datasources/main_data_source.dart' as _i958;
import '../data/datasources/parser/clien_parser.dart' as _i968;
import '../data/datasources/parser/damoang_parser.dart' as _i391;
import '../data/datasources/parser/parser_factory.dart' as _i63;
import '../data/db/app_database.dart' as _i724;
import '../data/repositories/mocl_detail_repository_impl.dart' as _i205;
import '../data/repositories/mocl_list_repository_impl.dart' as _i1014;
import '../data/repositories/mocl_main_repository_impl.dart' as _i555;
import '../data/repositories/mocl_settings_repository_impl.dart' as _i1051;
import '../domain/repositories/detail_repository.dart' as _i564;
import '../domain/repositories/list_repository.dart' as _i480;
import '../domain/repositories/main_repository.dart' as _i534;
import '../domain/repositories/settings_repository.dart' as _i977;
import '../domain/usecases/get_detail.dart' as _i132;
import '../domain/usecases/get_list.dart' as _i716;
import '../domain/usecases/get_main_list.dart' as _i673;
import '../domain/usecases/get_main_list_from_json.dart' as _i307;
import '../domain/usecases/get_site_type.dart' as _i17;
import '../domain/usecases/set_main_list.dart' as _i688;
import '../domain/usecases/set_read_flag.dart' as _i902;
import '../domain/usecases/set_site_type.dart' as _i913;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  await gh.singletonAsync<_i724.AppDatabase>(
    () => registerModule.appDatabase,
    preResolve: true,
  );
  gh.lazySingleton<_i968.ClienParser>(() => _i968.ClienParser());
  gh.lazySingleton<_i391.DamoangParser>(() => _i391.DamoangParser());
  gh.lazySingleton<_i875.ApiClient>(() => _i875.ApiClient()..init());
  gh.lazySingleton<_i694.DetailDataSource>(
      () => _i694.DetailDataSourceImpl(apiClient: gh<_i875.ApiClient>()));
  gh.lazySingleton<_i977.SettingsRepository>(() =>
      _i1051.SettingsRepositoryImpl(prefs: gh<_i460.SharedPreferences>()));
  gh.singleton<_i231.LocalDatabase>(
      () => _i231.LocalDatabase(database: gh<_i724.AppDatabase>()));
  gh.factory<_i63.ParserFactory>(() => _i63.ParserFactory(
        clienParser: gh<_i968.ClienParser>(),
        damoangParser: gh<_i391.DamoangParser>(),
        settingsRepository: gh<_i977.SettingsRepository>(),
      ));
  gh.factory<_i17.GetSiteType>(() =>
      _i17.GetSiteType(settingsRepository: gh<_i977.SettingsRepository>()));
  gh.factory<_i913.SetSiteType>(() =>
      _i913.SetSiteType(settingsRepository: gh<_i977.SettingsRepository>()));
  gh.lazySingleton<_i958.MainDataSource>(
      () => _i958.MainDataSourceImpl(localDatabase: gh<_i231.LocalDatabase>()));
  gh.factory<_i564.DetailRepository>(() => _i205.DetailRepositoryImpl(
        dataSource: gh<_i694.DetailDataSource>(),
        parserFactory: gh<_i63.ParserFactory>(),
      ));
  gh.lazySingleton<_i715.ListDataSource>(() => _i715.ListDataSourceImpl(
        localDatabase: gh<_i231.LocalDatabase>(),
        apiClient: gh<_i875.ApiClient>(),
      ));
  gh.factory<_i480.ListRepository>(() => _i1014.ListRepositoryImpl(
        dataSource: gh<_i715.ListDataSource>(),
        parserFactory: gh<_i63.ParserFactory>(),
      ));
  gh.lazySingleton<_i534.MainRepository>(() =>
      _i555.MainRepositoryImpl(mainDataSource: gh<_i958.MainDataSource>()));
  gh.factory<_i673.GetMainList>(
      () => _i673.GetMainList(mainRepository: gh<_i534.MainRepository>()));
  gh.factory<_i688.SetMainList>(
      () => _i688.SetMainList(mainRepository: gh<_i534.MainRepository>()));
  gh.factory<_i307.GetMainListFromJson>(() =>
      _i307.GetMainListFromJson(mainRepository: gh<_i534.MainRepository>()));
  gh.factory<_i132.GetDetail>(
      () => _i132.GetDetail(detailRepository: gh<_i564.DetailRepository>()));
  gh.factory<_i716.GetList>(
      () => _i716.GetList(listRepository: gh<_i480.ListRepository>()));
  gh.factory<_i902.SetReadFlag>(
      () => _i902.SetReadFlag(listRepository: gh<_i480.ListRepository>()));
  return getIt;
}

class _$RegisterModule extends _i464.RegisterModule {}
