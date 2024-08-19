import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

import 'base_parser.dart';

@injectable
class ParserFactory {
  final ClienParser clienParser;
  final DamoangParser damoangParser;
  final SettingsRepository settingsRepository;

  ParserFactory({
    required this.clienParser,
    required this.damoangParser,
    required this.settingsRepository,
  });

  @factoryMethod
  BaseParser createParser() {
    final type = settingsRepository.getSiteType();
    return type == SiteType.damoang ? damoangParser : clienParser;
  }
}
