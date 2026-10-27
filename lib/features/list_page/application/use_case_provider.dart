import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/list_page/application/repository_provider.dart';
import 'package:mocl_flutter/features/list_page/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/list_page/domain/usecases/get_search_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetList getListUseCase(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final repository = ref.watch(listRepositoryProvider(siteType));
  return GetList(listRepository: repository);
}

@riverpod
GetSearchList getSearchListUseCase(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final repository = ref.watch(listRepositoryProvider(siteType));
  return GetSearchList(listRepository: repository);
}
