// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mocl_flutter/core/data/datasources/remote/base/base_api.dart'
    as _i79;
import 'package:mocl_flutter/core/data/datasources/remote/base/base_parser.dart'
    as _i901;
import 'package:sembast/sembast.dart' as _i310;
import 'package:sembast/sembast_io.dart' as _i156;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../core/data/datasources/detail_data_source.dart' as _i758;
import '../../../core/data/datasources/list_data_source.dart' as _i151;
import '../../../core/data/datasources/main_data_source.dart' as _i341;
import '../../../core/data/datasources/remote/base/parser_factory.dart'
    as _i802;
import '../../../core/data/repositories/mocl_detail_repository_impl.dart'
    as _i354;
import '../../../core/data/repositories/mocl_list_repository_impl.dart'
    as _i803;
import '../../../core/data/repositories/mocl_main_repository_impl.dart'
    as _i428;
import '../../../core/domain/entities/mocl_list_item.dart' as _i1057;
import '../../../core/domain/entities/mocl_main_item.dart' as _i916;
import '../../../core/domain/entities/mocl_site_type.dart' as _i348;
import '../../../core/domain/repositories/detail_repository.dart' as _i1013;
import '../../../core/domain/repositories/list_repository.dart' as _i154;
import '../../../core/domain/repositories/main_repository.dart' as _i357;
import '../../../core/domain/usecases/get_detail.dart' as _i859;
import '../../../core/domain/usecases/get_list.dart' as _i807;
import '../../../core/domain/usecases/get_main_list.dart' as _i417;
import '../../../core/domain/usecases/get_main_list_from_json.dart' as _i223;
import '../../../core/domain/usecases/set_main_list.dart' as _i233;
import '../../clien/data/datasources/remote/parser/clien_parser.dart' as _i616;
import '../../damoang/data/datasources/remote/parser/damoang_parser.dart'
    as _i721;
import '../../database/data/local/local_database.dart' as _i865;
import '../../database/domain/usecases/get_read_flag.dart' as _i988;
import '../../database/domain/usecases/set_read_flag.dart' as _i493;
import '../../settings/data/repositories/mocl_settings_repository_impl.dart'
    as _i380;
import '../../settings/domain/repositories/settings_repository.dart' as _i409;
import '../../settings/domain/usecases/get_site_type.dart' as _i478;
import '../../settings/domain/usecases/set_site_type.dart' as _i573;
import '../../settings/presentation/pages/settings/bloc/clear_data_cubit.dart'
    as _i1035;
import '../../settings/presentation/pages/settings/bloc/get_version_cubit.dart'
    as _i545;
import '../../settings/presentation/pages/settings/bloc/settings_bloc.dart'
    as _i906;
