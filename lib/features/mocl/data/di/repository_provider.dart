import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/parser_factory.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/data/di/network_provider.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_detail_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'repository_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  final SharedPreferences prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs: prefs);
}

@riverpod
MainRepository mainRepository(Ref ref) {
  final MainDataSource datasource = ref.watch(mainDatasourceProvider);
  final ApiClient apiClient = ref.watch(apiClientProvider);
  final ParserFactory parserFactory = ref.watch(parserFactoryProvider);
  return MainRepositoryImpl(
    dataSource: datasource,
    apiClient: apiClient,
    parserFactory: parserFactory,
  );
}

@riverpod
ListRepository listRepository(Ref ref) {
  final ListDataSource datasource = ref.watch(listDatasourceProvider);
  final ParserFactory parserFactory = ref.watch(parserFactoryProvider);
  return ListRepositoryImpl(
    dataSource: datasource,
    parser: parserFactory.currentParser,
  );
}

@riverpod
DetailRepository detailRepository(Ref ref) {
  final DetailDataSource datasource = ref.watch(detailDatasourceProvider);
  final ParserFactory parserFactory = ref.watch(parserFactoryProvider);
  return DetailRepositoryImpl(
    dataSource: datasource,
    parser: parserFactory.currentParser,
  );
}
