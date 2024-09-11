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
import '../domain/entities/mocl_main_item.dart' as _i975;
import '../domain/repositories/detail_repository.dart' as _i564;
import '../domain/repositories/list_repository.dart' as _i480;
import '../domain/repositories/main_repository.dart' as _i534;
import '../domain/repositories/settings_repository.dart' as _i977;
import '../domain/usecases/get_detail.dart' as _i132;
import '../domain/usecases/get_list.dart' as _i716;
import '../domain/usecases/get_main_list.dart' as _i673;
import '../domain/usecases/get_main_list_from_json.dart' as _i307;
import '../domain/usecases/get_read_flag.dart' as _i145;
import '../domain/usecases/get_site_type.dart' as _i17;
import '../domain/usecases/set_main_list.dart' as _i688;
import '../domain/usecases/set_read_flag.dart' as _i902;
import '../domain/usecases/set_site_type.dart' as _i913;
import 'injection.dart' as _i464;
import 'pages/detail/bloc/detail_view_bloc.dart' as _i83;
import 'pages/list/mocl_text_styles.dart' as _i161;
import 'pages/list/paged_list_view/bloc/paged_list_cubit.dart' as _i1021;
import 'pages/main/bloc/main_data_bloc.dart' as _i413;
import 'pages/main/bloc/main_data_json_bloc.dart' as _i51;
import 'pages/main/bloc/site_type_bloc.dart' as _i1067;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i724.AppDatabase>(
      () => registerModule.appDatabase,
      preResolve: true,
    );
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
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
      () => _i231.LocalDatabase(database: gh<_i724.AppDatabase>()),
      dispose: _i231.disposeDataSource,
    );
    gh.factory<_i63.ParserFactory>(() => _i63.ParserFactory(
          clienParser: gh<_i968.ClienParser>(),
          damoangParser: gh<_i391.DamoangParser>(),
          settingsRepository: gh<_i977.SettingsRepository>(),
        ));
    gh.factory<_i17.GetSiteType>(() =>
        _i17.GetSiteType(settingsRepository: gh<_i977.SettingsRepository>()));
    gh.factory<_i913.SetSiteType>(() =>
        _i913.SetSiteType(settingsRepository: gh<_i977.SettingsRepository>()));
    gh.lazySingleton<_i958.MainDataSource>(() =>
        _i958.MainDataSourceImpl(localDatabase: gh<_i231.LocalDatabase>()));
    gh.factory<_i564.DetailRepository>(() => _i205.DetailRepositoryImpl(
          dataSource: gh<_i694.DetailDataSource>(),
          parserFactory: gh<_i63.ParserFactory>(),
        ));
    gh.lazySingleton<_i715.ListDataSource>(() => _i715.ListDataSourceImpl(
          localDatabase: gh<_i231.LocalDatabase>(),
          apiClient: gh<_i875.ApiClient>(),
        ));
    gh.lazySingleton<_i534.MainRepository>(
        () => _i555.MainRepositoryImpl(dataSource: gh<_i958.MainDataSource>()));
    gh.factory<_i480.ListRepository>(() => _i1014.ListRepositoryImpl(
          dataSource: gh<_i715.ListDataSource>(),
          parserFactory: gh<_i63.ParserFactory>(),
        ));
    gh.singleton<_i1067.SiteTypeBloc>(() => _i1067.SiteTypeBloc(
          getSiteType: gh<_i17.GetSiteType>(),
          setSiteType: gh<_i913.SetSiteType>(),
        ));
    gh.factory<_i673.GetMainList>(
        () => _i673.GetMainList(mainRepository: gh<_i534.MainRepository>()));
    gh.factory<_i688.SetMainList>(
        () => _i688.SetMainList(mainRepository: gh<_i534.MainRepository>()));
    gh.factory<_i307.GetMainListFromJson>(() =>
        _i307.GetMainListFromJson(mainRepository: gh<_i534.MainRepository>()));
    gh.factory<_i132.GetDetail>(
        () => _i132.GetDetail(detailRepository: gh<_i564.DetailRepository>()));
    gh.lazySingleton<_i413.MainDataBloc>(() => _i413.MainDataBloc(
          getMainList: gh<_i673.GetMainList>(),
          setMainList: gh<_i688.SetMainList>(),
          getSiteType: gh<_i17.GetSiteType>(),
          setSiteType: gh<_i913.SetSiteType>(),
        ));
    gh.factory<_i716.GetList>(
        () => _i716.GetList(listRepository: gh<_i480.ListRepository>()));
    gh.factory<_i902.SetReadFlag>(
        () => _i902.SetReadFlag(listRepository: gh<_i480.ListRepository>()));
    gh.factory<_i145.GetReadFlag>(
        () => _i145.GetReadFlag(listRepository: gh<_i480.ListRepository>()));
    gh.factoryParam<_i1021.PagedListCubit, _i975.MainItem, _i161.TextStyles>((
      _mainItem,
      _textStyles,
    ) =>
        _i1021.PagedListCubit(
          gh<_i716.GetList>(),
          _mainItem,
          _textStyles,
        ));
    gh.factory<_i51.MainDataJsonBloc>(() => _i51.MainDataJsonBloc(
          getMainListFromJson: gh<_i307.GetMainListFromJson>(),
          setMainList: gh<_i688.SetMainList>(),
        ));
    gh.factory<_i83.DetailViewBloc>(() => _i83.DetailViewBloc(
          gh<_i132.GetDetail>(),
          gh<_i902.SetReadFlag>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
