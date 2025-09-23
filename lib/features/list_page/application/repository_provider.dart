import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/list_page/data/repositories/mocl_list_repository_impl.dart';
import 'package:mocl_flutter/features/list_page/domain/repositories/list_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'datasource_provider.dart';

part 'repository_provider.g.dart';

@riverpod
ListRepository listRepository(Ref ref, SiteType siteType) {
  final dataSource = ref.watch(listDatasourceProvider(siteType));
  return ListRepositoryImpl(dataSource: dataSource);
}
