import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

import 'base_parser.dart';

class ParserFactory {
  final Map<SiteType, BaseParser> parsers;
  final SettingsRepository settingsRepository;

  ParserFactory({
    required this.parsers,
    required this.settingsRepository,
  });

  @factoryMethod
  BaseParser createParser() {
    final parser = parsers[settingsRepository.getSiteType()];
    if (parser == null) {
      throw Exception('No parser found for the given site type');
    }
    return parser;
  }
}
