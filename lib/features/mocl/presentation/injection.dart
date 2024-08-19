import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/db/app_database.dart';
import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @preResolve // 이 어노테이션이 중요합니다
  @singleton
  Future<AppDatabase> get appDatabase =>
      $FloorAppDatabase.databaseBuilder('mocl.db').build();
}

@InjectableInit(
  preferRelativeImports: true,
  asExtension: false,
)
Future<GetIt> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton(prefs);
  return await init(getIt);
}

// Future<void> init() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   //! Features - MainData
//   // DataBase
//   sl.registerSingletonAsync<LocalDatabase>(() async {
//     final localDatabase = LocalDatabase();
//     await localDatabase.init();
//     return localDatabase;
//   });
//
//   await sl.isReady<LocalDatabase>();
//
//   // Data sources
//   sl.registerSingletonWithDependencies<MainDataSource>(
//       () => MainDataSourceImpl(localDatabase: sl()),
//       dependsOn: [LocalDatabase]);
//
//   // Repository
//   // sl.registerSingletonWithDependencies<MoclRepository>(
//   //     () => MoclRepositoryImpl(mainDataSource: sl()),
//   //     dependsOn: [MainDataSource]);
//
//   // Use cases
//   sl.registerSingletonWithDependencies(() => GetMainList(mainRepository: sl()),
//       dependsOn: [MainRepository]);
//   sl.registerSingletonWithDependencies(
//       () => GetMainListFromJson(mainRepository: sl()),
//       dependsOn: [MainRepository]);
//   sl.registerSingletonWithDependencies(() => SetMainList(mainRepository: sl()),
//       dependsOn: [MainRepository]);
//
//   await sl.isReady<SetMainList>();
//
//   // Bloc
//   // sl.registerFactory(
//   //   () => MainDataBloc(
//   //     getMainList: sl(),
//   //     setMainList: sl(),
//   //   ),
//   // );
//   //
//   // sl.registerFactory(
//   //   () => MainDataJsonBloc(
//   //     getMainListFromJson: sl(),
//   //     setMainList: sl(),
//   //   ),
//   // );
//
//   // sl.registerLazySingleton<NumberTriviaLocalDataSource>(
//   //   () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
//   // );
//
//   //! Core
//   // sl.registerLazySingleton(() => InputConverter());
//   // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
//
//   //! External
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPreferences);
//   sl.registerLazySingleton(() => Dio());
//   // sl.registerLazySingleton(() => DataConnectionChecker());
// }
