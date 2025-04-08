import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/repositories/settings_repository.dart';

@injectable
class ParserFactory {
  final Map<SiteType, (BaseParser, BaseApi)> _parsers;
  final SettingsRepository _settingsRepository;

  const ParserFactory(
    this._parsers,
    this._settingsRepository,
  );

  // @factoryMethod
  (BaseParser, BaseApi) buildParser() {
    final (BaseParser, BaseApi)? parser =
        _parsers[_settingsRepository.getSiteType()];
    if (parser == null) {
      throw Exception('No parser found for the given site type');
    }
    return parser;
  }
}
