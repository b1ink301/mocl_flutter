import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/detail_page/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_provider.g.dart';

@riverpod
DetailDataSource detailDatasource(Ref ref, SiteType siteType) {
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  final (currentParser, currentApi) = ref.watch(
    currentParserProvider(siteType),
  );
  return DetailDataSourceImpl(
    apiClient: currentApi,
    parser: currentParser,
    localDatabase: localDatabase,
  );
}
