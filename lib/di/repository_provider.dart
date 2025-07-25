import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/repositories/detail_repository.dart';
import 'package:mocl_flutter/core/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/core/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/settings/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/di/datasource_provider.dart';
import 'package:mocl_flutter/core/data/repositories/mocl_detail_repository_impl.dart';
import 'package:mocl_flutter/core/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/core/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/settings/data/repositories/mocl_settings_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(prefs: ref.watch(sharedPreferencesProvider));

@riverpod
MainRepository mainRepository(Ref ref) =>
    MainRepositoryImpl(dataSource: ref.watch(mainDatasourceProvider));

@riverpod
ListRepository listRepository(Ref ref) =>
    ListRepositoryImpl(dataSource: ref.watch(listDatasourceProvider));

@riverpod
DetailRepository detailRepository(Ref ref) =>
    DetailRepositoryImpl(dataSource: ref.watch(detailDatasourceProvider));
