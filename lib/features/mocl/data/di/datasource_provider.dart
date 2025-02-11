import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/detail_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/main_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/reddit_parser.dart';
import 'package:mocl_flutter/features/mocl/data/db/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/di/network_provider.dart';
import 'package:mocl_flutter/features/mocl/data/di/repository_provider.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'datasource_provider.g.dart';

@riverpod
Database appDatabase(Ref ref) => throw UnimplementedError();

@riverpod
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError();

@riverpod
LocalDatabase localDatabase(Ref ref) {
  final Database database = ref.watch(appDatabaseProvider);
  return LocalDatabase(database: database);
}

@riverpod
MainDataSource mainDatasource(Ref ref) {
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  final ApiClient apiClient = ref.watch(apiClientProvider);
  final BaseParser parser = ref.watch(currentParserProvider);
  return MainDataSourceImpl(
      localDatabase: localDatabase, apiClient: apiClient, parser: parser);
}

@riverpod
ListDataSource listDatasource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);
  final LocalDatabase localDatabase = ref.watch(localDatabaseProvider);
  final BaseParser currentParser = ref.watch(currentParserProvider);
  return ListDataSourceImpl(
      localDatabase: localDatabase,
      apiClient: apiClient,
      parser: currentParser);
}

@riverpod
DetailDataSource detailDatasource(Ref ref) {
  final ApiClient apiClient = ref.watch(apiClientProvider);
  final BaseParser currentParser = ref.watch(currentParserProvider);
  return DetailDataSourceImpl(apiClient: apiClient, parser: currentParser);
}

@riverpod
BaseParser clienParser(Ref ref) => const ClienParser();

@riverpod
BaseParser damoangParser(Ref ref) => const DamoangParser();

@riverpod
BaseParser meecoParser(Ref ref) => const MeecoParser();

@riverpod
BaseParser naverCafeParser(Ref ref) => const NaverCafeParser();

@riverpod
BaseParser redditParser(Ref ref) => const RedditParser();

// 현재 선택된 Parser를 제공하는 provider
@riverpod
BaseParser currentParser(Ref ref) {
  final SettingsRepository settingsRepository =
      ref.watch(settingsRepositoryProvider);
  final SiteType siteType = settingsRepository.getSiteType();

  return switch (siteType) {
    SiteType.clien => ref.watch(clienParserProvider),
    SiteType.damoang => ref.watch(damoangParserProvider),
    SiteType.meeco => ref.watch(meecoParserProvider),
    SiteType.naverCafe => ref.watch(naverCafeParserProvider),
    SiteType.reddit => ref.watch(redditParserProvider),
    SiteType.settings => throw UnimplementedError(),
  };
}
