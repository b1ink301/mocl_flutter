import 'package:get_it/get_it.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/presentation/block/main_data_json_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/mocl_local_database.dart';
import '../data/datasources/mocl_main_data_source.dart';
import '../domain/usecases/get_main_list.dart';
import '../domain/usecases/set_main_list.dart';
import 'block/main_data_bloc.dart';

/*
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - MainData
  // DataBase
  sl.registerSingletonAsync<LocalDatabase>(() async {
    final localDatabase = LocalDatabase();
    return localDatabase;
  });

  // Data sources
  sl.registerSingletonWithDependencies<MainDataSource>(
      () => MainDataSourceImpl(localDatabase: sl()),
      dependsOn: [LocalDatabase]);

  // Repository
  // sl.registerSingletonWithDependencies<MoclRepository>(
  //     () => MoclRepositoryImpl(mainDataSource: sl()),
  //     dependsOn: [MainDataSource]);

  // Use cases
  sl.registerSingletonWithDependencies(() => GetMainList(moclRepository: sl()),
      dependsOn: [MoclRepository]);
  sl.registerSingletonWithDependencies(
      () => GetMainListFromJson(moclRepository: sl()),
      dependsOn: [MoclRepository]);
  sl.registerSingletonWithDependencies(() => SetMainList(moclRepository: sl()),
      dependsOn: [MoclRepository]);

  await sl.isReady<SetMainList>();

  // Bloc
  sl.registerFactory(
    () => MainDataBloc(
      getMainList: sl(),
      setMainList: sl(),
    ),
  );

  sl.registerFactory(
    () => MainDataJsonBloc(
      getMainListFromJson: sl(),
      setMainList: sl(),
    ),
  );

  // sl.registerLazySingleton<NumberTriviaLocalDataSource>(
  //   () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  // );

  //! Core
  // sl.registerLazySingleton(() => InputConverter());
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  // sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton(() => DataConnectionChecker());
}
*/