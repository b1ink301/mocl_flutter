import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';

final getMainListProvider = Provider((ref) {
  final mainRepository = ref.watch(mainRepositoryProvider);
  return GetMainList(mainRepository: mainRepository);
});

final getMainListFromJsonProvider = Provider((ref) {
  final mainRepository = ref.watch(mainRepositoryProvider);
  return GetMainListFromJson(mainRepository: mainRepository);
});

final getSiteTypeProvider = Provider((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return GetSiteType(settingsRepository: settingsRepository);
});

final setSiteTypeProvider = Provider((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return SetSiteType(settingsRepository: settingsRepository);
});

final setMainListProvider = Provider((ref) {
  final mainRepository = ref.watch(mainRepositoryProvider);
  return SetMainList(mainRepository: mainRepository);
});

final getListProvider = Provider((ref) {
  final listRepository = ref.watch(listRepositoryProvider);
  return GetList(listRepository: listRepository);
});

final getDetailProvider = Provider((ref) {
  final detailRepository = ref.watch(detailRepositoryProvider);
  return GetDetail(detailRepository: detailRepository);
});

final setReadProvider = Provider((ref) {
  final listRepository = ref.watch(listRepositoryProvider);
  return SetReadFlag(listRepository: listRepository);
});