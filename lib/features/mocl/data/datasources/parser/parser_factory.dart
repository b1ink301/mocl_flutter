import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

import 'base_parser.dart';

@injectable
class ParserFactory {
  final ClienParser _clienParser;
  final DamoangParser _damoangParser;
  final MeecoParser _meecoParser;
  final NaverCafeParser _naverCafeParser;
  final SettingsRepository settingsRepository;

  ParserFactory({
    required ClienParser clienParser,
    required DamoangParser damoangParser,
    required MeecoParser meecoParser,
    required NaverCafeParser naverCafeParser,
    required this.settingsRepository,
  })  : _clienParser = clienParser,
        _damoangParser = damoangParser,
        _meecoParser = meecoParser,
        _naverCafeParser = naverCafeParser;

  @factoryMethod
  BaseParser createParser() {
    return switch (settingsRepository.getSiteType()) {
      SiteType.clien => _clienParser,
      SiteType.damoang => _damoangParser,
      SiteType.meeco => _meecoParser,
      SiteType.naverCafe => _naverCafeParser,
      _ => throw Exception('No SiteType')
    };
  }
}
