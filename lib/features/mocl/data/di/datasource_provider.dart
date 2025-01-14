import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/db/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/di/network_provider.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'datasource_provider.g.dart';

@riverpod
Database appDatabase(Ref ref) => throw UnimplementedError();

@riverpod
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError();

@riverpod
LocalDatabase localDatabase(Ref ref) {
  final Database database = ref.watch(appDatabaseProvider);
  return LocalDatabase(database: database);
}

@riverpod
MainDataSource mainDatasource(Ref ref) {
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  return MainDataSourceImpl(localDatabase: localDatabase);
}

@riverpod
ListDataSource listDatasource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  return ListDataSourceImpl(localDatabase: localDatabase, apiClient: apiClient);
}

@riverpod
DetailDataSource detailDatasource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);
  return DetailDataSourceImpl(apiClient: apiClient);
}

@riverpod
ParserFactory parserFactory(Ref ref) {
  final SettingsRepository settingsRepository =
      ref.watch(settingsRepositoryProvider);
  return ParserFactory(
    settingsRepository: settingsRepository,
    parsers: <SiteType, BaseParser>{
      SiteType.clien: const ClienParser(),
      SiteType.damoang: const DamoangParser(),
      SiteType.meeco: const MeecoParser(),
      SiteType.naverCafe: const NaverCafeParser(),
    },
  );
}
