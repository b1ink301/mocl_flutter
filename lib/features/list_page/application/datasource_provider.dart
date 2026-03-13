import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/list_page/data/datasources/list_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_provider.g.dart';

@riverpod
ListDataSource listDatasource(Ref ref, SiteType siteType) {
  final localDatabase = ref.watch(localDatabaseProvider);
  final (parser, apiClient) = ref.watch(currentParserProvider(siteType));
  return ListDataSourceImpl(
    localDatabase: localDatabase,
    apiClient: apiClient,
    parser: parser,
  );
}
