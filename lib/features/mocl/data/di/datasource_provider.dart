import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/di/network_provider.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../datasources/local/local_database.dart';
import '../datasources/remote/base/base_api.dart';
import '../datasources/remote/base/base_parser.dart';
import '../datasources/remote/parser/clien_parser.dart';
import '../datasources/remote/parser/damoang_parser.dart';
import '../datasources/remote/parser/meeco_parser.dart';
import '../datasources/remote/parser/naver_cafe_parser.dart';
import '../datasources/remote/parser/reddit_parser.dart';
import '../datasources/remote/parser/theqoo_parser.dart';

part 'datasource_provider.g.dart';

@riverpod
Database appDatabase(Ref ref) => throw UnimplementedError('appDatabase');

@riverpod
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferences');

@riverpod
LocalDatabase localDatabase(Ref ref) {
  final Database database = ref.watch(appDatabaseProvider);
  return LocalDatabase(database: database);
}

@riverpod
MainDataSource mainDatasource(Ref ref) {
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  final (parser, apiClient) = ref.watch(currentParserProvider);
  return MainDataSourceImpl(
      localDatabase: localDatabase, apiClient: apiClient, parser: parser);
}

@riverpod
ListDataSource listDatasource(Ref ref) {
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  final (parser, apiClient) = ref.watch(currentParserProvider);
  return ListDataSourceImpl(
      localDatabase: localDatabase, apiClient: apiClient, parser: parser);
}

@riverpod
DetailDataSource detailDatasource(Ref ref) {
  final (currentParser, currentApi) = ref.watch(currentParserProvider);
  return DetailDataSourceImpl(apiClient: currentApi, parser: currentParser);
}

@riverpod
(BaseParser, BaseApi) clienParser(Ref ref) {
  final baseApi = ref.watch(clienApiClientProvider);
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  final isShowNickImage = settingsRepository.isShowNickImage();
  return (ClienParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) damoangParser(Ref ref) {
  final baseApi = ref.watch(damoangApiClientProvider);
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  final isShowNickImage = settingsRepository.isShowNickImage();
  return (DamoangParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) meecoParser(Ref ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  final isShowNickImage = settingsRepository.isShowNickImage();
  final baseApi = ref.watch(meecoApiClientProvider);
  return (MeecoParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) naverCafeParser(Ref ref) {
  final baseApi = ref.watch(naverCafeApiClientProvider);
  return (const NaverCafeParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) redditParser(Ref ref) {
  final baseApi = ref.watch(redditApiClientProvider);
  return (const RedditParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) theqooParser(Ref ref) {
  final baseApi = ref.watch(theQooApiClientProvider);
  return (const TheQoo(), baseApi);
}

// 현재 선택된 Parser를 제공하는 provider
@riverpod
(BaseParser, BaseApi) currentParser(Ref ref) {
  final SettingsRepository settingsRepository =
      ref.watch(settingsRepositoryProvider);
  final SiteType siteType = settingsRepository.getSiteType();

  return switch (siteType) {
    SiteType.clien => ref.watch(clienParserProvider),
    SiteType.damoang => ref.watch(damoangParserProvider),
    SiteType.meeco => ref.watch(meecoParserProvider),
    SiteType.naverCafe => ref.watch(naverCafeParserProvider),
    SiteType.reddit => ref.watch(redditParserProvider),
    SiteType.theqoo => ref.watch(theqooParserProvider),
    SiteType.settings => throw UnimplementedError(),
  };
}