import 'injection.dart' as _i464;
import 'pages/detail/bloc/detail_view_bloc.dart' as _i83;
import 'pages/detail/bloc/get_height_cubit.dart' as _i63;
import 'pages/detail/detail_view_util.dart' as _i149;
import 'pages/list/bloc/list_paging_cubit.dart' as _i1015;
import 'pages/list/readable_flag.dart' as _i64;
import 'pages/main/add_dialog/bloc/main_data_json_bloc.dart' as _i61;
import 'pages/main/bloc/main_data_bloc.dart' as _i413;
import 'pages/main/bloc/site_type_bloc.dart' as _i1067;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final parserModule = _$ParserModule();
    final registerModule = _$RegisterModule();
    gh.factory<_i1035.ClearDataCubit>(() => _i1035.ClearDataCubit());
    gh.factory<_i906.SettingsBloc>(() => _i906.SettingsBloc());
    gh.factory<_i545.GetVersionCubit>(() => _i545.GetVersionCubit());
    gh.factory<_i149.DetailViewUtil>(() => _i149.DetailViewUtil());
    gh.factory<_i63.GetHeightCubit>(() => _i63.GetHeightCubit());
    gh.singleton<Map<_i348.SiteType, (_i901.BaseParser, _i79.BaseApi)>>(
      () => parserModule.parsers,
    );
    await gh.singletonAsync<_i156.Database>(
      () => registerModule.database,
      preResolve: true,
    );
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i616.ClienParser>(() => const _i616.ClienParser());
    gh.lazySingleton<_i64.ReadableFlag>(() => _i64.ReadableFlag());
    gh.lazySingleton<_i721.DamoangParser>(
      () => _i721.DamoangParser(gh<bool>()),
    );
    gh.factory<_i865.LocalDatabase>(
      () => _i865.LocalDatabase(database: gh<_i310.Database>()),
    );
    gh.lazySingleton<_i409.SettingsRepository>(
      () => _i380.SettingsRepositoryImpl(prefs: gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i802.ParserFactory>(
      () => _i802.ParserFactory(
        gh<Map<_i348.SiteType, (_i901.BaseParser, _i79.BaseApi)>>(),
        gh<_i409.SettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i758.DetailDataSource>(
      () =>
          _i758.DetailDataSourceImpl(parserFactory: gh<_i802.ParserFactory>()),
    );
    gh.factory<_i478.GetSiteType>(
      () =>
          _i478.GetSiteType(settingsRepository: gh<_i409.SettingsRepository>()),
    );
    gh.factory<_i573.SetSiteType>(
      () =>
          _i573.SetSiteType(settingsRepository: gh<_i409.SettingsRepository>()),
    );
    gh.lazySingleton<_i151.ListDataSource>(
      () => _i151.ListDataSourceImpl(
        localDatabase: gh<_i865.LocalDatabase>(),
        parserFactory: gh<_i802.ParserFactory>(),
      ),
    );
    gh.lazySingleton<_i341.MainDataSource>(
      () => _i341.MainDataSourceImpl(
        localDatabase: gh<_i865.LocalDatabase>(),
        parserFactory: gh<_i802.ParserFactory>(),
      ),
    );
    gh.singleton<_i1067.SiteTypeBloc>(
      () => _i1067.SiteTypeBloc(
        getSiteType: gh<_i478.GetSiteType>(),
        setSiteType: gh<_i573.SetSiteType>(),
      ),
    );
    gh.factory<_i154.ListRepository>(
      () => _i803.ListRepositoryImpl(dataSource: gh<_i151.ListDataSource>()),
    );
    gh.factory<_i1013.DetailRepository>(
      () =>
          _i354.DetailRepositoryImpl(dataSource: gh<_i758.DetailDataSource>()),
    );
    gh.factory<_i859.GetDetail>(
      () => _i859.GetDetail(detailRepository: gh<_i1013.DetailRepository>()),
    );
    gh.factory<_i807.GetList>(
      () => _i807.GetList(listRepository: gh<_i154.ListRepository>()),
    );
    gh.factory<_i493.SetReadFlag>(
      () => _i493.SetReadFlag(listRepository: gh<_i154.ListRepository>()),
    );
    gh.factory<_i988.GetReadFlag>(
      () => _i988.GetReadFlag(listRepository: gh<_i154.ListRepository>()),
    );
    gh.lazySingleton<_i357.MainRepository>(
      () => _i428.MainRepositoryImpl(dataSource: gh<_i341.MainDataSource>()),
    );
    gh.factory<_i417.GetMainList>(
      () => _i417.GetMainList(mainRepository: gh<_i357.MainRepository>()),
    );
    gh.factory<_i233.SetMainList>(
      () => _i233.SetMainList(mainRepository: gh<_i357.MainRepository>()),
    );
    gh.factory<_i223.GetMainListFromJson>(
      () =>
          _i223.GetMainListFromJson(mainRepository: gh<_i357.MainRepository>()),
    );
    gh.lazySingleton<_i413.MainDataBloc>(
      () => _i413.MainDataBloc(
        getMainList: gh<_i417.GetMainList>(),
        setMainList: gh<_i233.SetMainList>(),
        getSiteType: gh<_i478.GetSiteType>(),
        setSiteType: gh<_i573.SetSiteType>(),
      ),
    );
    gh.factory<_i61.MainDataJsonBloc>(
      () => _i61.MainDataJsonBloc(
        getMainListFromJson: gh<_i223.GetMainListFromJson>(),
        setMainList: gh<_i233.SetMainList>(),
      ),
    );
    gh.factoryParam<_i1015.ListPagingCubit, _i916.MainItem, dynamic>(
      (_mainItem, _) => _i1015.ListPagingCubit(gh<_i807.GetList>(), _mainItem),
    );
    gh.factoryParam<_i83.DetailViewBloc, _i1057.ListItem, _i348.SiteType>(
      (_listItem, _siteType) => _i83.DetailViewBloc(
        gh<_i859.GetDetail>(),
        gh<_i493.SetReadFlag>(),
        gh<_i64.ReadableFlag>(),
        _listItem,
        _siteType,
      ),
    );
    return this;
  }
}

class _$ParserModule extends _i464.ParserModule {}

class _$RegisterModule extends _i464.RegisterModule {}
