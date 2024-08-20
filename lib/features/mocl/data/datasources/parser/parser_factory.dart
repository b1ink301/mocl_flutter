import 'package:flutter/cupertino.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

import 'base_parser.dart';

class ParserFactory {
  final ClienParser _clienParser;
  final DamoangParser _damoangParser;
  final SettingsRepository settingsRepository;

  ParserFactory({
    required ClienParser clienParser,
    required DamoangParser damoangParser,
    required this.settingsRepository,
  })  : _clienParser = clienParser,
        _damoangParser = damoangParser;

  Future<BaseParser> createParser() =>
      settingsRepository.getSiteType().then((type) {
        debugPrint('ParserFactory type=$type');
        return type == SiteType.damoang ? _damoangParser : _clienParser;
      });
}
