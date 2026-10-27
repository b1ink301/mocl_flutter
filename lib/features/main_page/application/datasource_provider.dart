import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/main_page/data/datasources/main_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_provider.g.dart';

@riverpod
MainDataSource mainDatasource(Ref ref, SiteType siteType) {
  final (parser, apiClient) = ref.watch(currentParserProvider(siteType));
  return MainDataSourceImpl(apiClient: apiClient, parser: parser);
}
