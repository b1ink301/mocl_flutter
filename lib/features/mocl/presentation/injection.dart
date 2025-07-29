import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/clien_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/damoang_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/meeco_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/naver_cafe_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/api/reddit_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/clien_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/meeco_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/parser/reddit_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@module
abstract class ParserModule {
  @singleton
  Map<SiteType, (BaseParser, BaseApi)> get parsers => {
    SiteType.clien: _clienParser,
    SiteType.damoang: _damoangParser,
    SiteType.meeco: _meecoParser,
    SiteType.naverCafe: _naverCafeParser,
    SiteType.reddit: _redditParser,
  };

  @LazySingleton()
  Dio get _dio => Dio();

  @lazySingleton
  (BaseParser, BaseApi) get _clienParser =>
      (const ClienParser(), ClienApi(_dio, userAgentPc));

  @lazySingleton
  (BaseParser, BaseApi) get _meecoParser =>
      (const MeecoParser(false), MeecoApi(_dio, userAgentMobile));

  @lazySingleton
  (BaseParser, BaseApi) get _damoangParser =>
      (const DamoangParser(false), DamoangApi(_dio, userAgentPc));

  @lazySingleton
  (BaseParser, BaseApi) get _naverCafeParser =>
      (const NaverCafeParser(), NaverCafeApi(_dio, userAgentMobile));

  @lazySingleton
  (BaseParser, BaseApi) get _redditParser =>
      (const RedditParser(), RedditApi(_dio, userAgentPc));
}

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<Database> get database async {
    final Directory dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final String dbPath = join(dir.path, 'mocl-sembast.db');
    final Database database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }

  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => getIt.init();
