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

part 'repository_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs: prefs);
}

@riverpod
MainRepository mainRepository(ref) {
  final datasource = ref.watch(mainDatasourceProvider);
  final apiClient = ref.watch(apiClientProvider);
  final parserFactory = ref.watch(parserFactoryProvider);
  return MainRepositoryImpl(
    dataSource: datasource,
    apiClient: apiClient,
    parserFactory: parserFactory,
  );
}

@riverpod
ListRepository listRepository(ref) {
  final datasource = ref.watch(listDatasourceProvider);
  final parserFactory = ref.watch(parserFactoryProvider);
  return ListRepositoryImpl(
    dataSource: datasource,
    parserFactory: parserFactory,
  );
}

@riverpod
DetailRepository detailRepository(ref) {
  final datasource = ref.watch(detailDatasourceProvider);
  final parserFactory = ref.watch(parserFactoryProvider);
  return DetailRepositoryImpl(
    dataSource: datasource,
    parserFactory: parserFactory,
  );
}
