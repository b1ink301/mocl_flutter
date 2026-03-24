import 'package:mocl_flutter/features/settings_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/entities/mocl_site_type.dart';
import '../../network/application/network_provider.dart';
import '../../network/data/datasources/base_api.dart';
import '../../settings_page/domain/repositories/settings_repository.dart';
import '../data/datasources/base/base_parser.dart';
import '../data/datasources/clien/clien_parser.dart';
import '../data/datasources/damoang/damoang_parser.dart';
import '../data/datasources/geek_news/geek_news_parser.dart';
import '../data/datasources/meeco/meeco_parser.dart';
import '../data/datasources/naver_cafe/naver_cafe_parser.dart';
import '../data/datasources/reddit/reddit_parser.dart';
import '../data/datasources/theqoo/theqoo_parser.dart';

part 'datasource_provider.g.dart';

@riverpod
(BaseParser, BaseApi) _clienParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(clienApiClientProvider);
  return (ClienParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) _damoangParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(damoangApiClientProvider);
  return (DamoangParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) _meecoParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(meecoApiClientProvider);
  return (MeecoParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) _naverCafeParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(naverCafeApiClientProvider);
  return (const NaverCafeParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _redditParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(redditApiClientProvider);
  return (const RedditParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _theqooParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(theQooApiClientProvider);
  return (const TheQooParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _geekNewsParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(geekNewsApiClientProvider);
  return (const GeekNewsParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) currentParser(Ref ref, SiteType siteType) {
  final SettingsRepository settingsRepository = ref.read(
    settingsRepositoryProvider,
  );
  final isShowNickImage = settingsRepository.isShowNickImage();

  return switch (siteType) {
    SiteType.clien => ref.watch(_clienParserProvider(isShowNickImage)),
    SiteType.damoang => ref.watch(_damoangParserProvider(isShowNickImage)),
    SiteType.geekNews => ref.watch(_geekNewsParserProvider(isShowNickImage)),
    SiteType.meeco => ref.watch(_meecoParserProvider(isShowNickImage)),
    SiteType.naverCafe => ref.watch(_naverCafeParserProvider(isShowNickImage)),
    SiteType.reddit => ref.watch(_redditParserProvider(isShowNickImage)),
    SiteType.theqoo => ref.watch(_theqooParserProvider(isShowNickImage)),
    SiteType.settings => throw UnimplementedError(),
  };
}
