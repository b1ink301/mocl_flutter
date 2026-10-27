import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/main_page/data/repositories/mocl_main_repository_impl.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'datasource_provider.dart';

part 'repository_provider.g.dart';

@riverpod
MainRepository mainRepository(Ref ref, SiteType siteType) {
  final dataSource = ref.watch(mainDatasourceProvider(siteType));
  return MainRepositoryImpl(dataSource: dataSource);
}
