import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/detail_page/data/repositories/mocl_detail_repository_impl.dart';
import 'package:mocl_flutter/features/detail_page/domain/repositories/detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'datasource_provider.dart';

part 'repository_provider.g.dart';

@riverpod
DetailRepository detailRepository(Ref ref, SiteType siteType) {
  final datasource = ref.watch(detailDatasourceProvider(siteType));
  return DetailRepositoryImpl(dataSource: datasource);
}
