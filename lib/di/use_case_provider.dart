import 'package:mocl_flutter/core/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/core/domain/usecases/get_list.dart';
import 'package:mocl_flutter/core/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/core/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/core/domain/usecases/get_search_list.dart';
import 'package:mocl_flutter/core/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/core/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/di/repository_provider.dart';
import 'package:mocl_flutter/features/settings/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/settings/domain/usecases/set_site_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetMainList getMainList(Ref ref) =>
    GetMainList(mainRepository: ref.watch(mainRepositoryProvider));

@riverpod
GetMainListFromJson getMainListFromJson(Ref ref) =>
    GetMainListFromJson(mainRepository: ref.watch(mainRepositoryProvider));

@riverpod
GetSiteType getSiteType(Ref ref) =>
    GetSiteType(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
SetSiteType setSiteType(Ref ref) =>
    SetSiteType(settingsRepository: ref.watch(settingsRepositoryProvider));

@riverpod
SetMainList setMainList(Ref ref) =>
    SetMainList(mainRepository: ref.watch(mainRepositoryProvider));

@riverpod
GetList getList(Ref ref) =>
    GetList(listRepository: ref.watch(listRepositoryProvider));

@riverpod
GetSearchList getSearchList(Ref ref) =>
    GetSearchList(listRepository: ref.watch(listRepositoryProvider));

@riverpod
GetDetail getDetail(Ref ref) =>
    GetDetail(detailRepository: ref.watch(detailRepositoryProvider));

@riverpod
SetReadFlag setRead(Ref ref) =>
    SetReadFlag(listRepository: ref.watch(listRepositoryProvider));
