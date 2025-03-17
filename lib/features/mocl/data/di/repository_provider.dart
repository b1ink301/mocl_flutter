import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
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
  return MainRepositoryImpl(dataSource: datasource);
}

@riverpod
ListRepository listRepository(Ref ref) {
  final ListDataSource datasource = ref.watch(listDatasourceProvider);
  return ListRepositoryImpl(
    dataSource: datasource,
  );
}

@riverpod
DetailRepository detailRepository(Ref ref) {
  final DetailDataSource datasource = ref.watch(detailDatasourceProvider);
  return DetailRepositoryImpl(
    dataSource: datasource,
  );
}
