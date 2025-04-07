import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

// @module
// abstract class ParserModule {
//   @injectable
//   Map<SiteType, BaseParser> get parsers => {
//         SiteType.clien: _clienParser,
//         SiteType.damoang: _damoangParser,
//         SiteType.meeco: _meecoParser,
//         SiteType.naverCafe: _naverCafeParser,
//       };
//
//   @lazySingleton
//   ClienParser get _clienParser => ClienParser();
//
//   @lazySingleton
//   MeecoParser get _meecoParser => MeecoParser();
//
//   @lazySingleton
//   DamoangParser get _damoangParser => DamoangParser();
//
//   @lazySingleton
//   NaverCafeParser get _naverCafeParser => NaverCafeParser();
// }

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

  @singleton
  Dio get dio => Dio();
}

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() => getIt.init();
