import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/add_main_dialog/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/main_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetMainListFromJson getMainListFromJson(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final repository = ref.watch(mainRepositoryProvider(siteType));
  return GetMainListFromJson(mainRepository: repository);
}
