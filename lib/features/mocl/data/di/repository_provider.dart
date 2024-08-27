import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_detail_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/data/repositories/mocl_settings_repository_impl.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs: prefs);
});

final mainRepositoryProvider = Provider<MainRepository>((ref) {
  final datasource = ref.watch(mainDatasourceProvider);
  return MainRepositoryImpl(dataSource: datasource);
});

final listRepositoryProvider = Provider<ListRepository>((ref) {
  final datasource = ref.watch(listDatasourceProvider);
  final parserFactory = ref.watch(parserFactoryProvider);
  return ListRepositoryImpl(
      dataSource: datasource, parserFactory: parserFactory);
});

final detailRepositoryProvider = Provider<DetailRepository>((ref) {
  final datasource = ref.watch(detailDatasourceProvider);
  final parserFactory = ref.watch(parserFactoryProvider);
  return DetailRepositoryImpl(
      dataSource: datasource, parserFactory: parserFactory);
});
