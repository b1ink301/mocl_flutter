import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@module
abstract class ParserModule {
  @injectable
  Map<SiteType, BaseParser> get parsers => {
        SiteType.clien: _clienParser,
        SiteType.damoang: _damoangParser,
        SiteType.meeco: _meecoParser,
        SiteType.naverCafe: _naverCafeParser,
      };

  @lazySingleton
  ClienParser get _clienParser => ClienParser();

  @lazySingleton
  MeecoParser get _meecoParser => MeecoParser();

  @lazySingleton
  DamoangParser get _damoangParser => DamoangParser();

  @lazySingleton
  NaverCafeParser get _naverCafeParser => NaverCafeParser();
}

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<AppDatabase> get appDatabase =>
      $FloorAppDatabase.databaseBuilder('mocl.db').build();

  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
}
