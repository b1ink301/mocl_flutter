import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/detail_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/main_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetMainList getMainList(Ref ref) {
  final mainRepository = ref.watch(mainRepositoryProvider);
  return GetMainList(mainRepository: mainRepository);
}

@riverpod
GetMainListFromJson getMainListFromJson(Ref ref) {
  final mainRepository = ref.watch(mainRepositoryProvider);
  return GetMainListFromJson(mainRepository: mainRepository);
}

@riverpod
GetSiteType getSiteType(Ref ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return GetSiteType(settingsRepository: settingsRepository);
}

@riverpod
SetSiteType setSiteType(Ref ref) {
  final SettingsRepository settingsRepository = ref.watch(settingsRepositoryProvider);
  return SetSiteType(settingsRepository: settingsRepository);
}

@riverpod
SetMainList setMainList(Ref ref) {
  final MainRepository mainRepository = ref.watch(mainRepositoryProvider);
  return SetMainList(mainRepository: mainRepository);
}

@riverpod
GetList getList(Ref ref) {
  final ListRepository listRepository = ref.watch(listRepositoryProvider);
  return GetList(listRepository: listRepository);
}

@riverpod
GetDetail getDetail(Ref ref) {
  final DetailRepository detailRepository = ref.watch(detailRepositoryProvider);
  return GetDetail(detailRepository: detailRepository);
}

@riverpod
SetReadFlag setRead(Ref ref) {
  final ListRepository listRepository = ref.watch(listRepositoryProvider);
  return SetReadFlag(listRepository: listRepository);
}
