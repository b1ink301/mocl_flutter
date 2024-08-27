import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
import 'package:mocl_flutter/features/mocl/data/di/network_provider.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasources/main_data_source.dart';

final appDatabaseProvider =
    Provider<AppDatabase>((ref) => throw UnimplementedError());

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return LocalDatabase(database: database);
});

final mainDatasourceProvider = Provider<MainDataSource>((ref) {
  final localDatabase = ref.watch(localDatabaseProvider);
  return MainDataSourceImpl(localDatabase: localDatabase);
});

final listDatasourceProvider = Provider<ListDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final localDatabase = ref.watch(localDatabaseProvider);
  return ListDataSourceImpl(localDatabase: localDatabase, apiClient: apiClient);
});

final detailDatasourceProvider = Provider<DetailDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DetailDataSourceImpl(apiClient: apiClient);
});

final parserFactoryProvider = Provider<ParserFactory>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return ParserFactory(
    clienParser: ClienParser(),
    damoangParser: DamoangParser(),
    settingsRepository: settingsRepository,
  );
});
