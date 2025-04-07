import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/clien_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/damoang_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/meeco_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/naver_cafe_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/reddit_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/theqoo_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/reddit_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/theqoo_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

@singleton
class ParserFactory {
  final Dio dio;
  final Map<SiteType, (BaseParser, BaseApi)> parsers = {};
  final SettingsRepository settingsRepository;

  ParserFactory({
    required this.dio,
    required this.settingsRepository,
  });

  // @factoryMethod
  (BaseParser, BaseApi) buildParser() {
    final siteType = settingsRepository.getSiteType();
    if (parsers.containsKey(siteType)) {
      return parsers[siteType]!;
    }
    final parser = switch (settingsRepository.getSiteType()) {
      SiteType.clien => (ClienParser(false), ClienApi(dio, userAgentPc)),
      SiteType.damoang => (DamoangParser(false), DamoangApi(dio, userAgentPc)),
      SiteType.meeco => (MeecoParser(false), MeecoApi(dio, userAgentPc)),
      SiteType.naverCafe => (NaverCafeParser(), NaverCafeApi(dio, userAgentPc)),
      SiteType.reddit => (RedditParser(), RedditApi(dio, userAgentPc)),
      SiteType.theqoo => (TheQooPaser(), TheQooApi(dio, userAgentPc)),
      SiteType.settings => throw UnimplementedError('SiteType.settings'),
    };

    parsers.putIfAbsent(siteType, () => parser);
    return parser;
  }
}
