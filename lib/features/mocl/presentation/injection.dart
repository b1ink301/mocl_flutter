import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

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
