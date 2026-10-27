import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/detail_page/application/repository_provider.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/get_detail.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/set_read_flag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetDetail getDetail(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final repository = ref.watch(detailRepositoryProvider(siteType));
  return GetDetail(detailRepository: repository);
}

@riverpod
SetReadFlag setReadFlag(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final repository = ref.watch(detailRepositoryProvider(siteType));
  return SetReadFlag(detailRepository: repository);
}
