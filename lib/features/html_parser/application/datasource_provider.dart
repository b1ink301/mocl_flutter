import 'package:mocl_flutter/features/settings_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/domain/entities/mocl_site_type.dart';
import '../../network/application/network_provider.dart';
import '../../network/data/datasources/base_api.dart';
import '../../settings_page/domain/repositories/settings_repository.dart';
import '../data/datasources/base/base_parser.dart';
import '../data/datasources/arcalive/arcalive_parser.dart';
import '../data/datasources/bobaedream/bobaedream_parser.dart';
import '../data/datasources/clien/clien_parser.dart';
import '../data/datasources/cook82/cook82_parser.dart';
import '../data/datasources/dcinside/dcinside_parser.dart';
import '../data/datasources/damoang/damoang_parser.dart';
import '../data/datasources/geek_news/geek_news_parser.dart';
import '../data/datasources/inven/inven_parser.dart';
import '../data/datasources/meeco/meeco_parser.dart';
import '../data/datasources/naver_cafe/naver_cafe_parser.dart';
import '../data/datasources/ppomppu/ppomppu_parser.dart';
import '../data/datasources/reddit/reddit_parser.dart';
import '../data/datasources/ruliweb/ruliweb_parser.dart';
import '../data/datasources/theqoo/theqoo_parser.dart';

part 'datasource_provider.g.dart';

@riverpod
(BaseParser, BaseApi) _arcaliveParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(arcaliveApiClientProvider);
  return (const ArcaliveParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _bobaedreamParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(bobaedreamApiClientProvider);
  return (const BobaedreamParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _clienParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(clienApiClientProvider);
  return (ClienParser(isShowNickImage), baseApi);
}

@riverpod
(BaseParser, BaseApi) _dcinsideParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(dcinsideApiClientProvider);
  return (const DcinsideParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _cook82Parser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(cook82ApiClientProvider);
  return (const Cook82Parser(), baseApi);
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
(BaseParser, BaseApi) _ruliwebParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(ruliwebApiClientProvider);
  return (const RuliwebParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _ppomppuParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(ppomppuApiClientProvider);
  return (const PpomppuParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _geekNewsParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(geekNewsApiClientProvider);
  return (const GeekNewsParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) _invenParser(Ref ref, bool isShowNickImage) {
  final baseApi = ref.watch(invenApiClientProvider);
  return (const InvenParser(), baseApi);
}

@riverpod
(BaseParser, BaseApi) currentParser(Ref ref, SiteType siteType) {
  final SettingsRepository settingsRepository = ref.read(
    settingsRepositoryProvider,
  );
  final isShowNickImage = settingsRepository.isShowNickImage();

  return switch (siteType) {
    SiteType.arcalive => ref.watch(_arcaliveParserProvider(isShowNickImage)),
    SiteType.bobaedream => ref.watch(_bobaedreamParserProvider(isShowNickImage)),
    SiteType.clien => ref.watch(_clienParserProvider(isShowNickImage)),
    SiteType.cook82 => ref.watch(_cook82ParserProvider(isShowNickImage)),
    SiteType.dcinside => ref.watch(_dcinsideParserProvider(isShowNickImage)),
    SiteType.damoang => ref.watch(_damoangParserProvider(isShowNickImage)),
    SiteType.geekNews => ref.watch(_geekNewsParserProvider(isShowNickImage)),
    SiteType.inven => ref.watch(_invenParserProvider(isShowNickImage)),
    SiteType.meeco => ref.watch(_meecoParserProvider(isShowNickImage)),
    SiteType.naverCafe => ref.watch(_naverCafeParserProvider(isShowNickImage)),
    SiteType.ppomppu => ref.watch(_ppomppuParserProvider(isShowNickImage)),
    SiteType.reddit => ref.watch(_redditParserProvider(isShowNickImage)),
    SiteType.ruliweb => ref.watch(_ruliwebParserProvider(isShowNickImage)),
    SiteType.theqoo => ref.watch(_theqooParserProvider(isShowNickImage)),
    SiteType.settings => throw UnimplementedError(),
  };
}
